; =========================================================================================
; Added in Attributes to be used with the Layout Parser
; =========================================================================================

include constants.inc

extern AttrDataBuffer:byte
extern SetForeground:proc

.data
    CustomDLGCLASSNAME  db "Custom DLG", 0
    
    align 8
    bwc                 db 80 dup (0)

.code

; -----------------------------------------------------------------------------------------
; CustomDlgProc
; -----------------------------------------------------------------------------------------
CustomDlgProc proc
    mov [rsp + 8],  rcx  
    mov [rsp + 16], rdx  
    mov [rsp + 24], r8   
    mov [rsp + 32], r9   
    
    push rbp
    mov rbp, rsp
    sub rsp, 320h        

    cmp edx, WM_PAINT
    je  _Paint
    cmp edx, WM_DESTROY
    je  _Destroy
    cmp edx, WM_CREATE
    je  _Create

    cmp edx,14h
    je _EraseBg
  
HandleDefault:
    mov rcx, [rbp + 16]  
    mov rdx, [rbp + 24]
    mov r8,  [rbp + 32]
    mov r9,  [rbp + 40]

    sub rsp, 20h         
    call DefWindowProcA  
    add rsp, 20h
    
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
    mov r13d, dword ptr[rbp - 100h]   ; Load QWORD 0 (Flags in lower 32 bits)

    ;mov rsi, [rbp+16]            ; Save HWND in a stable register
    ;simd root
    ;vmovdqu64 zmm0, [rax + 0]    ; Snatched bytes 0-63   (Flags + Padding + Value A-D)
    ;vmovdqu64 zmm1, [rax + 64]   ; Snatched bytes 64-127  (Value E-L)
    ;vmovdqu64 zmm2, [rax + 128]  ; Snatched bytes 128-191 (Value M-T)
    ;vmovdqu64 zmm3, [rax + 192]  ; Snatched bytes 192-255 (Value U-Z)

    ;vmovdqu64 [rbp - 256], zmm0
    ;vmovdqu64 [rbp - 192], zmm1
    ;vmovdqu64 [rbp - 128], zmm2
    ;vmovdqu64 [rbp - 64],  zmm3


    ; Now pull the 'a' flag
    ;mov rcx, rsi            ; HWND
    ;xor rdx, rdx            ; Offset 0
    ;sub rsp, 28h
    ;call GetWindowLongPtrA
    ;add rsp, 28h
    
    ;mov r13,rax

; --- Assume R15D contains your 32-bit Attribute Field (a-z) ---
    sub rsp,28h
    ; 2. Get the area (You still need the HWND for this)
    ; Assuming your proc puts HWND in R9 or a stack slot
    mov rcx, [rbp+16]       ; HWND
    lea rdx, [rbp-48]       ; RECT
    call GetClientRect

    add rsp,28h

    mov r12,[rbp+32]
_HandleA:
    bt r13d, 0
    jnc _HandleB   
    mov rax, qword ptr[rbp-100h+32]
    ;To be implemented
    ; ...

_HandleB:
    bt r13d, 1
    jnc _HandleC
    mov rax, [rbp - 0D8h]   ; Snatched 'b' (224 - 8 = 216 or D8h)
    mov rcx,rax
    call ColorBtnRect
    ; [ Implementation for 'b' ]
    ; ...

_HandleC:
    bt r13d, 2
    jnc _HandleD
    mov rax, [rbp - 0D0h]
 

_HandleD:
    bt r13d, 3
    jnc _HandleE
    mov rax, [rbp - 0C8h]
    ; ...

_HandleE:
    bt r13d, 4
    jnc _HandleF
    mov rax, [rbp - 0C0h]
    ; ...

_HandleF:
    bt r13d, 5
    jnc _HandleG
   

    

     mov rax, [rbp - 0B8h]
     mov rcx,rax
     call SetForeground

   

    
    
    ; ...

_HandleG:
    bt r13d, 6
    jnc _HandleH
    mov rax, [rbp - 0B0h]
    ; ...

