; =========================================================================================
; Module Name: LayoutParser.asm (v0.23)
; Framework:   LayoutParser
; Description: x64 MASM UI Engine with Scoped Nesting and Hierarchical Layout.
; Feature:     Introduces "Parent Locking" via () syntax for nested control groups.
; =========================================================================================

include constants.inc

; --- External Win32 API Definitions ---
extern AppendMenuA            : proc
extern CreateMenu             : proc
extern CreateLabelEdit        : proc
extern MessageBoxA            : proc
extern DefSubclassProc        : proc
extern SetWindowSubclass      : proc
extern Color32                : proc
extern SetTextColor           : proc
extern SetBkMode              : proc
extern GetStockObject         : proc
extern SendMessageA           : proc
extern FillRect               : proc
extern GetClientRect          : proc
extern EndPaint               : proc
extern BeginPaint             : proc
extern SetWindowTheme         : proc
extern GetDC                  : proc
extern ValidateRect           : proc
extern InvalidateRect         : proc
extern ReleaseDC              : proc
extern GetWindowTextA         : proc
extern DrawTextA              : proc
extern SetWindowTextA         : proc
extern SetWindowLongPtrA      : proc
extern GetWindowLongPtrA      : proc
extern UpdateWindow           : proc
extern RegisterBtn            : proc
extern GetLastError           : proc
extern SetParent              : proc
extern RegisterCustomDlgProc  : proc
extern SetFocus               : proc
extern hwndMain               : qword
extern CreateThread           : proc
extern CreateLabelEditThread  : proc

.data
    ; --- Global Handles & State Flags ---
    BTNHANDLE       dq 0
    hLastWnd        dq 0            ; Current Active Handle ("The Cursor")
    hLastWndActive  dq 0            ; Context Switch Flag
    bLockParent     dq 0            ; Hierarchy Lock Toggle (V0.23)

    ; --- Threading Data ---
    public ThreadPtr
    public ThreadData
    ThreadPtr       db 0
    ThreadData      dq 10 dup(0)

    ; --- Layout Configuration ---
    ; Syntax Example: "(ZA...)" locks all child buttons to the preceding window.
    LayoutStr       db "Y,0,500,5,240,160,A,\c"
                    db "(ZA,10,50,50,24,16,AA,\c"
                    db "ZA,100,500,50,24,16,AA,\c"
                    db "ZA,1000,120,50,24,16,AA,\c)",0

    ; --- Win32 Class Constants ---
    Static              db "STATIC", 0
    LBL                 db "edit", 0
    BTN                 db "BUTTON", 0
    COMBOBOX            db "COMBOBOX", 0
    LISTBOX             db "LISTBOX", 0
    SCROLLBAR           db "SCROLLBAR", 0
    BtnClassName        db "Custom Btn", 0
    CustomDLGCLASSNAME  db "Custom DLG", 0

.code

; -----------------------------------------------------------------------------------------
; LayoutParser: The core of the Binsapd Engine
; -----------------------------------------------------------------------------------------
LayoutParser proc
    lea rdx, LayoutStr
    mov r15, rcx             ; Local memory work area
    mov r14, rdx             ; Layout string pointer
    
    mov r13, 0
    mov rbx, 0               ; Parameter index counter
    mov r12, 0               ; Character offset
    sub rsp, 100h            ; Preserve stack / Shadow space
    call RegisterBtn
    call RegisterCustomDlgProc

_loop:
    mov al, byte ptr[r14]
    cmp al, 0
    je _exit
    cmp al, "\"
    je _add_control
    cmp al, ","
    je _Comma

    ; --- V0.23 Scope Logic ---
    cmp al, "("
    je _SetbLockParent
    cmp al, ")"
    je _UnSetbLockParent

    mov byte ptr[r15], al
    add r15, 1
    add r13, 1
    add r12, 1
    jmp _continue

_SetbLockParent:
    mov qword ptr [bLockParent], 1
    jmp _continue

_UnSetbLockParent:
    mov qword ptr [bLockParent], 0
    mov rax, hwndMain        ; Reset focus to Main Window after group
    mov qword ptr[hLastWnd], rax
    jmp _continue

_Comma:
    cmp rbx, 0
    je _Type
    cmp rbx, 6
    je _Txt
    cmp rbx, 6
    jg _continue
    jmp _IntFound

_Type:
    sub r15, 1
    mov al, byte ptr[r15]
    cmp al, "E"
    je _Edit
    cmp al, "L"
    je _Label
    cmp al, "B"
    je _BTN
    cmp al, "C"
    je _COMBO
    cmp al, "X"
    je _LISTBX
    cmp al, "S"
    je _SCROLL
    cmp al, "Z"
    je _CtmBtn
    cmp al, "A"
    je _Add
    cmp al, "Y"
    je _CtmDlg
    jmp _continue
    
    _Label:         mov qword ptr[rsp+0], 1
                    mov r12, 0
                    add rbx, 1
                    jmp _continue
    _Edit:          mov qword ptr[rsp+0], 2
                    mov r12, 0
                    add rbx, 1
                    jmp _continue
    _BTN:           mov qword ptr[rsp+0], 3
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _COMBO:         mov qword ptr[rsp+0], 4
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _LISTBX:        mov qword ptr[rsp+0], 5
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _SCROLL:        mov qword ptr[rsp+0], 6
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _CtmBtn:        mov qword ptr[rsp+0], 7
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _CtmDlg:        mov qword ptr[rsp+0], 8
                    mov r12, 0
                    add rbx, 1
                    jmp _continue 
    _Add:
        mov qword ptr[hLastWndActive], 1
        mov cl, byte ptr[r15-1]
        mov byte ptr[r15-1], cl     ; Recursive character swap
        mov r12, 0
        jmp _loop 

