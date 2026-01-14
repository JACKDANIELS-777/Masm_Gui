; =========================================================================================
; MASM_GUI V0.20 - Main Component Engine
; Features: O(1) Unified Rendering, State Management, and RBP-Relative Stack Frame
; Ensure correct external functions and .asm files are copied and ready.
; =========================================================================================

include CustomButtonConstants.inc

; Win32 API Externals
extern RegisterClassA:proc
extern CreateWindowExA:proc
extern GetModuleHandleA:proc
extern DefWindowProcA:proc
extern SetTextColor:proc
extern SetBkMode:proc
extern GetWindowTextA:proc
extern GetStockObject:proc
extern FillRect:proc
extern RoundRect:proc
extern EndPaint:proc
extern BeginPaint:proc
extern DrawTextA:proc
extern GetLastError:proc
extern GetClientRect:proc
extern MessageBoxA:proc
extern FrameRect:proc
extern CreateSolidBrush:proc
extern DeleteObject:proc
extern InflateRect:proc
extern InvalidateRect:proc
extern SetWindowPos:proc

; Unified Rendering Externals
extern Color32:proc
extern ColorBtnBorder:proc
extern ColorBtnRect:proc

.data?
    Paint_struct db 10 dup(0) ; State storage (V0.1 legacy name)

.data
    BtnClassName db "Custom Btn",0
    bwc          db 72 dup (0) ; WNDCLASSEX buffer

.code 

; -----------------------------------------------------------------------------------------
; BtnProc: The Dispatcher
; -----------------------------------------------------------------------------------------
BtnProc proc
    ; 1. Save parameters into Home Slots (Fixed Ceiling Anchor)
    mov [rsp + 8],  rcx  ; hWnd
    mov [rsp + 16], rdx  ; uMsg
    mov [rsp + 24], r8   ; wParam
    mov [rsp + 32], r9   ; lParam
    
    push rbp
    mov rbp, rsp
    sub rsp, 320h        ; Aligned stack allocation

    cmp rdx, 15          ; WM_PAINT
    je _OnPaint
    cmp rdx, 512         ; WM_MOUSEMOVE
    je _OnHover
    cmp rdx, 201h        ; WM_LBUTTONDOWN
    je _OnClick

HandleDefault:
    mov rcx, [rbp + 16]  ; Restore parameters
    mov rdx, [rbp + 24]
    mov r8,  [rbp + 32]
    mov r9,  [rbp + 40]
    sub rsp, 30h         ; Shadow space for outgoing call
    call DefWindowProcA
    add rsp, 30h
    leave
    ret

_OnHover:
    leave
    ret

_OnClick:
    ; 1. Fetch Text
    lea rdx, [rbp-256]   ; Text Buffer
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    ; 2. Fetch Rect
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]    ; RECT buffer
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    ; 3. Invalidate area for repaint
    sub rsp, 28h
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]
    mov r8, 1            ; bErase = TRUE
    call InvalidateRect
    add rsp, 28h

    ; 4. Update State
    mov rcx, ButtonCLicked
    call BtnStateManager
    
    leave
    ret

_OnPaint:
    ; 1. Setup Canvas
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]   ; PAINTSTRUCT buffer
    sub rsp, 28h
    call BeginPaint
    mov r12, rax         ; R12 = HDC (Non-volatile anchor)
    add rsp, 28h

    ; 2. Get Layout Coordinates
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]    ; RECT buffer
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    ; 3. Draw Background (State-Dependent)
    cmp qword ptr[Paint_struct], ButtonCLicked
    je _skip

    mov rcx, 15          ; ID 15: Gold
    call ColorBtnRect
    jmp _noskip

_skip:
    mov rcx, 24          ; ID 24: Emerald
    call ColorBtnRect

_noskip:
    ; 4. Configure Text Rendering
    sub rsp, 28h
    mov rcx, r12
    mov edx, 0000FFFFh   ; Yellow BGR
    call SetTextColor
    
    mov rcx, r12
    mov rdx, 1           ; TRANSPARENT
    call SetBkMode
    add rsp, 28h

    ; 5. Final Text Pass
    lea rdx, [rbp-256]   ; Text Buffer
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h

    mov rcx, r12
    lea rdx, [rbp-256]
    mov r8, -1           ; Null-terminated
    lea r9, [rbp-48]
    sub rsp, 30h
    mov dword ptr [rsp+20h], 25h ; DT_CENTER | DT_VCENTER | DT_SINGLELINE
    call DrawTextA
    add rsp, 30h

    ; 6. Apply Border (ID 17: Pink)
    mov rcx, 17
    call ColorBtnBorder

    ; 7. Global Cleanup
    sub rsp, 28h
    mov rcx, r15         ; R15 holds the last created HBRUSH
    call DeleteObject
    add rsp, 28h

    ; 8. Finalize Canvas
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]
    sub rsp, 28h
    call EndPaint
    add rsp, 28h

    xor rax, rax
    leave
    ret
BtnProc endp

; -----------------------------------------------------------------------------------------
; BtnStateManager: The Brain
; -----------------------------------------------------------------------------------------
BtnStateManager proc
    cmp rcx, ButtonCLicked
    je _BtnClicked
    ret

_BtnClicked:
    mov rcx, ButtonCLicked
    mov rdx, 0
    cmp qword ptr[Paint_struct], ButtonCLicked
    cmove rcx, rdx
    mov qword ptr[Paint_struct], rcx
    ret
BtnStateManager endp

; -----------------------------------------------------------------------------------------
; RegisterBtn: Component Initialization
; -----------------------------------------------------------------------------------------
RegisterBtn proc
    push r15
    sub rsp, 28h
    xor rcx, rcx
    call GetModuleHandleA 
    add rsp, 28h
    mov r15, rax          ; Store hInstance in R15

    ; Load Structure
    mov qword ptr[bwc+24], r15
    lea rcx, BtnClassName
    mov qword ptr[bwc+64], rcx
    lea rcx, BtnProc
    mov qword ptr[bwc+8],  rcx

    sub rsp, 30h
    lea rcx, bwc
    call RegisterClassA
    add rsp, 30h

    pop r15
    ret
RegisterBtn endp

end
