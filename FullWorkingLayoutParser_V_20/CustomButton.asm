
extern RegisterClassA:proc
extern CreateWindowExA:proc
extern GetModuleHandleA:proc
extern DefWindowProcA:proc
extern SetTextColor:proc
extern SetBkMode:proc
extern GetWindowTextA:proc
extern GetStockObject:proc
extern FillRect:proc
extern EndPaint:proc
extern BeginPaint:proc
extern DrawTextA:proc
extern GetLastError:proc
extern GetClientRect:proc
extern MessageBoxA:proc

.data
BtnClassName db "Custom Btn",0
bwc db 72 dup (0)


.code 


BtnProc proc
    ; 1. Save parameters into the "Home Slots" (Space above the Return Address)
    mov [rsp + 8], rcx   ; hWnd
    mov [rsp + 16], rdx  ; uMsg
    mov [rsp + 24], r8   ; wParam
    mov [rsp + 32], r9   ; lParam
    
    push rbp
    mov rbp, rsp
    sub rsp, 320h        ; Must be a multiple of 16

    cmp rdx, 15          ; WM_PAINT
    je _OnPaint

    cmp rdx,201h
    je _OnClick

HandleDefault:
    ; 2. Reload EXACTLY from where we saved them at the start
    ; Since we pushed RBP, the Home Slots are now at [rbp + 16]
    
    mov rcx, [rbp + 16]  ; Original rcx
    mov rdx, [rbp + 24]  ; Original rdx
    mov r8, [rbp + 32]   ; Original r8
    mov r9, [rbp + 40]   ; Original r9
    sub rsp, 30h         ; Shadow space for the outgoing call
    call DefWindowProcA
    add rsp, 30h

    leave
    ret
_OnClick:
    ; 5. Draw Text
    lea rdx, [rbp-256]      ; Text Buffer
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    sub rsp,30h
    mov rcx,0
    lea rdx,[rbp-256]
    lea r8,[rbp-256]
    mov r9,2

    call MessageBoxA
    add rsp,30h
    leave
    ret

_OnPaint:
    ; 1. Setup the Paint Canvas
    mov rcx, [rbp+16]       ; Use the correct saved hWnd
    lea rdx, [rbp-128]      ; PAINTSTRUCT buffer
    sub rsp, 28h
    call BeginPaint
    mov r12, rax            ; R11 = HDC
    add rsp, 28h

    ; 2. Get the Button size
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]       ; RECT buffer
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    ; 3. Draw Background
    sub rsp, 28h
    mov rcx, 4              ; BLACK_BRUSH
    call GetStockObject
    mov r8, rax             
    mov rcx, r12            ; hDC
    lea rdx, [rbp-48]       ; RECT
    call FillRect
    add rsp, 28h

    ; 4. Set Colors
    sub rsp, 28h
    mov rcx, r12
    mov edx, 0000FFFFh      ; Yellow
    call SetTextColor
    mov rcx, r12
    mov rdx, 1              ; TRANSPARENT
    call SetBkMode
    add rsp, 28h

    ; 5. Draw Text
    lea rdx, [rbp-256]      ; Text Buffer
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    mov rcx, r12
    lea rdx, [rbp-256]
    mov r8, -1
    lea r9, [rbp-48]
    sub rsp, 30h
    mov dword ptr [rsp+20h], 25h ; DT_CENTER | DT_VCENTER | DT_SINGLELINE
    call DrawTextA
    add rsp, 30h

    ;call GetLastError
    ;nop

    ; 6. End
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]
    sub rsp, 28h
    call EndPaint
    add rsp, 28h

    xor rax, rax            ; Return 0
    ;add rsp,300h
    leave
    ret
BtnProc endp


RegisterBtn proc
push r15

sub rsp, 28h
xor rcx, rcx          ; Passing NULL
call GetModuleHandleA ; RAX now contains your hInstance
add rsp, 28h
mov r15, rax



mov qword ptr[bwc+24],r15
lea rcx,BtnClassName
mov qword ptr[bwc+64],rcx
lea rcx,BtnProc
mov qword ptr[bwc+8],rcx



;mov qword ptr[bwc+48],rax




sub rsp,30h
lea rcx,bwc
call RegisterClassA
add rsp,30h


pop r15
ret
RegisterBtn endp

end