_HandleH:
    bt r13d, 7
    jnc _HandleI
    ; ...
    mov rax, [rbp - 0A8h]
_HandleI:
    bt r13d, 8
    jnc _HandleJ
    mov rax, [rbp - 0A0h]
    ; ...

_HandleJ:
    bt r13d, 9
    jnc _HandleK
    mov rax, [rbp - 098h]

_HandleK:
    bt r13d, 10
    jnc _HandleL
    mov rax, [rbp - 090h]
    ; ...

_HandleL:
    bt r13d, 11
    jnc _HandleM
    mov rax, [rbp - 088h]
    ; ...

_HandleM:
    bt r13d, 12
    jnc _HandleN
    mov rax, [rbp - 080h]
    ; ...

_HandleN:
    bt r13d, 13
    jnc _HandleO
    mov rax, [rbp - 078h]
    ; ...

_HandleO:
    bt r13d, 14
    jnc _HandleP
    mov rax, [rbp - 070h]
    ; ...

_HandleP:
    bt r13d, 15
    jnc _HandleQ
    mov rax, [rbp - 068h]
    ; ...

_HandleQ:
    bt r13d, 16
    jnc _HandleR
    mov rax, [rbp - 060h]
    ; ...

_HandleR:
    bt r13d, 17
    jnc _HandleS
    mov rax, [rbp - 058h]
    ; ...

_HandleS:
    bt r13d, 18
    jnc _HandleT
    mov rax, [rbp - 050h]
    ; ...

_HandleT:
    bt r13d, 19
   jnc _HandleU
   mov rax, [rbp - 048h]
    ; ...

_HandleU:
    bt r13d, 20
    jnc _HandleV
    mov rax, [rbp - 040h]
    ; ...

_HandleV:
    bt r13d, 21
   jnc _HandleW
   mov rax, [rbp - 038h]
    ; ...

_HandleW:
    bt r13d, 22
   jnc _HandleX
   mov rax, [rbp - 030h]
    ; ...

_HandleX:
    bt r13d, 23
    jnc _HandleY
    mov rax, [rbp - 028h]
    ; ...

_HandleY:
    bt r13d, 24
     jnc _HandleZ
     mov rax, [rbp - 020h]
    ; ...

_HandleZ:
    bt r13d, 25
    jnc _GauntletEnd
    mov rax, [rbp - 018h]
    ; [ Implementation for 'z' ]
    ; ...

_GauntletEnd:
    ; All attributes processed.
    ; Continue to rendering/cleanup...


    

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
    leave 
    ret
    sub rsp, 28h
    mov rdx, -16
    call GetWindowLongPtrA
    add rsp, 28h

    mov r10, 00C40000h       ; WS_CAPTION | WS_THICKFRAME
    not r10                  
    and rax, r10

    mov r8, rax              
    mov rdx, -16             
    mov rcx, [rbp + 16]      
    sub rsp, 28h
    call SetWindowLongPtrA   
    add rsp, 28h

    mov rcx, [rbp + 16]
    lea rdx, [rbp - 48]  
    sub rsp, 28h
    call GetWindowRect   
    add rsp, 28h

    sub rsp, 28h             
    mov dword ptr [rbp-56], 0
    mov dword ptr [rbp-52], 0
    mov rcx, [rbp + 16]      
    lea rdx, [rbp - 56]      
    call ClientToScreen      
    add rsp, 28h

    sub rsp, 38h
    mov rax, 0
    mov eax, dword ptr[rbp-40]
    sub eax, dword ptr[rbp-56]
    mov qword ptr[rsp+20h], rax 
    
    mov rax, 0
    mov eax, dword ptr[rbp-36]
    sub eax, dword ptr[rbp-52]
    mov qword ptr[rsp+28h], rax
    mov qword ptr[rsp+30h], 0020h ; SWP_FRAMECHANGED

    mov r9d, dword ptr[rbp-52]    ; y
    mov r8d, dword ptr[rbp-56]    ; x
    xor rdx, rdx                
    mov rcx, [rbp + 16]   
    call SetWindowPos        
    add rsp, 38h
    
    leave
    ret

