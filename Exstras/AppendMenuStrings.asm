; =============================================================
; DATA SECTION TEMPLATE
; =============================================================
; .data
; Mem         db 100 dup (0)
; Mem_String  db "Hey\Item1\Item2\cThis is item 3\c", 0

; =============================================================
; EXAMPLE USAGE IN CREATE WNDPROC
; =============================================================
; lea   rcx, Mem
; lea   rdx, Mem_String
; call  CreateMenusString

; sub   rsp, 20h
; mov   rcx, hwndMain
; mov   rdx, rax
; call  SetMenu
; add   rsp, 20h

; =============================================================
; PROCEDURE: CreateMenusString
; Arguments:
;   RCX: Pointer to memory buffer
;   RDX: Pointer to the source string
; =============================================================
CreateMenusString PROC
    mov     r12, rcx
    mov     r14, rdx

    ; -- CREATE Main Menu --
    sub     rsp, 20h
    call    CreateMenu
    add     rsp, 20h
    mov     r15, rax

    mov     r13, 0

    sub     rsp, 100h

_loop:
    mov     al, byte ptr [r14]
    
    cmp     al, 0
    je      _exit
    
    cmp     al, "\"
    je      _add_menu

    mov     byte ptr [r12], al
    add     r12, 1
    add     r13, 1

    jmp     _continue

_add_menu:
    add     r14, 1
    mov     al, byte ptr [r14]
    cmp     al, "c"
    jne     _continue 

    mov     byte ptr [r12], 0
    add     r12, 1
    add     r13, 1
    sub     r12, r13
    
    sub     rsp, 20h
    mov     rcx, r15
    mov     rdx, MF_STRING
    mov     r8, 0
    lea     r9, qword ptr [r12]
    call    AppendMenuA
    add     rsp, 20h

    add     r14, 1
    add     r12, r13
    mov     r13, 0
    
    jmp     _loop

_continue:
    add     r14, 1
    jmp     _loop

_exit:
    add     rsp, 100h
    mov     rax, r15
    ret

CreateMenusString ENDP
