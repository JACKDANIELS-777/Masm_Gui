; =========================================================================================
; Added in checks and flow state of erase future controls a - z to be added that modify either the behavior of the control, shape, aesthetic etc
; =========================================================================================
include constants.inc
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
extern wsprintfA:proc
extern SetRect:proc
extern UpdateWindow:proc
extern ShowWindow:proc
extern GetDC:proc
extern ReleaseDC:proc
extern GetLastError:proc

; --- Unified Rendering Externals ---
extern Color32:proc
extern ColorBtnBorder:proc
extern ColorBtnRect:proc
extern GradFill:proc
extern Blend:proc
extern AttrDataBuffer:byte

.data?
    Paint_struct db 10 dup(?) ; State storage (V0.1 legacy name)
    handle_str db 32 dup(?)             ; Buffer for the converted string

.data
    BtnClassName db "Custom Btn",0
    bwc          db 80 dup (0) ; WNDCLASSEX buffer
    point        dq 0,0,0,0,0,0,0,0
    Focused db "Focused",0
    UnFocused db "UnFocused",0
    handle_fmt db "Focus Handle: %p", 0  ; %p formats for 64-bit pointers/handles
    s db "0",0


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

    cmp rdx,WM_CREATE
    je _Create

    cmp rdx,14h
    je _EraseBg

    cmp rdx, 15          ; WM_PAINT
    je _OnPaint
    cmp rdx, 512         ; WM_MOUSEMOVE
    je _OnHover
    cmp rdx, 201h        ; WM_LBUTTONDOWN
    je _OnClick
    cmp rdx, WM_TIMER
    je _OnTimer

    cmp rdx,WM_SetFocus
    je _Focused

    cmp rdx,WM_KILLFOCUS
    je _UnFocused


    cmp rdx,WM_GETDLGCODE
    je _GETDLGCODE
  

HandleDefault:
    cmp qword ptr[Paint_struct+16], 0
    jne _NoTimer

    sub rsp, 28h
    mov rdx, 1
    mov r8, 100
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
_EraseBg:

    xor r12, r12            ; Offset counter (0, 8, 16...)
    mov r13, [rbp + 16]     ; Get hWnd from Home Slot (rcx was saved here)

_BurstLoop:
    mov rcx, r13            ; hWnd
    mov rdx, r12            ; Current Offset
    sub rsp, 28h            ; Shadow space for API
    call GetWindowLongPtrA
    add rsp, 28h
    
    ; Store into our local stack mirror
    ; [rbp - 100h] is the start of our 256-byte buffer
    mov [rbp - 100h + r12], rax 
    
    add r12, 8              ; Next QWORD
    cmp r12, 256            ; Done with all 32 QWORDs?
    jne _BurstLoop

    ; Now load the flags into R14D once and forget the memory!
    mov r15d, dword ptr[rbp - 100h]   ; Load QWORD 0 (Flags in lower 32 bits)

    mov rsi, [rbp+16]            ; Save HWND in a stable register

    ; Now pull the 'a' flag
    ;mov rcx, rsi            ; HWND
    ;xor rdx, rdx            ; Offset 0
    ;sub rsp, 28h
    ;call GetWindowLongPtrA
    ;add rsp, 28h
    
    ;mov r15,rax

; --- Assume R15D contains your 32-bit Attribute Field (a-z) ---

_HandleA:
    bt r15d, 0
    jnc _HandleB
    nop
    ; [ Implementation for 'a' ]
    ; ...

_HandleB:
    bt r15d, 1
    jnc _HandleC
    nop
    ; [ Implementation for 'b' ]
    ; ...

_HandleC:
    bt r15d, 2
    jnc _HandleD
    nop

_HandleD:
    bt r15d, 3
    jnc _HandleE
    ; ...

_HandleE:
    bt r15d, 4
    jnc _HandleF
    ; ...

_HandleF:
    bt r15d, 5
    jnc _HandleG
    ; ...

_HandleG:
    bt r15d, 6
    jnc _HandleH
    ; ...

_HandleH:
    bt r15d, 7
    jnc _HandleI
    ; ...

_HandleI:
    bt r15d, 8
    jnc _HandleJ
    ; ...

_HandleJ:
    bt r15d, 9
    jnc _HandleK
    ; ...

_HandleK:
    bt r15d, 10
    jnc _HandleL
    ; ...