_Destroy:
    xor rax, rax         
    leave
    ret

_Paint:
   
    mov rcx, [rbp + 16]
    lea rdx, [rbp - 128] 
    sub rsp, 20h
    call BeginPaint
    mov r12, rax         
    add rsp, 20h

    mov rcx, [rbp + 16]
    lea rdx, [rbp - 48]  
    sub rsp, 20h
    call GetClientRect   
    add rsp, 20h

    
    ;call WinStyle7

    mov rcx, [rbp + 16]
    lea rdx, [rbp - 128]
    sub rsp, 20h
    call EndPaint
    add rsp, 20h

    xor rax, rax         
    leave 
    ret
CustomDlgProc endp

; -----------------------------------------------------------------------------------------
; Window Styles Library
; -----------------------------------------------------------------------------------------

WinStyle0 proc
    mov rcx, 17          
    call ColorBtnRect 
    sub rsp, 30h
    lea rcx, [rbp-48]
    mov rdx, -10
    mov r8, -10
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle0 endp

WinStyle1 proc
    mov rcx, 17          
    call ColorBtnRect 
    sub rsp, 30h
    lea rcx, [rbp-48]
    mov rdx, 0
    mov r8, -100
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle1 endp

WinStyle2 proc
    mov rcx, 17          
    call ColorBtnRect 
    sub rsp, 30h
    lea rcx, [rbp-48]
    mov rdx, -100
    mov r8, 0
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle2 endp

Winstyle3 proc
    mov rcx, 17          
    call ColorBtnRect 
    sub rsp, 30h
    lea rcx, [rbp-48]
    mov rdx, 0
    mov r8, -100
    call InflateRect
    add rsp, 30h
    add dword ptr[rbp-36], 1000
    mov rcx, 25
    call ColorBtnRect
    ret
Winstyle3 endp

Winstyle4 proc
    mov rcx, 17 
    call ColorBtnRect
    mov eax, dword ptr [rbp-36]   
    sub eax, dword ptr [rbp-44]   
    imul eax, 50                  
    cdq                           
    mov ecx, 100
    idiv ecx                      
    mov edx, dword ptr [rbp-44]   
    add edx, eax                  
    mov dword ptr [rbp-36], edx   
    mov rcx, 25                   
    call ColorBtnRect              
    ret
Winstyle4 endp

Winstyle5 proc
    mov rcx, 17 
    call ColorBtnRect
    mov eax, dword ptr [rbp-36]   
    sub eax, dword ptr [rbp-44]   
    imul eax, 20                  
    cdq                           
    mov ecx, 100
    idiv ecx                      
    mov edx, dword ptr [rbp-44]   
    add edx, eax                  
    mov dword ptr [rbp-36], edx   
    mov rcx, 25                   
    call ColorBtnRect              
    mov rcx, 0
    call ColorBtnBorder
    ret
Winstyle5 endp

WinStyle6 proc
    mov eax, dword ptr [rbp-36]   
    sub eax, dword ptr [rbp-44]   
    imul eax, 5                  
    cdq                           
    mov ecx, 100
    idiv ecx                      
    sub rsp, 8
    mov dword ptr [rbp-8], eax
    mov rcx, 10
    call ColorBtnRect
    mov r13, 19
_loop:
    mov eax, dword ptr[rbp-8]
    add dword ptr[rbp-44], eax
    mov rcx, 15
    call ColorBtnRect
    mov eax, dword ptr[rbp-8]
    add dword ptr[rbp-44], eax
    mov rcx, 10
    call ColorBtnRect
    dec r13
    cmp r13, 0
    jg _loop
    add rsp, 8
    ret
WinStyle6 endp

