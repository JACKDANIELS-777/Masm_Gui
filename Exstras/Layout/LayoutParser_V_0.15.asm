; =============================================================================
; MASM x64 Layout Engine v0.15

; Author: JACKDANIELS-777
; Description: A dynamic UI parser that generates Windows Common Controls
;              (Static, Edit, Button, Combo, ListBox, Scroll) from a data string.
; Syntax: "Type,ID,X,Y,W,H,Text,\c" etc
; =============================================================================

include constants.inc

extern AppendMenuA      : proc
extern CreateMenu       : proc
extern CreateLabelEdit  : proc
extern MessageBoxA      : proc
extern hwndMain         : qword

.data
; Sample Layout String for all supported controls
; L=Static, B=Button, E=Edit, C=Combo, X=ListBox, S=Scroll
LayoutStr db "L,101,10,10,150,25,Label/Static,\c"
          db "B,102,10,40,150,30,Button Control,\c"
          db "E,103,10,80,150,25,Edit Input,\c"
          db "C,104,10,120,150,200,Combo Box,\c"
          db "X,105,100,10,150,100,ListBox,\c"
          db "S,106,260,10,25,150,Scroll,\c", 0

; Window Class Strings
Static    db "STATIC", 0
LBL       db "edit", 0
BTN       db "BUTTON", 0
COMBOBOX  db "COMBOBOX", 0
LISTBOX   db "LISTBOX", 0
SCROLLBAR db "SCROLLBAR", 0

.code

; -----------------------------------------------------------------------------
; LayoutParser
; Parses the LayoutStr and calls CreateLabelEdit for each control found.
; -----------------------------------------------------------------------------
LayoutParser proc
    lea rdx, LayoutStr
    mov r15, rcx            ; Pointer to memory
    mov r14, rdx            ; Pointer to string
    
    mov r13, 0
    mov rbx, 0              ; Command index
    mov r12, 0              ; Current position in segment
    sub rsp, 100h           ; Shadow space and local variable storage

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
    sub rsp, 20h
    mov rcx, 0
    mov rdx, r15
    mov r8, r15
    mov r9, 2
    call MessageBoxA
    add rsp, 20h
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

    ; Preservation of loop state
    mov qword ptr[rsp + 80], r14
    mov qword ptr[rsp + 88], r15
    mov qword ptr[rsp + 72], r13
    mov qword ptr[rsp + 64], r12

    ; Class selection logic using CMOVE
    mov rbx, qword ptr[rsp+8]     ; Control ID
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

    mov qword ptr[r15+r12], 0     ; Null terminate string in buffer
    mov r8, r15                   ; Window text pointer
    mov r9, 50000000h             ; WS_CHILD | WS_VISIBLE
    mov r10, qword ptr[rsp+16]    ; X
    mov r11, qword ptr[rsp+24]    ; Y
    mov r12, qword ptr[rsp+32]    ; Width
    mov r13, qword ptr[rsp+40]    ; Height
    mov r14, hwndMain
    mov r15, 0                    ; Param
    call CreateLabelEdit

    ; Restore loop state
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
    xor rax, rax
    ret
LayoutParser endp

; -----------------------------------------------------------------------------
; StrToInt
; RCX = String Pointer
; Returns integer in RAX
; -----------------------------------------------------------------------------
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

end
