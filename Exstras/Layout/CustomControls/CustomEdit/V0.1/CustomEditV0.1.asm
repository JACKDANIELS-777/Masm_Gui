;Custom Edit has a few features
include constants.inc
extern GetModuleHandleA:proc
extern RegisterClassExA:proc
extern DefWindowProcA:proc
extern BeginPaint:proc
extern EndPaint:proc
extern Color32:proc
extern ColorBtnBorder:proc
extern EventManager:proc
extern ColorBtnRect:proc
extern GradFill:proc
extern Blend:proc
extern GetClientRect:proc
extern GetLastError:proc
extern SetForeground:proc
extern CreateCaret:proc
extern SetCaretPos:proc
extern ShowCaret:proc
extern GetProcessHeap:proc
extern HeapAlloc:proc
extern SetWindowLongPtrA:proc
extern GetWindowLongPtrA:proc
extern HeapFree:proc
extern InvalidateRect:proc
extern SetFocus:proc
extern SetWindowTextA:proc

.data
align 8
bwc db 80 dup(0)
public EditClassName
EditClassName db "CustomEdit",0

.code

CustomEditproc proc
    mov [rsp + 8],  rcx
    mov [rsp + 16], rdx
    mov [rsp + 24], r8
    mov [rsp + 32], r9
    
    push rbp
    mov rbp, rsp
    sub rsp, 320h

    cmp edx, 15
    je _draw_edit
    cmp edx, 102h
    je _handle_char
    cmp edx, 201h
    je _set_focus
    cmp edx, WM_CREATE
    je _Create
    cmp edx, WM_DESTROY
    je _Destroy
    cmp edx, -10
    je _kill_focus
    
    jmp _HandleDefault
    ret

_Destroy:
    sub rsp, 28h
    mov rcx, [rbp+16]
    mov rdx, 256
    call GetWindowLongPtrA
    mov r13, rax
    
    test r13, r13
    jz _skip_free
    call GetProcessHeap
    mov rcx, rax
    xor rdx, rdx
    mov r8, r13
    call HeapFree
    nop
_skip_free:
    add rsp, 28h
    xor rax, rax
    leave
    ret

_Create:
    sub rsp, 28h
    call GetProcessHeap
    mov rcx, rax
    mov rdx, 8
    mov r8, 1024
    call HeapAlloc
    mov r13, rax

    mov rcx, [rbp+16]
    mov rdx, 256
    mov r8, r13
    call SetWindowLongPtrA
    add rsp, 28h
    leave
    ret

_kill_focus:
    leave
    ret

_draw_edit:
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]
    sub rsp, 28h
    call BeginPaint
    mov r12, rax
    add rsp, 28h

    mov rcx, [rbp+16]
    lea rdx, [rbp-48]
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h
    
    sub rsp, 28h
    mov rcx, [rbp+16]
    mov rdx, 256
    call GetWindowLongPtrA
    
    test rax, rax
    jz _exit_err
    
    mov r13, rax
    mov rcx, [rbp+16]
    mov rdx, r13
    call SetWindowTextA
    add rsp, 28h    

    mov rcx, 10
    call ColorBtnRect

    mov rcx, 12
    mov rdi, 20h
    call SetForeground

_exit_err:
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]
    sub rsp, 28h
    call EndPaint
    add rsp, 28h

    xor rax, rax
    leave
    ret

_handle_char:
    sub rsp, 38h
    mov r14, r8
    
    mov rcx, [rbp+16]
    mov rdx, 256
    call GetWindowLongPtrA
    mov r13, rax
    
    mov rcx, [rbp+16]
    mov rdx, 264
    call GetWindowLongPtrA
    mov r15, rax
    
    cmp r14b, 08h
    je _handle_backspace
    cmp r14b, 0Dh
    je _handle_newline
    cmp r14b, 20h
    jb _char_done
    
    mov [r13 + r15], r14b
    inc r15
    
_save_and_redraw:
    mov rcx, [rbp+16]
    mov rdx, 264
    mov r8, r15
    call SetWindowLongPtrA
    
    mov rcx, [rbp+16]
    xor rdx, rdx
    mov r8, 1
    call InvalidateRect
    
_char_done:
    add rsp, 38h
    xor rax, rax
    leave
    ret

_handle_newline:
    mov byte ptr [r13 + r15], 0Dh
    inc r15
    mov byte ptr [r13 + r15], 0Ah
    inc r15
    jmp _save_and_redraw

_handle_backspace:
    test r15, r15
    jz _char_done
    dec r15
    mov byte ptr [r13 + r15], 0
    jmp _save_and_redraw

_set_focus:
    sub rsp, 28h
    mov rcx, [rbp+16]
    xor rdx, rdx
    mov r8, 2
    mov r9, 18
    call CreateCaret

    mov rcx, 5
    mov rdx, 5
    call SetCaretPos

    mov rcx, [rbp+16]
    call ShowCaret
    add rsp, 28h

    sub rsp, 28h
    mov rcx, [rbp+16]
    call SetFocus
    add rsp, 28h
    
    leave 
    ret

_HandleDefault:
    mov rcx, [rbp + 16]
    mov rdx, [rbp + 24]
    mov r8, [rbp + 32]
    mov r9, [rbp + 40]
    
    sub rsp, 30h
    call DefWindowProcA
    add rsp, 30h
    leave
    ret

CustomEditproc endp

RegisterEdit proc
    push r15
    sub rsp, 30h

    xor rcx, rcx
    call GetModuleHandleA
    mov r15, rax

    mov dword ptr [bwc], 80
    mov dword ptr [bwc + 4], 3
    
    lea rcx, CustomEditproc
    mov qword ptr [bwc + 8], rcx
    
    mov dword ptr [bwc + 16], 0
    mov dword ptr [bwc + 20], 512
    
    mov qword ptr [bwc + 24], r15
    
    mov qword ptr [bwc + 32], 0
    mov qword ptr [bwc + 40], 0
    mov qword ptr [bwc + 48], 0
    mov qword ptr [bwc + 56], 0
    
    lea rcx, EditClassName
    mov qword ptr [bwc + 64], rcx
    
    mov qword ptr [bwc + 72], 0

    lea rcx, bwc
    call RegisterClassExA

    add rsp, 30h
    call GetLastError
    pop r15
    ret
RegisterEdit endp

end