WinStyle7 proc
    mov rcx, 17          
    call ColorBtnRect 
    mov eax, dword ptr [rbp-36]   
    sub eax, dword ptr [rbp-44]   
    imul eax, 10
    cdq
    mov ecx, 100
    idiv ecx                      
    mov r9d, dword ptr [rbp-44]   
    add r9d, eax                  
    mov eax, dword ptr [rbp-40]   
    sub eax, dword ptr [rbp-48]   
    imul eax, 10
    cdq                           
    mov ecx, 100
    idiv ecx                      
    mov r8d, dword ptr [rbp-48]   
    add r8d, eax                  
    mov edx, r9d
    sub rsp, 30h
    lea rcx, [rbp-48]
    neg r8d
    neg edx
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle7 endp

WinStyle8 proc
    mov rcx, 17          
    call ColorBtnRect 
    mov eax, dword ptr [rbp-36]   
    sub eax, dword ptr [rbp-44]   
    imul eax, 10
    cdq
    mov ecx, 100
    idiv ecx                      
    mov r9d, dword ptr [rbp-44]   
    add r9d, eax                  
    mov eax, dword ptr [rbp-40]   
    sub eax, dword ptr [rbp-48]   
    imul eax, 10
    cdq                           
    mov ecx, 100
    idiv ecx                      
    mov r8d, dword ptr [rbp-48]   
    add r8d, eax                  
    mov edx, 0
    sub edx, r9d
    mov eax, r8d
    mov r8d, 0
    sub r8d, eax
    sub rsp, 30h
    lea rcx, [rbp-48]
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle8 endp

WinStyle9 proc
    mov rcx, 17          
    call ColorBtnRect 
    mov ebx, dword ptr [rbp-36]   
    sub ebx, dword ptr [rbp-44]   
    mov r9d, dword ptr [rbp-44]   
    add r9d, ebx                  
    mov ebx, dword ptr [rbp-40]   
    sub ebx, dword ptr [rbp-48]   
_retry:
    rdrand eax               
    jnc _retry               
    xor edx, edx             
    mov ecx, ebx             
    div ecx                  
    inc edx                  
    mov eax, edx
    mov edx, 0
    sub edx, eax
    mov r8d, 0
    sub r8d, eax
    sub rsp, 30h
    lea rcx, [rbp-48]
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle9 endp

WinStyle10 proc
    mov rcx, 17          
    call ColorBtnRect 
    mov ebx, dword ptr [rbp-36]   
    sub ebx, dword ptr [rbp-44]   
_retry:
    rdrand eax               
    jnc _retry               
    xor edx, edx             
    mov ecx, ebx             
    div ecx                  
    inc edx  
    mov r9d, dword ptr [rbp-44]   
    add r9d, edx                  
    mov ebx, dword ptr [rbp-40]   
    sub ebx, dword ptr [rbp-48]   
_retry1:
    rdrand eax               
    jnc _retry1               
    xor edx, edx             
    mov ecx, ebx             
    div ecx                  
    inc edx                  
    mov eax, edx
    mov edx, 0
    sub edx, eax
    mov r8d, 0
    sub r8d, r9d
    sub rsp, 30h
    lea rcx, [rbp-48]
    call InflateRect
    add rsp, 30h
    mov rcx, 25
    call ColorBtnRect
    ret
WinStyle10 endp

; -----------------------------------------------------------------------------------------
; Class Registration
; -----------------------------------------------------------------------------------------
RegisterCustomDlgProc proc
    push r15
    sub rsp, 20h
    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax         
    add rsp, 20h

    mov dword ptr [bwc], 80             
    mov dword ptr [bwc + 4], 3  
    mov dword ptr[bwc+20],256
    lea rcx, CustomDlgProc
    mov qword ptr [bwc + 8], rcx        
    mov qword ptr [bwc + 24], r15       
    lea rcx, CustomDLGCLASSNAME
    mov qword ptr [bwc + 64], rcx       

    sub rsp, 20h
    lea rcx, bwc
    call RegisterClassExA               
    add rsp, 20h

    pop r15
    ret
RegisterCustomDlgProc endp

end