_HandleL:
    bt r15d, 11
    jnc _HandleM
    ; ...

_HandleM:
    bt r15d, 12
    jnc _HandleN
    ; ...

_HandleN:
    bt r15d, 13
    jnc _HandleO
    ; ...

_HandleO:
    bt r15d, 14
    jnc _HandleP
    ; ...

_HandleP:
    bt r15d, 15
    jnc _HandleQ
    ; ...

_HandleQ:
    bt r15d, 16
    jnc _HandleR
    ; ...

_HandleR:
    bt r15d, 17
    jnc _HandleS
    ; ...

_HandleS:
    bt r15d, 18
    jnc _HandleT
    ; ...

_HandleT:
    bt r15d, 19
   jnc _HandleU
    ; ...

_HandleU:
    bt r15d, 20
    jnc _HandleV
    ; ...

_HandleV:
    bt r15d, 21
   jnc _HandleW
    ; ...

_HandleW:
    bt r15d, 22
   jnc _HandleX
    ; ...

_HandleX:
    bt r15d, 23
    jnc _HandleY
    ; ...

_HandleY:
    bt r15d, 24
     jnc _HandleZ
    ; ...

_HandleZ:
    bt r15d, 25
    jnc _GauntletEnd
    ; [ Implementation for 'z' ]
    ; ...

_GauntletEnd:
    ; All attributes processed.
    ; Continue to rendering/cleanup...


    mov rsi, [rbp+32]            ; Save the DC in RSI
    
    ; 1. Create your brush from the '200' value in AttrDataBuffer
    mov rcx, 00232323h      ; Gray color (200 decimal)
    sub rsp, 20h            ; Shadow space
    call CreateSolidBrush
    add rsp, 20h
    mov rdi, rax            ; Save Brush in RDI




    ; 2. Get the area (You still need the HWND for this)
    ; Assuming your proc puts HWND in R9 or a stack slot
    mov rcx, [rbp+16]       ; HWND
    lea rdx, [rbp-48]       ; RECT
    call GetClientRect

    ; 3. Fill the background with your custom color
    mov rcx, rsi            ; DC
    lea rdx, [rbp-48]       ; RECT
    mov r8, rdi             ; Brush
    call FillRect

    ; 4. Cleanup
    mov rcx, rdi
    call DeleteObject

    mov rax,1
    leave
    ret
_Create:
    xor r12,r12          ; Offset counter (0, 8, 16...)

_SnatchedLoop:
    mov rcx, [rbp+16]       ; HWND
    mov rdx, r12            ; The Offset
    lea rax,    [AttrDataBuffer]
    mov r8, qword ptr[ rax + r12]     ; Load 8 bytes from your buffer
    
    sub rsp, 28h
    call SetWindowLongPtrA  ; "Bamb" it into the backpack
    add rsp, 28h

    
    add r12, 8              ; Increment by 8 bytes
    cmp r12, 256           ; Done with 16 quads?
    jne _SnatchedLoop 

    



    mov rax,0
    leave 
    ret
_GETDLGCODE:
    mov rax, 40h ; DLGC_BUTTON
    
    leave
    ret


_Focused:
    
    mov r9,r8            ; r9 = The handle to convert
    
    ; 2. Call wsprintfA (Note: this is a C-vararg call, requires sub rsp, 40h+)
    sub rsp, 48h             ; Standard shadow space + alignment
    lea rcx, handle_str      ; Argument 1: Destination buffer
    lea rdx, handle_fmt      ; Argument 2: Format string
    ; r8 (Argument 3) already has the handle if you didn't move it, 
    ; but we moved it to r9 to be safe with rdx/rcx
    mov r8, r9               
    call wsprintfA
    add rsp, 48h
    
    

    sub rsp,30h
    mov rcx,0
    lea rdx,handle_str
    lea r8,Focused
    mov r9,2
    call MessageBoxA
    add rsp,30h

    mov rax,0
    
    leave
    ret

