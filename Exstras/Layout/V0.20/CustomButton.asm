; =========================================================================================
; X64 CUSTOM GUI LIBRARY - "THE BLACK & YELLOW BUTTON" V0.10
; -----------------------------------------------------------------------------------------
; This library defines a custom window class for a high-contrast button.
; Features: RIP-relative addressing, proper stack alignment, and GDI text centering.
; =========================================================================================

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

; --- Win32 Constants ---
WM_PAINT        equ 15
WM_LBUTTONDOWN  equ 201h
COLOR_YELLOW    equ 0000FFFFh
DT_FLAGS        equ 25h ; DT_CENTER | DT_VCENTER | DT_SINGLELINE
BLACK_BRUSH     equ 4

.data
    BtnClassName db "Custom Btn",0
    bwc          db 72 dup (0) ; WNDCLASS structure (x64 size)

.code 

; -----------------------------------------------------------------------------------------
; BtnProc: The main message handler for the custom button
; -----------------------------------------------------------------------------------------
BtnProc proc
    ; 1. Save parameters into "Home Slots" for x64 Calling Convention
    mov [rsp + 8], rcx   ; hWnd
    mov [rsp + 16], rdx  ; uMsg
    mov [rsp + 24], r8   ; wParam
    mov [rsp + 32], r9   ; lParam
    
    push rbp
    mov rbp, rsp
    sub rsp, 320h        ; Allocate frame (Multiple of 16 for alignment)

    cmp rdx, WM_PAINT
    je _OnPaint

    cmp rdx, WM_LBUTTONDOWN
    je _OnClick

HandleDefault:
    ; Reload registers from home slots for DefWindowProcA
    mov rcx, [rbp + 16]
    mov rdx, [rbp + 24]
    mov r8, [rbp + 32]
    mov r9, [rbp + 40]
    sub rsp, 30h         ; Shadow space
    call DefWindowProcA
    add rsp, 30h

    leave
    ret

_OnClick:
    ; Get current button text into stack buffer
    lea rdx, [rbp-256]   ; Buffer starts at rbp-256
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    ; Trigger Action (Debug Message Box)
    sub rsp, 30h
    mov rcx, 0
    lea rdx, [rbp-256]   ; Message Text
    lea r8, [rbp-256]    ; Caption
    mov r9, 2            ; MB_ABORTRETRYIGNORE
    call MessageBoxA
    add rsp, 30h
    
    leave
    ret

_OnPaint:
    ; 1. Setup Paint Canvas
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]   ; PAINTSTRUCT
    sub rsp, 28h
    call BeginPaint
    mov r12, rax         ; r12 = hDC
    add rsp, 28h

    ; 2. Get Button dimensions
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]    ; RECT
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    ; 3. Draw Background (Black)
    sub rsp, 28h
    mov rcx, BLACK_BRUSH
    call GetStockObject
    mov r8, rax          ; hBrush
    mov rcx, r12         ; hDC
    lea rdx, [rbp-48]    ; RECT
    call FillRect
    add rsp, 28h

    ; 4. Set Text State
    sub rsp, 28h
    mov rcx, r12
    mov edx, COLOR_YELLOW
    call SetTextColor
    mov rcx, r12
    mov rdx, 1           ; TRANSPARENT
    call SetBkMode
    add rsp, 28h

    ; 5. Fetch and Render Text
    lea rdx, [rbp-256]
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
    mov dword ptr [rsp+20h], DT_FLAGS
    call DrawTextA
    add rsp, 30h

    ; 6. Close Canvas
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]
    sub rsp, 28h
    call EndPaint
    add rsp, 28h

    xor rax, rax         ; Return 0 to indicate message handled
    leave
    ret
BtnProc endp

; -----------------------------------------------------------------------------------------
; RegisterBtn: Exposes the custom class to the OS
; -----------------------------------------------------------------------------------------
RegisterBtn proc
    push r15
    sub rsp, 28h
    xor rcx, rcx
    call GetModuleHandleA 
    add rsp, 28h
    mov r15, rax         ; r15 = hInstance

    ; Map Class Structure to memory
    mov qword ptr[bwc+24], r15         ; hInstance
    lea rcx, BtnClassName
    mov qword ptr[bwc+64], rcx         ; lpszClassName
    lea rcx, BtnProc
    mov qword ptr[bwc+8],  rcx         ; lpfnWndProc

    sub rsp, 30h
    lea rcx, bwc
    call RegisterClassA
    add rsp, 30h

    pop r15
    ret
RegisterBtn endp

end
