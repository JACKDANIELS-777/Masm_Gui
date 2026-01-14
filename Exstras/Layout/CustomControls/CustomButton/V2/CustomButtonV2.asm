; =========================================================================================
; MASM_GUI V0.20 - Main Component Engine
; Features: O(1) Unified Rendering, State Management, and RBP-Relative Stack Frame
; Added in Timer and animation. Some code is commented out it is usable but irrelevant to the animation relevent if you press or hover the button.
; =========================================================================================

include CustomButtonConstants.inc
WM_TIMER equ 275 ; 0113h

; --- Win32 API Externals ---
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
extern TrackMouseEvent:proc
extern SetTimer:proc
extern SetPixelV:proc
extern MoveToEx:proc
extern LineTo:proc
extern CreatePen:proc
extern SelectObject:proc

; --- Unified Rendering Externals ---
extern Color32:proc
extern ColorBtnBorder:proc
extern ColorBtnRect:proc

.data?
    Paint_struct db 10 dup(0) ; State storage (V0.1 legacy name)

.data
    BtnClassName db "Custom Btn",0
    bwc          db 72 dup (0) ; WNDCLASSEX buffer
    point        dq 0,0,0,0,0,0,0

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
    cmp rdx, WM_TIMER
    je _OnTimer

HandleDefault:
    cmp qword ptr[Paint_struct+16], 1
    je _NoTimer

    sub rsp, 28h
    mov rdx, 1
    mov r8, 50
    mov r9, 0
    call SetTimer
    add rsp, 28h

_NoTimer:
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
    ; 1. Check if we are already tracking
    cmp byte ptr [Paint_struct + 8], 1
    je _SkipTrack

    ; 2. Start Tracking
    sub rsp, 30h
    lea rcx, [rbp-64]          
    mov dword ptr [rcx], 24    ; cbSize (sizeof TME)
    mov dword ptr [rcx+4], 2   ; dwFlags = TME_LEAVE (2)
    mov rax, [rbp+16]          ; hWnd
    mov [rcx+8], rax           ; hwndTrack
    call TrackMouseEvent
    add rsp, 30h
    
    ; 3. Set Tracking Flag and Update State
    mov byte ptr [Paint_struct + 8], 1
    mov rcx, ColorButtonHover
    call BtnStateManager    

    ; 4. Trigger Repaint
    call _RequestRedraw

_SkipTrack:
    leave
    ret

_OnMouseLeave: ; WM_MOUSELEAVE (675)
    mov byte ptr [Paint_struct + 8], 0
    mov rcx, ColorButtonHover
    call BtnStateManager
    call _RequestRedraw
    leave
    ret

_RequestRedraw:
    sub rsp, 28h
    mov rcx, [rbp+16]
    xor rdx, rdx           
    mov r8, 1              ; Erase background
    call InvalidateRect
    add rsp, 28h
    leave
    ret

_OnTimer: ; WM_TIMER (275)
    mov r13, [point+16]    ; 0=Right, 1=Down, 2=Left, 3=Up

    cmp qword ptr[point+40], 0
    jne _NoSetVals
    sub rsp, 28h           
    mov rcx, [rbp+16]      
    lea rdx, [rbp-48]      
    call GetClientRect
    add rsp, 28h
    mov r12, rax

    mov edx, dword ptr[rbp-40]
    mov ecx, dword ptr[rbp-36]

    mov qword ptr[point+24], rdx
    mov qword ptr[point+32], rcx
    mov qword ptr[point+40], 1
    
_NoSetVals:
    cmp r13, 0
    je _MoveRight
    cmp r13, 1
    je _MoveDown
    cmp r13, 2
    je _MoveLeft
    jmp _MoveUp

_MoveRight:
    mov rax, qword ptr[point]
    mov qword ptr[point+48], rax
    add qword ptr [point], 2
    mov rax, qword ptr[point+24]
    sub rax, 1
    cmp qword ptr [point], rax 
    jl _Done
    sub rax, 1
    mov qword ptr [point], rax ; Snap to corner
    mov qword ptr[point+48], rax
    mov qword ptr[point+16], 1
    jmp _Done

_MoveDown:
    mov rax, qword ptr[point+8]
    mov qword ptr[point+56], rax
    add qword ptr [point+8], 2
    mov rax, qword ptr[point+32]
    sub rax, 1
    cmp qword ptr [point+8], rax 
    jl _Done
    sub rax, 1
    mov qword ptr [point+8], rax 
    mov qword ptr [point+56], rax 
    mov qword ptr[point+16], 2
    jmp _Done

_MoveLeft:
    mov rax, qword ptr[point]
    mov qword ptr[point+48], rax
    sub qword ptr [point], 2
    cmp qword ptr [point], 2
    jg _Done
    mov qword ptr [point], 0   
    mov qword ptr [point+48], 0
    mov qword ptr[point+16], 3 
    jmp _Done

_MoveUp:
    mov rax, qword ptr[point+8]
    mov qword ptr[point+56], rax
    sub qword ptr [point+8], 2
    cmp qword ptr [point+8], 2
    jg _Done
    mov qword ptr [point+8], 0 
    mov qword ptr [point+56], 0 
    mov qword ptr[point+16], 0 