_UnFocused:
    mov r9,r8          ; r9 = The handle to convert
    
    ; 2. Call wsprintfA (Note: this is a C-vararg call, requires sub rsp, 40h+)
    sub rsp, 48h             ; Standard shadow space + alignment
    lea rcx, handle_str      ; Argument 1: Destination buffer
    lea rdx, handle_fmt      ; Argument 2: Format string
    ; r8 (Argument 3) already has the handle if you didn't move it, 
    ; but we moved it to r9 to be safe with rdx/rcx
    mov r8, r9               
    call wsprintfA
    add rsp, 48h


    lea rdx, handle_str
    mov r8, 32
    mov rcx, [rbp+16]
    sub rsp, 28h    
    call GetWindowTextA
    add rsp, 28h 
    sub rsp,30h
    mov rcx,0
    lea rdx,handle_str
    lea r8,UnFocused
    mov r9,2
    call MessageBoxA
    add rsp,30h

    mov rax,0

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
    mov r8, 1               ; Erase background
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

    ;animation 6
    cmp qword ptr[Paint_struct+16],2
    je _skip_setup2

    mov qword ptr[Paint_struct+16],2
    
 
    mov eax, dword ptr[rbp-40]
    mov dword ptr[point+32],eax ;safe val
    mov dword ptr[point+28],eax ; right width to be edited


    mov eax, dword ptr[rbp-48]
    mov dword ptr[point+24],eax ;safe val
    mov dword ptr[point+20],eax ; left width to be edited
    ;mov dword ptr[point],-10

    _skip_setup2:

    mov eax, dword ptr[point+32]
    mov ebx, dword ptr[point+28]
    mov ecx,dword ptr[point+24]

    mov edi, dword ptr[point+20]

    cmp ebx,edi
    jg _ok

    


    mov dword ptr[point+28],eax
    mov dword ptr[point+20],ecx

    jmp _done

    _ok:
    
    sub dword ptr[point+28],2



    add dword ptr[point+20],2


    jmp _done
    ;animation 5

    cmp qword ptr[Paint_struct+16],2
    je _skip_setup1

    mov qword ptr[Paint_struct+16],2

    mov eax, dword ptr[rbp-40]
    mov dword ptr[point+32],eax ;safe val
    mov dword ptr[point+28],eax ; right width to be edited


    mov eax, dword ptr[rbp-48]
    mov dword ptr[point+24],eax ;safe val
    mov dword ptr[point+20],eax ; left width to be edited
    mov dword ptr[point],-10

    _skip_setup1:

    mov eax, dword ptr[point+32]
    mov ebx, dword ptr[point+28]
    mov ecx,dword ptr[point+24]
    cmp dword ptr[point+28],ecx
    
    cmovl ebx,eax
    

    mov dword ptr[point+28],ebx
    sub dword ptr[point+28],2

    mov eax, dword ptr[point+24]
    mov ebx, dword ptr[point+20]
    mov ecx, dword ptr[point+32]

    cmp dword ptr[point+20],ecx
    cmovg ebx,eax


    mov dword ptr[point+20],ebx
    

    add dword ptr[point+20],2
    




    jmp _done

    ;animation4

    cmp qword ptr[Paint_struct+16],2
    je _skip_setup

    mov qword ptr[Paint_struct+16],2

    mov eax, dword ptr[rbp-40]
    mov dword ptr[point+32],eax ;safe val
    mov dword ptr[point+28],eax ; width to be edited


    mov eax, dword ptr[rbp-36]
    mov dword ptr[point+24],eax ;safe val
    mov dword ptr[point+20],eax ; height to be edited
    mov dword ptr[point],-10

    _skip_setup:

    mov eax, dword ptr[point+32]
    mov ebx, dword ptr[point+28]
    cmp dword ptr[point+28],0
    cmovl ebx,eax

    mov dword ptr[point+28],ebx
    sub dword ptr[point+28],2

    


    jmp _done

    ;for anim 2 and 3
    add dword ptr[point+0],3
    add dword ptr[point+4],2
    add dword ptr[point+8],1
    jmp _done

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
    mov r8, 1        ; No flicker
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



    nop

    jmp _end
    ;call GradFill
    ;call Blend
    ;jmp _noSkip
_DoDraw:

    call Animation6
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

    ;dec r13
    ;jnz _GlowLoop

    jmp _noskip
    _here:
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
    _end:
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
; Animations: The Sweep Engine
; -----------------------------------------------------------------------------------------
Animation0 proc

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


    ret
Animation0 endp
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
    mov rdx, 0            ; Anchor X
    mov r8, 0             ; Anchor Y
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


Animation2 proc

sub rsp,28h
mov r8d, dword ptr[point]
mov r9d, dword ptr[point+4]
mov r10d, dword ptr[point+8]
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r15, rax


    
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
    
    
    mov rcx, r15
    call DeleteObject
  
    add rsp,28h

