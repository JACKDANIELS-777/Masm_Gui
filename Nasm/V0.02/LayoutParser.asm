; =========================================================================================
; Module Name:  LayoutEngine.asm (v0.26 - Strict 1:1 Port to NASM x86_64)
; Assemble:     nasm -f win64 LayoutEngine.asm -o LayoutEngine.obj
; =========================================================================================

default rel

%include "./constants.inc"

; --- External Symbol Linkage Maps ---
extern AppendMenuA
extern CreateMenu
extern CreateLabelEdit
extern MessageBoxA
extern DefSubclassProc
extern SetWindowSubclass
extern Color32
extern SetTextColor
extern SetBkMode
extern GetStockObject
extern SendMessageA
extern FillRect
extern GetClientRect
extern EndPaint
extern BeginPaint
extern SetWindowTheme
extern GetDC
extern ValidateRect
extern InvalidateRect
extern ReleaseDC
extern GetWindowTextA
extern DrawTextA
extern SetWindowTextA
extern SetWindowLongPtrA
extern GetWindowLongPtrA
extern UpdateWindow
extern RegisterBtn
extern GetLastError
extern SetParent
extern RegisterCustomDlgProc
extern SetFocus
extern hwndMain
extern CreateThread
extern CreateLabelEditThread
extern CreateMainWnd
extern RegisterMainWnd
extern TrenchScriptProc

extern MainHandle
extern RegisterEdit
extern EditClassName

section .data
    ; --- Global Handles & State Flags ---
    BTNHANDLE       dq 0
    hLastWnd        dq 0            ; Current Active Handle ("The Cursor")
    hLastWndActive  dq 0            ; Context Switch Flag
    bLockParent     dq 0            ; Hierarchy Lock Toggle (V0.23)
    AttrVal         db 0
    AttrBuffer      times 100 db 0

    Percent         db 0
    
    align 16
    global AttrDataBuffer
    AttrDataBuffer  times 256 db 0
    
    align 16
    global DelayedBuffer
    DelayedBuffer   times 1000 db 0

    ; --- Threading Data ---
    global ThreadPtr
    global ThreadData
    ThreadPtr       db 0
    ThreadData      times 10 dq 0

    WindowManager   db 0

    ; --- Layout Configuration ---
    LayoutStr       db "B,101,10,10,100,100,Edit here,\c", 0
                   
    ; --- Win32 Class Constants ---
    WinStatic           db "STATIC", 0   ; Renamed from 'Static' to evade NASM keyword conflict
    LBL                 db "edit", 0
    BTN                 db "BUTTON", 0
    COMBOBOX            db "COMBOBOX", 0
    LISTBOX             db "LISTBOX", 0
    SCROLLBAR           db "SCROLLBAR", 0
    BtnClassName        db "Custom Btn", 0
    CustomDLGCLASSNAME  db "Custom DLG", 0
    MainHandle dq 0

    global procs
    procs:
        dq random_proc
        dq random_proc_1

section .text

global random_proc
random_proc:
    nop
    ret

global random_proc_1
random_proc_1:
    sub rsp, 0x20

    mov rcx, 0
    lea rdx, [LayoutStr]
    mov r8, 0
    mov r9, 2
    call MessageBoxA
    add rsp, 0x20
    ret

; -----------------------------------------------------------------------------------------
; LayoutParser: The core of the Binsapd Engine
; -----------------------------------------------------------------------------------------
global LayoutParser
LayoutParser:
    lea rax, [LayoutStr]
    cmp rdx, 0
    cmove rdx, rax
    mov r15, rcx             ; Local memory work area
    mov r14, rdx             ; Layout string pointer
    
    mov r13, 0
    mov rbx, 0               ; Parameter index counter
    mov r12, 0               ; Character offset
    sub rsp, 0x100           ; Preserve stack / Shadow space
    call RegisterBtn
    call RegisterCustomDlgProc
    call RegisterEdit

.loop:
    mov al, byte [r14]
    lea rdx, [.Byte]

    cmp byte [AttrVal], 1
    je .SkipToAttr

    lea rcx, [.add_control]
    cmp al, "\"
    cmove rdx, rcx

    lea rcx, [.Comma]
    cmp al, ","
    cmove rdx, rcx

.SkipToAttr:
    ; --- V0.23 Scope Logic ---
    lea rcx, [.SetbLockParent]
    cmp al, "("
    cmove rdx, rcx

    lea rcx, [.UnSetbLockParent]
    cmp al, ")"
    cmove rdx, rcx

    lea rcx, [.AttrO]
    cmp al, "{"
    cmove rdx, rcx

    lea rcx, [.AttrC]
    cmp al, "}"
    cmove rdx, rcx

    lea rcx, [.exit]
    cmp al, 0
    cmove rdx, rcx

    jmp rdx