_Txt:
    sub r15, r12
    jmp _continue

_IntFound:
    mov rcx, r15
    sub rcx, r12
    mov rdx, r12 
    call StrToInt
    mov r12, 0
    cmp rbx, 1 
    je _ID
    cmp rbx, 2
    je _X_coordinate
    cmp rbx, 3
    je _Y_coordinate
    cmp rbx, 4
    je _Width
    cmp rbx, 5
    je _Height
    jmp _continue

    _ID:            mov qword ptr[rsp+8], rax
                    add rbx, 1
                    jmp _continue
    _X_coordinate:  mov qword ptr[rsp+16], rax
                    add rbx, 1
                    jmp _continue
    _Y_coordinate:  mov qword ptr[rsp+24], rax
                    add rbx, 1
                    jmp _continue
    _Width:         mov qword ptr[rsp+32], rax
                    add rbx, 1
                    jmp _continue
    _Height:        mov qword ptr[rsp+40], rax
                    add rbx, 1
                    jmp _continue
    
_add_control:
    add r14, 1
    mov al, byte ptr[r14]
    cmp al, "c"
    jne _continue 

    ; Save context
    mov qword ptr[rsp+80], r14
    mov qword ptr[rsp+88], r15
    mov qword ptr[rsp+72], r13
    mov qword ptr[rsp+64], r12

    ; Select class by type index
    mov rbx, qword ptr[rsp+8]
    lea rdx, Static
    lea r8, LBL
    cmp qword ptr[rsp], 2
    cmove rdx, r8
    lea r8, BTN
    cmp qword ptr[rsp], 3
    cmove rdx, r8
    lea r8, COMBOBOX
    cmp qword ptr[rsp], 4
    cmove rdx, r8
    lea r8, LISTBOX
    cmp qword ptr[rsp], 5
    cmove rdx, r8
    lea r8, SCROLLBAR
    cmp qword ptr[rsp], 6
    cmove rdx, r8
    lea r8, BtnClassName
    cmp qword ptr[rsp], 7
    cmove rdx, r8
    lea r8, CustomDLGCLASSNAME
    cmp qword ptr[rsp], 8
    cmove rdx, r8

    mov qword ptr[r15+r12], 0       ; Null terminate text
    mov r8, r15                     ; Text pointer
    mov r9, 50000000h               ; WS_CHILD | WS_VISIBLE
    or r9, 00010000h                ; WS_TABSTOP

    call CheckWin                   ; Handle Custom DLG styles

    ; Coordinate block
    mov r10, qword ptr[rsp+16]
    mov r11, qword ptr[rsp+24]
    mov r12, qword ptr[rsp+32]
    mov r13, qword ptr[rsp+40]
    
    ; Parent selection logic
    mov r14, hwndMain
    mov rax, qword ptr[hLastWndActive]
    cmp rax, 1
    cmove r14, hLastWnd
    
    mov r15, 0
    lock inc byte ptr[ThreadPtr]
    call CreateLabelEdit            ; The heavy lifter
    
    ; --- The "Goated" cmove Handle Decision (V0.23) ---
    mov rdi, hLastWnd               ; Preserve previous
    cmp qword ptr[bLockParent], 1   ; Are we locked in a group?
    cmove rax, hLastWnd             ; If locked, DON'T update the cursor
    
    mov hLastWnd, rax               ; Commit handle change or stay locked
    mov qword ptr[hLastWndActive], 0

    ; Restore context
    mov r13, qword ptr[rsp+72]
    mov r12, qword ptr[rsp+64]
    mov r14, qword ptr[rsp+80]
    mov r15, qword ptr[rsp+88]
    mov rbx, 0
    jmp _continue

_continue:
    add r14, 1
    jmp _loop

_exit:
    add rsp, 100h
    sub rsp, 28h
    mov rcx, BTNHANDLE
    mov rdx, 48059                  ; Trigger final redraw
    mov r8, 0
    xor r9, r9
    call SendMessageA
    add rsp, 28h
    xor rax, rax
    ret
LayoutParser endp

; -----------------------------------------------------------------------------------------
; Helper Functions (StrToInt, AutoEditLogic, CheckWin)
; -----------------------------------------------------------------------------------------

StrToInt proc
    xor rax, rax
    xor r8, r8
_next_char:
    mov r8b, byte ptr [rcx]
    sub r8b, '0'
    cmp r8b, 9
    ja _done
    imul rax, 10
    add rax, r8
    inc rcx
    jmp _next_char
_done:
    ret
StrToInt endp

CheckWin proc
    push rdx
    push rcx
    push rax
    mov rcx, 10CF0000h ; Standard Window Style
    lea rax, CustomDLGCLASSNAME
    cmp rdx, rax
    cmove r9, rcx
    pop rax
    pop rcx
    pop rdx
    ret
CheckWin endp

end