ret
Animation2 endp



Animation3 proc

sub rsp,28h
mov r8d, dword ptr[point]
mov r9d, dword ptr[point+4]
mov r10d, dword ptr[point+8]
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r15, rax



    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FrameRect
    
    
    mov rcx, r15
    call DeleteObject
  
    add rsp,28h

ret
Animation3 endp

Animation4 proc

sub rsp,28h
mov r8d, dword ptr[point]
mov r9d, dword ptr[point+4]
mov r10d, dword ptr[point+8]
mov r8d,255
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r15, rax



mov r9d, 30
mov r10d, 30
mov r8d,30
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r14, rax
  

    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r14
    call FillRect
 
 
    
    mov eax, dword ptr[point+28]
    mov dword ptr[rbp-40],eax
  
  
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
    
    
    mov rcx, r15
    call DeleteObject
  
    mov rcx, r14
    call DeleteObject
    add rsp,28h

ret
Animation4 endp



Animation5 proc

sub rsp,28h
mov r8d, dword ptr[point]
mov r9d, dword ptr[point+4]
mov r10d, dword ptr[point+8]
mov r8d,255
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r15, rax



mov r9d, 30
mov r10d, 30
mov r8d,30
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r14, rax
  

    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r14
    call FillRect
 
 
    
    mov eax, dword ptr[point+28]

    mov dword ptr[rbp-40],eax

    mov eax,dword ptr[point+20]
    mov dword ptr[rbp-48],eax
  
  
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
    
    
    mov rcx, r15
    call DeleteObject
  
    mov rcx, r14
    call DeleteObject
    add rsp,28h

ret
Animation5 endp


Animation6 proc

sub rsp,28h
mov r8d, dword ptr[point]
mov r9d, dword ptr[point+4]
mov r10d, dword ptr[point+8]
mov r8d,255
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r15, rax



mov r9d, 30
mov r10d, 30
mov r8d,30
call Color32

  mov rcx,rax
 call CreateSolidBrush
 mov r14, rax
  

    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r14
    call FillRect
 
 
    
    mov eax, dword ptr[point+28]

    mov dword ptr[rbp-40],eax

    mov eax,dword ptr[point+20]
    mov dword ptr[rbp-48],eax
  
  
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
    
    
    mov rcx, r15
    call DeleteObject
  
    mov rcx, r14
    call DeleteObject
    add rsp,28h

ret
Animation6 endp

ButtonStyles proc

mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r14
    call FillRect

    lea rcx,[rbp-48]

    mov rdx,-5
    mov r8,-5
    call InflateRect
  
  
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
ret
ButtonStyles endp
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
    sub rsp, 30h            ; Extra space for safety and alignment

    ; 1. Get Instance
    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax          

    ; 2. Initialize WNDCLASSEXA (80 bytes total)
    ; Zero out the structure first to avoid garbage values!
    ; (Assuming bwc is your 80-byte buffer)
    
    mov dword ptr [bwc], 80          ; cbSize = 80 (VERY IMPORTANT)
    mov dword ptr [bwc + 4], 3       ; style (CS_HREDRAW | CS_VREDRAW)
    
    lea rcx, BtnProc
    mov qword ptr [bwc + 8], rcx     ; lpfnWndProc (Offset 8)
    
    mov dword ptr [bwc + 16], 0      ; cbClsExtra
    mov dword ptr [bwc + 20], 256    ; cbWndExtra (Offset 20) - Your 128 bytes!
    
    mov qword ptr [bwc + 24], r15    ; hInstance (Offset 24)
    
    ; Offsets 32, 40, 48 are for Icons and Cursors (Set to 0 or LoadIcon)
    mov qword ptr [bwc + 32], 0      ; hIcon
    mov qword ptr [bwc + 40], 0      ; hCursor
    mov qword ptr [bwc + 48], 0      ; hbrBackground
    mov qword ptr [bwc + 56], 0      ; lpszMenuName
    
    lea rcx, BtnClassName
    mov qword ptr [bwc + 64], rcx    ; lpszClassName (Offset 64)
    
    ; hIconSm at Offset 72
    mov qword ptr [bwc + 72], 0

    ; 3. The Registration
    lea rcx, bwc
    call RegisterClassExA            ; <--- Use the "Ex" version!

    add rsp, 30h
    pop r15
    ret
RegisterBtn endp

end