.Byte:
    mov byte [r15], al
    add r15, 1
    add r13, 1
    add r12, 1
    jmp .continue

.SetbLockParent:
    mov qword [bLockParent], 1
    jmp .continue

.UnSetbLockParent:
    mov qword [bLockParent], 0
    mov rax, [hwndMain]        ; Reset focus to Main Window after group
    mov qword [hLastWnd], rax
    jmp .continue

.AttrO:
    mov byte [AttrVal], 1
    jmp .continue

.AttrC:
    mov byte [AttrVal], 0
    sub r15, r12
    mov byte [r15+r12], 0
    call AttrParser
    mov r12, 0
    jmp .continue

.Comma:
    cmp rbx, 0
    je .Type
    cmp rbx, 6
    je .Txt
    cmp rbx, 6
    jg .continue
    jmp .IntFound

.Type:
    sub r15, 1
    mov al, byte [r15]
    lea rdx, [.continue]
    lea rcx, [.Edit]
    cmp al, "E"
    cmove rdx, rcx
    lea rcx, [.Label]
    cmp al, "L"
    cmove rdx, rcx
    lea rcx, [.COMBO]
    cmp al, 'C'
    cmove rdx, rcx
    lea rcx, [.LISTBX]
    cmp al, 'X'
    cmove rdx, rcx
    lea rcx, [.SCROLL]
    cmp al, 'S'
    cmove rdx, rcx
    lea rcx, [.BTN]
    cmp al, "B"            
    cmove rdx, rcx
    lea rcx, [.CtmBtn]
    cmp al, 'Z'
    cmove rdx, rcx
    lea rcx, [.Add]
    cmp al, 'A'
    cmove rdx, rcx
    lea rcx, [.Rep]
    cmp al, 'R'
    cmove rdx, rcx
    lea rcx, [.CtmDlg]
    cmp al, 'Y'
    cmove rdx, rcx
    lea rcx, [.Delayed]
    cmp al, "!"
    cmove rdx, rcx

    lea rcx, [.Percent]
    cmp al, "P"
    cmove rdx, rcx

    lea rcx, [.WindowManager]
    cmp al, 'M'
    cmove rdx, rcx

    lea rcx, [.CustomEdit]
    cmp al, "F"
    cmove rdx, rcx

    jmp rdx

.Label:         
    mov qword [rsp+0], 1
    mov r12, 0
    add rbx, 1
    jmp .continue
.Edit:          
    mov qword [rsp+0], 2
    mov r12, 0
    add rbx, 1
    jmp .continue
.BTN:           
    mov qword [rsp+0], 3
    mov r12, 0
    add rbx, 1
    jmp .continue 
.COMBO:         
    mov qword [rsp+0], 4
    mov r12, 0
    add rbx, 1
    jmp .continue 
.LISTBX:        
    mov qword [rsp+0], 5
    mov r12, 0
    add rbx, 1
    jmp .continue 
.SCROLL:        
    mov qword [rsp+0], 6
    mov r12, 0
    add rbx, 1
    jmp .continue 
.CtmBtn:        
    mov qword [rsp+0], 7
    mov r12, 0
    add rbx, 1
    jmp .continue 
.CtmDlg:        
    mov qword [rsp+0], 8
    mov r12, 0
    add rbx, 1
    jmp .continue 

.Add:           
    mov qword [hLastWndActive], 1
    mov cl, byte [r15-1]
    mov byte [r15-1], cl         ; Recursive character swap
    mov r12, 0
    jmp .loop 

.CustomEdit:
    mov qword [rsp+0], 9
    mov r12, 0
    add rbx, 1
    jmp .continue

.Delayed:       
    mov rcx, 0
    mov rdx, 0
    mov rsi, r14

    sub rsi, r12
    mov rdi, 0
    mov r8, 0
    call FindDelayedStr

    mov r8, r12
    
    dec r12
.loop1:
    mov al, [r14-1]
    xor al, [r14-2]     
    xor [r14-2], al     
    xor al, [r14-2]     
    mov [r14-1], al     
    
    dec r14
    dec r12
    jnz .loop1
                     
    dec r14
    mov r12, r8

    call strcopy
    
    add r14, rcx
    jmp .loop

.Rep:           
    mov qword [hLastWndActive], 1
    mov cl, byte [r15-1]
    mov byte [r15-1], cl         ; Recursive character swap
    mov r12, 0
    jmp .loop 

