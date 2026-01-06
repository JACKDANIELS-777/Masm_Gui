; =============================================================
; MASM x64 Layout Engine v0.1
; Description: Parses a custom string format to dynamically 
;              create and position Windows UI controls.
; Syntax: "Type,ID,X,Y,W,H,Text,\c"
; =============================================================

include constants.inc

extern AppendMenuA:proc
extern CreateMenu :proc
extern CreateLabelEdit:proc
extern MessageBoxA:proc
extern hwndMain:qword

.data
LayoutStr db "E,100,100,10,10,25,Input,\cE,100,100,100,100,250,No,\c",0

Static    db "STATIC",0
Edit      db "EDIT",0

.code

LayoutParser proc
    lea rdx, LayoutStr
    mov r15, rcx
    mov r14, rdx

    mov r13, 0
    mov rbx, 0
    mov r12, 0 
    sub rsp, 100h

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
    jmp _continue

_Edit:
    mov qword ptr[rsp+0], 1
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

    mov qword ptr[rsp+80], r14  
    mov qword ptr[rsp+88], r15  
    mov qword ptr[rsp+72], r13
    mov qword ptr[rsp+64], r12

    mov rbx, qword ptr[rsp+8] 
    lea rdx, Static
    mov qword ptr[r15+r12], 0
    mov r8, r15
    mov r9, 50000001h
    mov r10, qword ptr[rsp+16]
    mov r11, qword ptr[rsp+24]
    mov r12, qword ptr[rsp+32]
    mov r13, qword ptr[rsp+40]
    mov r14, hwndMain
    mov r15, 0
    call CreateLabelEdit

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

end
