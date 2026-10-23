extern GetCommandLineA:proc
extern CreateFileA:proc
extern GetFileSize:proc
extern ReadFile:proc
extern CloseHandle:proc
extern GetProcessHeap:proc
extern HeapAlloc:proc
extern HeapFree:proc

public LoadLayoutFromArgs

LL_GENERIC_READ     equ 80000000h
LL_FILE_SHARE_READ  equ 1
LL_OPEN_EXISTING    equ 3
LL_HEAP_ZERO_MEMORY equ 8
LL_MAX_PATH         equ 260

.data?
LL_Path      db LL_MAX_PATH dup(?)
LL_BytesRead dd ?

.code
LoadLayoutFromArgs proc
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    push rbx
    push rsi
    push rdi
    push r12
    push rbp
    mov rbp, rsp
    and rsp, -16
    sub rsp, 40h

    call GetCommandLineA
    mov rsi, rax
    cmp byte ptr [rsi], '"'
    jne _skipBare
    inc rsi
_skipQuoted:
    mov al, [rsi]
    test al, al
    jz _none
    inc rsi
    cmp al, '"'
    jne _skipQuoted
    jmp _skipSpaces
_skipBare:
    mov al, [rsi]
    test al, al
    jz _none
    cmp al, ' '
    je _skipSpaces
    inc rsi
    jmp _skipBare

_skipSpaces:
    mov al, [rsi]
    cmp al, ' '
    je _nextSpace
    cmp al, 9
    jne _copyPath
_nextSpace:
    inc rsi
    jmp _skipSpaces

_copyPath:
    test al, al
    jz _none
    lea rdi, LL_Path
    xor ecx, ecx
    cmp al, '"'
    jne _copyChar
    inc rsi
    mov ecx, 1
_copyChar:
    mov al, [rsi]
    test al, al
    jz _copyDone
    cmp al, '"'
    je _copyDone
    test ecx, ecx
    jnz _storeChar
    cmp al, ' '
    je _copyDone
_storeChar:
    lea rdx, LL_Path + LL_MAX_PATH - 1
    cmp rdi, rdx
    jae _none
    mov [rdi], al
    inc rdi
    inc rsi
    jmp _copyChar
_copyDone:
    mov byte ptr [rdi], 0
    lea rax, LL_Path
    cmp rdi, rax
    je _none

    lea rcx, LL_Path
    mov edx, LL_GENERIC_READ
    mov r8d, LL_FILE_SHARE_READ
    xor r9d, r9d
    mov qword ptr [rsp+20h], LL_OPEN_EXISTING
    mov qword ptr [rsp+28h], 0
    mov qword ptr [rsp+30h], 0
    call CreateFileA
    cmp rax, -1
    je _none
    mov rbx, rax

    mov rcx, rbx
    xor edx, edx
    call GetFileSize
    cmp eax, -1
    je _closeFail
    test eax, eax
    jz _closeFail
    mov r12d, eax

    call GetProcessHeap
    mov rcx, rax
    mov edx, LL_HEAP_ZERO_MEMORY
    lea r8, [r12+1]
    call HeapAlloc
    test rax, rax
    jz _closeFail
    mov rdi, rax

    mov rcx, rbx
    mov rdx, rdi
    mov r8d, r12d
    lea r9, LL_BytesRead
    mov qword ptr [rsp+20h], 0
    call ReadFile
    mov esi, eax
    mov rcx, rbx
    call CloseHandle
    test esi, esi
    jz _freeFail

    mov rsi, rdi
    mov rdx, rdi
    mov ecx, dword ptr [LL_BytesRead]
    lea r8, [rdi+rcx]
_strip:
    cmp rsi, r8
    jae _stripDone
    mov al, [rsi]
    inc rsi
    cmp al, 13
    je _strip
    cmp al, 10
    je _strip
    cmp al, 9
    je _strip
    mov [rdx], al
    inc rdx
    jmp _strip
_stripDone:
    mov byte ptr [rdx], 0
    mov rax, rdi
    jmp _ret

_freeFail:
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, rdi
    call HeapFree
    jmp _none
_closeFail:
    mov rcx, rbx
    call CloseHandle
_none:
    xor eax, eax
_ret:
    mov rsp, rbp
    pop rbp
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop r11
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret
LoadLayoutFromArgs endp

end