.Percent:
    mov qword [Percent], 1
    mov cl, byte [r15-1]
    mov byte [r15-1], cl         ; Recursive character swap
    mov r12, 0
    jmp .loop 
    
.WindowManager:
    movzx rdi, byte [WindowManager]
    cmp rdi, 0
    jne .NoConfigure

    call RegisterMainWnd
    call CreateMainWnd

.NoConfigure:
    mov qword [WindowManager], 2
    mov cl, byte [r15-1]
    mov byte [r15-1], cl         ; Recursive character swap
    mov r12, 0
    jmp .loop 

.Txt:
    sub r15, r12
    jmp .continue

.IntFound:
    mov rcx, r15
    sub rcx, r12
    mov rdx, r12 
    call StrToInt
    mov r12, 0
    lea rdx, [.continue]
    lea rcx, [.ID]
    cmp rbx, 1 
    cmove rdx, rcx
    lea rcx, [.X_coordinate]
    cmp rbx, 2
    cmove rdx, rcx
    lea rcx, [.Y_coordinate]
    cmp rbx, 3
    cmove rdx, rcx
    lea rcx, [.Width]
    cmp rbx, 4
    cmove rdx, rcx
    lea rcx, [.Height]
    cmp rbx, 5
    cmove rdx, rcx
    jmp rdx

.ID:            
    mov qword [rsp+8], rax
    add rbx, 1
    jmp .continue
.X_coordinate:  
    mov qword [rsp+16], rax
    add rbx, 1
    jmp .continue
.Y_coordinate:  
    mov qword [rsp+24], rax
    add rbx, 1
    jmp .continue
.Width:         
    mov qword [rsp+32], rax
    add rbx, 1
    jmp .continue
.Height:        
    mov qword [rsp+40], rax
    add rbx, 1
    jmp .continue

.add_control:
    add r14, 1
    mov al, byte [r14]
    cmp al, "c"
    jne .continue 

    ; Save context
    mov qword [rsp+80], r14
    mov qword [rsp+88], r15
    mov qword [rsp+72], r13
    mov qword [rsp+64], r12

    ; Select class by type index
    mov rbx, qword [rsp+8]
    lea rdx, [WinStatic]
    lea r8, [LBL]
    cmp qword [rsp], 2
    cmove rdx, r8
    lea r8, [BTN]
    cmp qword [rsp], 3
    cmove rdx, r8
    lea r8, [COMBOBOX]
    cmp qword [rsp], 4
    cmove rdx, r8
    lea r8, [LISTBOX]
    cmp qword [rsp], 5
    cmove rdx, r8
    lea r8, [SCROLLBAR]
    cmp qword [rsp], 6
    cmove rdx, r8
    lea r8, [BtnClassName]
    cmp qword [rsp], 7
    cmove rdx, r8
    lea r8, [CustomDLGCLASSNAME]
    cmp qword [rsp], 8
    cmove rdx, r8

    lea r8, [EditClassName]
    cmp qword [rsp], 9
    cmove rdx, r8

    mov qword [r15+r12], 0       ; Null terminate text
    mov r8, r15                 ; Text pointer

    mov r9, 0x50000000          ; WS_CHILD | WS_VISIBLE
    or r9, 0x00010000           ; WS_TABSTOP

    call CheckWin               ; Handle Custom DLG styles

    lea r15, [.DoneCheckPercent]
    jmp CheckPercent

.DoneCheckPercent:
    ; Parent selection logic
    mov r14, [hwndMain]
    mov rax, qword [hLastWndActive]
    cmp rax, 1
    cmove r14, [hLastWnd]

    mov rax, qword [WindowManager]
    cmp rax, 2
    cmove r14, [MainHandle]

    mov r15, 0
    call CreateLabelEdit            ; The heavy lifter
    
    ; --- The "Goated" cmove Handle Decision (V0.23) ---
    mov rdi, [hLastWnd]             ; Preserve previous
    cmp qword [bLockParent], 1      ; Are we locked in a group?
    cmove rax, [hLastWnd]           ; If locked, DON'T update the cursor
    
    mov [hLastWnd], rax             ; Commit handle change or stay locked
    mov qword [hLastWndActive], 0

    ; Restore context
    mov r13, qword [rsp+72]
    mov r12, qword [rsp+64]
    mov r14, qword [rsp+80]
    mov r15, qword [rsp+88]
    mov r12, 0
    mov rbx, 0
    jmp .continue

.continue:
    add r14, 1
    jmp .loop