_Done:
    sub rsp, 28h
    mov rcx, [rbp+16]          
    xor rdx, rdx
    mov r8, 0                  ; No flicker
    call InvalidateRect
    add rsp, 28h
    leave
    ret

_OnClick:
    lea rdx, [rbp-256]   ; Text Buffer
    mov r8, 128
    mov rcx, [rbp+16]
    sub rsp, 28h    
    call GetWindowTextA
    add rsp, 28h

    mov rcx, [rbp+16]
    lea rdx, [rbp-48]    
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    sub rsp, 28h
    mov rcx, [rbp+16]
    lea rdx, [rbp-48]
    mov r8, 1            
    call InvalidateRect
    add rsp, 28h

    mov rcx, ButtonCLicked
    call BtnStateManager
    leave
    ret

_OnPaint:
    mov rcx, [rbp+16]
    lea rdx, [rbp-128]   ; PAINTSTRUCT
    sub rsp, 28h
    call BeginPaint
    mov r12, rax         ; R12 = HDC
    add rsp, 28h

    mov rcx, [rbp+16]
    lea rdx, [rbp-48]    ; RECT
    sub rsp, 28h
    call GetClientRect
    add rsp, 28h

    mov r13, 3
_GlowLoop:
    sub rsp, 30h
    cmp r13, 3
    je _SetDark
    cmp r13, 2
    je _SetMed
    mov rcx, 0           ; WHITE_BRUSH
    jmp _DoDraw
_SetDark:
    mov rcx, 3           ; DKGRAY_BRUSH
    jmp _DoDraw
_SetMed:
    mov rcx, 2           ; GRAY_BRUSH

_DoDraw:
    call Animation1
    jmp _noskip
    ; [SetPixelV logic preserved]
    sub rsp, 28h
    mov rcx, r12
    mov rdx, qword ptr[point+48]
    mov r8, qword ptr[point+56]
    mov r9, 1E1E1Eh
    call SetPixelV
    add rsp, 28h
    
    sub rsp, 28h
    mov rcx, r12
    mov rdx, qword ptr[point]
    mov r8, qword ptr[point+8]
    mov r9, 00FFFF00h
    call SetPixelV
    add rsp, 28h

    jmp _noskip
    mov r8d, 25
    mov r9d, 25
    mov r10d, 25
    call Color32
    mov rcx, rax
    call CreateSolidBrush
    mov r8, rax          
    mov rcx, r12         
    lea rdx, [rbp-48]    
    call FillRect
    add rsp, 30h

    dec r13
    jnz _GlowLoop

    jmp _noskip

    ; 3. Draw Background (State-Dependent)
    cmp qword ptr[Paint_struct], ButtonCLicked
    je _ButtonPressed
    cmp qword ptr[Paint_struct], ColorButtonHover
    je _hover
    mov rcx, 15          ; Gold
    call ColorBtnRect
    jmp _skip
_ButtonPressed:
    mov rcx, 15
    call ColorBtnRect
    jmp _noskip
_hover:
    mov rcx, 7
    call ColorBtnRect
    jmp _noskip
_skip:
    mov rcx, 24          ; Emerald
    call ColorBtnRect

_noskip:
    sub rsp, 28h
    mov rcx, r12
    mov edx, 0000FFFFh   ; Yellow
    call SetTextColor
    mov rcx, r12
    mov rdx, 1           ; TRANSPARENT
    call SetBkMode
    add rsp, 28h

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
    mov dword ptr [rsp+20h], 25h 
    call DrawTextA
    add rsp, 30h

    sub rsp, 28h
    mov rcx, r15         ; Delete Last Brush
    call DeleteObject
    add rsp, 28h

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
; Animation1: The Sweep Engine
; -----------------------------------------------------------------------------------------
Animation1 proc
    sub rsp, 28h
    mov rcx, r12
    mov rdx, 2
    mov r8, 0000FF00h
    call CreatePen
    mov [rbp-56], rax

    mov rcx, r12
    mov rdx, [rbp-56]
    call SelectObject
    mov [rbp-64], rax

    mov rcx, r12         ; hdc
    mov rdx, 0           ; Anchor X
    mov r8, 0            ; Anchor Y
    xor r9, r9
    call MoveToEx        

    mov rcx, r12         ; hdc
    mov rdx, qword ptr[point]
    mov r8, qword ptr[point+8]
    call LineTo          

    mov rcx, r12
    mov rdx, [rbp-64]
    call SelectObject

    mov rcx, [rbp-56]
    call DeleteObject
    add rsp, 28h
    ret
Animation1 endp

; -----------------------------------------------------------------------------------------
; BtnStateManager: The Brain
; -----------------------------------------------------------------------------------------
BtnStateManager proc
    cmp rcx, ButtonCLicked
    je _BtnClicked
    cmp rcx, ColorButtonHover
    je _BtnHover
    ret

_BtnClicked:
    mov rcx, ButtonCLicked
    mov rdx, 0
    cmp qword ptr[Paint_struct], ButtonCLicked
    cmove rcx, rdx
    mov qword ptr[Paint_struct], rcx
    ret

_BtnHover:
    mov rcx, ColorButtonHover
    mov rdx, 0
    cmp qword ptr[Paint_struct], ColorButtonHover
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

    mov r15, rax          

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
