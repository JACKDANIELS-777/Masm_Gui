; =============================================================================
; MASM x64 Layout Engine v0.17
; Author: JACKDANIELS-777
; Description: A dynamic UI parser that generates Windows Common Controls
;              (Static, Edit, Button, Combo, ListBox, Scroll) from a data string.
; Syntax: "Type,ID,X,Y,W,H,Text,\c" etc 
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
    ; Sample Layout String for all supported controls
    ; L=Static, B=Button, E=Edit, C=Combo, X=ListBox, S=Scroll
    BTNHANDLE qword 0
    LayoutStr db "B,102,10,40,150,30,Button Control,\c", 0

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
    jmp _continue
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
    mov BTNHANDLE,rax

    mov r15,rax
    sub rsp,28h
    mov rcx,rax
    mov rdx,AutoEditLogic
    mov r8,qword ptr[rsp+8]
    mov r9,0
    call SetWindowSubclass
    add rsp,28h

    sub rsp,28h
    mov rcx, r15           ; The button handle  
    mov rdx, 48059            ; A custom message ID
    mov r8, 0          ; Your Green Color
    xor r9, r9
    call SendMessageA          ; This forces your subclass to run once
    add rsp,28h

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
    ; 1. Create a "Home Base" (Frame Pointer)
    push rbp
    mov rbp, rsp
    sub rsp, 40h            ; Allocate space for shadow + locals (aligned)

    ; 2. SAVE THE ORIGINAL PARAMETERS
    mov [rbp-8],  rcx       ; Save hWnd
    mov [rbp-16], rdx       ; Save uMsg
    mov [rbp-24], r8        ; Save wParam (HDC)
    mov [rbp-32], r9        ; Save lParam

    cmp rdx,512 
    je _BUTTONHOVER

    cmp rdx,673
    je _BUTTONHOVER

    cmp rdx,513
    je _BUTTONCLICK

_Default:
    ; RESTORE EVERYTHING EXACTLY
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8,  [rbp-24]
    mov r9,  [rbp-32]
    
    mov rax, [rbp+30h]      ; uIdSubclass
    mov [rsp+20h], rax
    mov rax, [rbp+38h]      ; dwRefData
    mov [rsp+28h], rax
    
    call DefSubclassProc    ;
    leave
    ret

_BUTTONCLICK:
    sub rsp,28h
    mov rcx, [rbp-8]
    lea rdx, LBL
    call SetWindowTextA
    add rsp,28h
    jmp _default

_BUTTONHOVER:
    sub rsp,28h
    mov rcx, [rbp-8]
    lea rdx, Static
    call SetWindowTextA
    add rsp,28h
    jmp _Default
    ret

_HandleColor:
    ; Use our SAVED HDC from the frame
    mov r15, [rbp-24]       ; Get HDC back from [rbp-24]
    mov r15,BTNHANDLE
    
    sub rsp,20h
    mov r8d, 0
    mov r9d, 10
    mov r10d, 210
    call Color32            ; Result in RAX
    
    mov rcx, r15            ; HDC
    mov rdx, rax            ; Result from Color32
    call SetTextColor       ;
    add rsp,20h

    sub rsp,28h
    mov rcx, r15            ; HDC
    mov rdx, 2              ; TRANSPARENT
    call SetBkMode          ;
    add rsp,28h

    sub rsp,28h
    mov rcx, 4              ; BLACK_BRUSH
    call GetStockObject     ; Result in RAX
    add rsp,28h
 
    leave                   ; Cleans stack and restores RBP
    ret                     ; Returns Brush in RAX

_ButtonPaint:
    mov rcx, [rbp-8]
    sub rsp,28h
    call GetDC
    mov r11, rax            ; R11 = HDC
    add rsp,28h

    mov rcx, [rbp-8]
    lea rdx, [rbp-48]       ; Pointer to RECT space in our stack
    sub rsp,28h
    call GetClientRect
    add rsp,28h

    sub rsp,28h
    mov rcx, 4              ; BLACK_BRUSH
    call GetStockObject
    add rsp,28h
    mov r8, rax             ; HBRUSH
    mov rcx, r11            ; HDC
    lea rdx, [rbp-48]       ; RECT
    sub rsp,28h
    call FillRect
    add rsp,28h

    lea rdx, [rbp-128]      ; Create a buffer on your stack
    mov r8, 64              ; Max characters to read
    mov rcx, [rbp-8]        ; The Button hWnd
    sub rsp, 28h
    call GetWindowTextA     ; Fills [rbp-128] with the button's name
    add rsp, 28h

    mov rcx, r11            ; hDC
    lea rdx, [rbp-128]      ; The string we just got
    mov r8, -1              ; -1 = let Windows calculate length
    lea r9, [rbp-48]        ; The RECT
    
    sub rsp, 30h 
    mov dword ptr [rsp+20h], 25h ; DT_CENTER | DT_VCENTER | DT_SINGLELINE
    call DrawTextA          ;
    add rsp, 30h

    mov rcx, [rbp-8]
    mov rdx, r11            ; HDC
    sub rsp,28h
    call ReleaseDC
    add rsp,28h

    mov rcx, [rbp-8]
    xor rdx, rdx            ; NULL = whole window
    sub rsp,28h
    call ValidateRect       ; Tells Windows "Don't paint again"
    add rsp,28h
    mov rax, 1              ; Tell Windows we handled Erase
    leave                   ; Clean up and EXIT
    ret
AutoEditLogic endp

end