.exit:
    add rsp, 0x100
    xor rax, rax
    ret

global DeleayedCreation
DeleayedCreation:
    jmp rbx

global FindDelayedStr
FindDelayedStr:
.loop:
    mov dl, byte [rsi]
    cmp dl, "\"
    je .Add
    cmp dl, ")"
    je .Close
    mov rax, 1
    cmp dl, "("
    cmove r8, rax
    jmp .continue

.Add:
    mov dl, byte [rsi+1]
    cmp dl, "c"
    jne .continue

    add rcx, 1
    add rsi, 1
    cmp r8, 1
    
    je .continue
    mov dl, byte [rsi+1]
    cmp dl, "("
    je .continue

    add rcx, 1
    jmp .done

.continue:
    add rsi, 1
    add rcx, 1
    jmp .loop

.Close:
.done:
    ret

global AttrParser
AttrParser:
    push r13
    push r12
    mov r13, 0
.loop:
    inc r15
    mov al, byte [r15]
    mov rdx, .Byte
    lea rcx, [.exit]
    cmp al, 0
    cmove rdx, rcx
    lea rcx, [.Comma]
    cmp al, ","
    cmove rdx, rcx
    lea rcx, [.Colon]
    cmp al, ":"
    cmove rdx, rcx
    jmp rdx

.Byte:
    inc r12
    jmp .loop

.Colon:
    movzx rax, byte [r15-1]
    and al, 0x1F          
    dec al                          ; A=0
    mov r13, rax
    movzx ecx, al
    mov edi, 1           
    shl edi, cl           
    or dword [AttrDataBuffer], edi 
    mov r12, 0
    jmp .loop

.Comma:
    mov rcx, r15
    sub rcx, r12
    mov rdx, r12 
    call StrToInt
    lea rdx, [AttrDataBuffer + 32] 
    shl r13, 3                      
    add rdx, r13                    
    mov qword [rdx], rax                 
    xor r13, r13
    jmp .loop

.exit:
    pop r12
    pop r13
    ret

; -----------------------------------------------------------------------------------------
; Helper Functions (StrToInt, CheckWin)
; -----------------------------------------------------------------------------------------
global StrToInt
StrToInt:
    xor rax, rax
    xor r8, r8
.next_char:
    mov r8b, byte [rcx]
    sub r8b, '0'
    cmp r8b, 9
    ja .done
    imul rax, 10
    add rax, r8
    inc rcx
    jmp .next_char
.done:
    ret

global CheckPercent
CheckPercent:
    cmp byte [Percent], 0
    jne .Percent

    mov r10, qword [rsp+16]
    mov r11, qword [rsp+24]
    mov r12, qword [rsp+32]
    mov r13, qword [rsp+40]

    jmp r15

.Percent:
    mov byte [Percent], 0
    mov r14, rdx

    sub rsp, 0x70

    mov rcx, [hwndMain]
    lea rdx, [rsp+0x20]
    call GetClientRect
    mov rdx, r14
    
    mov r10, qword [rsp+0x90]
    mov r11, qword [rsp+0x98]

    mov r14d, dword [rsp+0x28] 
    mov rax, r14    
    mov r14, rdx
    xor rdx, rdx   
    mov r12, 100
    mul r10         
    div r12
    
    mov r12, rax    
    mov rdx, r14

    mov r14d, dword [rsp+0x32] 
    mov rax, r14    
    mov r14, rdx
    xor rdx, rdx    
    mov r13, 100
    mul r11         
    div r13

    mov r13, rax    
    mov rdx, r14
    
    add rsp, 0x70
    
    mov r10, qword [rsp+16]
    mov r11, qword [rsp+24]
    jmp r15

global CheckWin
CheckWin:
    push rdx
    push rcx
    push rax
    mov rcx, 0x10CF0000 ; Standard Window Style
    lea rax, [CustomDLGCLASSNAME]
    cmp rdx, rax
    cmove r9, rcx
    pop rax
    pop rcx
    pop rdx
    ret

global strcopy
strcopy:
    mov rax, 0
    lea rsi, [DelayedBuffer]
    mov r8, r14
.loop:
    mov dil, byte [r8]
    mov byte [rsi], dil

    inc rsi
    inc r8
    inc rax
    cmp rax, rcx
    jne .loop
    
    mov byte [rsi+1], 0
    ret

    RegisterBtn:
    xor eax, eax
    ret

RegisterCustomDlgProc:
    xor eax, eax
    ret

RegisterMainWnd:
    xor eax, eax
    ret

CreateMainWnd:
    xor eax, eax
    ret
