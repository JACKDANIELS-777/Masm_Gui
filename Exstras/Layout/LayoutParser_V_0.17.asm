; =============================================================================
; MASM x64 Layout Engine v0.15
; Author: JACKDANIELS-777
; =============================================================================

include constants.inc

extern AppendMenuA       : proc
extern CreateMenu        : proc
extern CreateLabelEdit   : proc
extern MessageBoxA       : proc
extern DefSubclassProc   : proc
extern SetWindowSubclass : proc
extern Color32           : proc
extern SetTextColor      : proc
extern SetBkMode         : proc
extern GetStockObject    : proc
extern SendMessageA      : proc
extern FillRect          : proc
extern GetClientRect     : proc
extern EndPaint          : proc
extern BeginPaint        : proc
extern SetWindowTheme    : proc
extern GetDC             : proc
extern ValidateRect      : proc
extern ReleaseDC         : proc
extern GetWindowTextA    : proc
extern DrawTextA         : proc
extern SetWindowTextA    : proc
extern hwndMain          : qword

.data
    BTNHANDLE qword 0
    LayoutStr db "B,102,10,40,150,30,Button Control,\c", 0

    Static    db "STATIC", 0
    LBL       db "edit", 0
    BTN       db "BUTTON", 0
    COMBOBOX  db "COMBOBOX", 0
    LISTBOX   db "LISTBOX", 0
    SCROLLBAR db "SCROLLBAR", 0

.code

LayoutParser proc
    push rbp
    mov rbp, rsp
    sub rsp, 100h
    
    lea rdx, LayoutStr
    mov r15, rcx
    mov r14, rdx
    mov r13, 0
    mov rbx, 0
    mov r12, 0

_loop:
    mov al, byte ptr[r14]
    cmp al, 0
    je _exit
    cmp al, "\"
    je _add_control
    cmp al, ","
    je _Comma

    mov byte ptr[r15], al
    add r15, 1
    add r13, 1
    add r12, 1
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
    jmp _continue
    
_Label:
    mov qword ptr[rsp+0], 1
    mov r12, 0
    add rbx, 1
    jmp _continue

_Edit:
    mov qword ptr[rsp+0], 2
    mov r12, 0
    add rbx, 1
    jmp _continue

_BTN:
    mov qword ptr[rsp+0], 3
    mov r12, 0
    add rbx, 1
    jmp _continue 

_COMBO:
    mov qword ptr[rsp+0], 4
    mov r12, 0
    add rbx, 1
    jmp _continue 

_LISTBX:
    mov qword ptr[rsp+0], 5
    mov r12, 0
    add rbx, 1
    jmp _continue 

_SCROLL:
    mov qword ptr[rsp+0], 6
    mov r12, 0
    add rbx, 1
    jmp _continue 

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

_ID:
    mov qword ptr[rsp+8], rax
    add rbx, 1
    jmp _continue

_X_coordinate:
    mov qword ptr[rsp+16], rax
    add rbx, 1
    jmp _continue

_Y_coordinate:
    mov qword ptr[rsp+24], rax
    add rbx, 1
    jmp _continue

_Width:
    mov qword ptr[rsp+32], rax
    add rbx, 1
    jmp _continue

_Height:
    mov qword ptr[rsp+40], rax
    add rbx, 1
    jmp _continue
    
_add_control:
    add r14, 1
    mov al, byte ptr[r14]
    cmp al, "c"
    jne _continue 

    mov qword ptr[rsp + 80], r14
    mov qword ptr[rsp + 88], r15
    mov qword ptr[rsp + 72], r13
    mov qword ptr[rsp + 64], r12

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

    mov qword ptr[r15+r12], 0
    mov r8, r15
    mov r9, 50000000h
    mov r10, qword ptr[rsp+16]
    mov r11, qword ptr[rsp+24]
    mov r12, qword ptr[rsp+32]
    mov r13, qword ptr[rsp+40]
    mov r14, hwndMain
    mov r15, 0
    call CreateLabelEdit
    mov BTNHANDLE, rax

    mov r15, rax
    sub rsp, 28h
    mov rcx, rax
    mov rdx, AutoEditLogic
    mov r8, qword ptr[rsp+8]
    mov r9, 0
    call SetWindowSubclass
    add rsp, 28h

    sub rsp, 28h
    mov rcx, r15
    mov rdx, 48059
    mov r8, 0
    xor r9, r9
    call SendMessageA
    add rsp, 28h

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
    leave
    xor rax, rax
    ret
LayoutParser endp

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

AutoEditLogic proc
    push rbp
    mov rbp, rsp
    sub rsp, 40h

    mov [rbp-8],  rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov [rbp-32], r9

    cmp rdx, 512
    je _BUTTONHOVER
    cmp rdx, 673
    je _BUTTONHOVER
    cmp rdx, 513
    je _BUTTONCLICK

_Default:
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8,  [rbp-24]
    mov r9,  [rbp-32]
    mov rax, [rbp+30h]
    mov [rsp+20h], rax
    mov rax, [rbp+38h]
    mov [rsp+28h], rax
    call DefSubclassProc
    leave
    ret

_BUTTONCLICK:
    sub rsp, 28h
    mov rcx, [rbp-8]
    lea rdx, LBL
    call SetWindowTextA
    add rsp, 28h
    jmp _Default

_BUTTONHOVER:
    sub rsp, 28h
    mov rcx, [rbp-8]
    lea rdx, Static
    call SetWindowTextA
    add rsp, 28h
    jmp _Default

_HandleColor:
    mov r15, [rbp-24]
    mov r15, BTNHANDLE
    sub rsp, 20h
    mov r8d, 0
    mov r9d, 10
    mov r10d, 210
    call Color32
    mov rcx, r15
    mov rdx, rax
    call SetTextColor
    add rsp, 20h

    sub rsp, 28h
    mov rcx, r15
    mov rdx, 2
    call SetBkMode
    add rsp, 28h

    sub rsp, 28h
    mov rcx, 4
    call GetStockObject
    add rsp, 28h
    leave
    ret

_ButtonPaint:
    mov rcx, [rbp-8]
    sub rsp, 28h
    call GetDC
    mov r11, rax
    add rsp, 28h

    mov rcx, [rbp-8]
    lea rdx, [rbp-48]
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    sub rsp, 28h
    mov rcx, 4
    call GetStockObject
    add rsp, 28h
    mov r8, rax
    mov rcx, r11
    lea rdx, [rbp-48]
    sub rsp, 28h
    call FillRect
    add rsp, 28h

    lea rdx, [rbp-128]
    mov r8, 64
    mov rcx, [rbp-8]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    mov rcx, r11
    lea rdx, [rbp-128]
    mov r8, -1
    lea r9, [rbp-48]
    sub rsp, 30h 
    mov dword ptr [rsp+20h], 25h
    call DrawTextA
    add rsp, 30h

    mov rcx, [rbp-8]
    mov rdx, r11
    sub rsp, 28h
    call ReleaseDC
    add rsp, 28h

    mov rcx, [rbp-8]
    xor rdx, rdx
    sub rsp, 28h
    call ValidateRect
    add rsp, 28h
    mov rax, 1
    leave
    ret
AutoEditLogic endp

end
