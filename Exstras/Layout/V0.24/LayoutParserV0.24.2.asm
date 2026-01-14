; =========================================================================================
; {s:qword } first pos  ;first pos 0-9,223,372,036,854,775,807 ;first negative 9,223,372,036,854,775,808 -> max 2^64 ie inflate or deflate rect
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
    AttrVal db 0
    AttrBuffer db 100 dup(0)
    public AttrDataBuffer
    AttrDataBuffer db 128 dup(0)

    ; --- Threading Data ---
    public ThreadPtr
    public ThreadData
    ThreadPtr       db 0
    ThreadData      dq 10 dup(0)

    ; --- Layout Configuration ---
    ; Syntax Example: "(ZA...)" locks all child buttons to the preceding window.
    LayoutStr       db "Z,100,50,50,100,100,{f:10,b:10,s:10,}Aqaabbbbb,\c"
                   db "Z,10,100,100,100,100,{a:5,b:1,f:10,s:9223372036854775818,}90,\c"
                   db "Y,0,1000,100,240,160,{a:5,b:51,f:25,s:1}90,\c",
                   

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

    lea rdx,_Byte

    cmp byte ptr[AttrVal],1
    je _SkipToAttr


    lea rcx, _add_control
    cmp al, "\"
    ;je _add_control
    cmove rdx,rcx

    lea rcx,_Comma
    cmp al, ","
    ;je _Comma
    cmove rdx,rcx
_SkipToAttr:
    ; --- V0.23 Scope Logic ---
    lea rcx,_SetbLockParent
    cmp al, "("
    ;je _SetbLockParent
    cmove rdx,rcx


    lea rcx,_UnSetbLockParent
    cmp al, ")"
    ;je _UnSetbLockParent
    cmove rdx,rcx

    lea rcx,_AttrO
    cmp al,"{"
    cmove rdx,rcx

    lea rcx,_AttrC
    cmp al,"}"
    cmove rdx,rcx




    lea rcx,_exit
    cmp al, 0
    cmove rdx,rcx


    jmp rdx
_Byte:
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
_AttrO:
    mov byte ptr[AttrVal],1
    
    jmp _continue

_AttrC:
    mov byte ptr[AttrVal],0
    sub r15,r12
    mov byte ptr[r15+r12],0
    call AttrParser
    mov r12,0

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

    lea rdx, _continue

    lea rcx,_Edit
    cmp al, "E"
    cmove rdx,rcx

    lea rcx,_Label
    cmp al, "L"
    cmove rdx,rcx

    lea rcx, _COMBO
cmp al, 'C'
cmove rdx, rcx

lea rcx, _LISTBX
cmp al, 'X'
cmove rdx, rcx

lea rcx, _SCROLL
cmp al, 'S'
cmove rdx, rcx

lea rcx, _CtmBtn
cmp al, 'Z'
cmove rdx, rcx

lea rcx, _Add
cmp al, 'A'
cmove rdx, rcx

lea rcx, _Rep
cmp al, 'R'
cmove rdx, rcx

lea rcx, _CtmDlg
cmp al, 'Y'
cmove rdx, rcx

    
    jmp rdx
    ;Skipped old be ruled out by V0.24
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
    cmp al, "R"
    je _Rep
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
    _Rep:
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
    
    lea rdx, _continue

    lea rcx, _ID
    cmp rbx, 1 
    cmove rdx,rcx
    ;je _ID

    lea rcx,_X_coordinate
    cmp rbx, 2
    cmove rdx,rcx
    ;je _X_coordinate
    
    lea rcx,_Y_coordinate
    cmp rbx, 3
    cmove rdx,rcx
    ;je _Y_coordinate
    

    lea rcx,_Width
    cmp rbx, 4
    cmove rdx,rcx
    ;je _Width
   

    lea rcx,_Height
    cmp rbx, 5
    cmove rdx,rcx
    ;je _Height
  
    jmp rdx
    
    ;jmp _continue

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
    ;sub rsp, 28h
    ;mov rcx, BTNHANDLE
    ;mov rdx, 48059                  ; Trigger final redraw
    ;mov r8, 0
    ;xor r9, r9
    ;call SendMessageA
    ;add rsp, 28h
    xor rax, rax
    ret
LayoutParser endp

AttrParser proc
push r13
push r12
mov r13,0
_loop:
    inc r15
    
    mov al, byte ptr[r15]

    mov rdx, _Byte

    lea rcx,_exit
    cmp al,0
    cmove rdx,rcx

    lea rcx,_Comma
    cmp al,","
    
    cmove rdx,rcx

    lea rcx,_Colon
    cmp al,":"
    cmove rdx,rcx


    jmp rdx
_Byte:
    ;redundant for now
    ;mov byte ptr [AttrBuffer], al
    inc r12

    jmp _loop

_Colon:
    mov al,byte ptr[r15-1]
    and al, 1Fh         
    dec al               ; A=0
    mov r13,rax
    movzx ecx, al
    
   
    mov edi, 1          
    shl edi, cl          
                         

    
    or dword ptr [AttrDataBuffer], edi 
    mov r12,0

    jmp _loop

_Comma:
    mov rcx, r15
    sub rcx, r12
    mov rdx, r12 
    call StrToInt

    ;rax holds the value

    lea rdx,[AttrDataBuffer]
    lea rdx, [AttrDataBuffer + 32] 
    shl r13, 3                     
    add rdx, r13                   
    
    mov qword ptr[rdx], rax                
    
    ; 3. Reset R13 for the next attribute
    xor r13, r13
    jmp _loop
_exit:
    pop r12
    pop r13
    ret
AttrParser endp
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
