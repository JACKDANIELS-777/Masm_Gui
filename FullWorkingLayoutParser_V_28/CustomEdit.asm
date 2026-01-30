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
extern RoundBtnRect:proc
extern GetDC:proc
extern ReleaseDC:proc
extern GetClassLongPtrA:proc
extern GetObjectA:proc
extern DeleteObject:proc
extern CreateSolidBrush:proc
extern EventManagerTable:byte
extern AttrDataBuffer:byte

.data
align 8
bwc db 80 dup(0)
public EditClassName
EditClassName db "CustomEdit",0
debug db 0

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

    cmp edx,14h
    je _EraseBg
    
    jmp _HandleDefault
    ret
_EraseBg:
   
   cmp byte ptr[debug],1
   jne _exit_erase

   inc byte ptr[debug]
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
    ; event
    ; 0-31 id 32-64 proc index
    ;p proc
    mov r8d, eax          
 
    shr rax, 32             
    mov r9d, eax  
    
    lea r10,EventManagerTable
    sub r10,64
    _get_space:
        add r10,64
        mov r11,qword ptr[r10]

        mov rax,qword ptr[rbp+16]
        cmp r11,rax
        jne _continue  

        mov eax, dword ptr[r10+8]
        cmp eax, r8d
        je _done_space

    _continue:
        cmp r11,0
        jne _get_space

        

        

        

    _add_event:
        ;assume its a new entry
        mov rax, qword ptr[rbp+16]
        mov qword ptr[r10], rax
        mov dword ptr[r10+8],r8d
        mov dword ptr[r10+12],r9d
        
        
    
    
    _done_space:
   

      


_HandleF:
    bt r13d, 5
    jnc _HandleG
   

    

     mov rax, [rbp - 0B8h]
     mov rcx,rax
     call SetForeground

   

    
    

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

    mov rcx,rax
    call RoundBtnRect
    ; ...

_HandleS:
    
    bt r13d, 18
    jnc _HandleT

    sub rsp,28h
    mov rcx, [rbp+16]
    call GetParent

    mov rcx,rax
    mov rdx,-10
    call GetClassLongPtrA
    
  
    mov rcx,rax
    call GetDC
    mov ecx,eax
    mov r15d,eax

    ; INTERROGATE THE BRUSH DATA
    lea rdx, [rbp-10h]          ; Buffer on your stack
    mov r8, 12                  ; sizeof(LOGBRUSH)
    ; RCX is already the cleaned handle from ECX
    call GetObjectA
    mov r14d, [rbp-0Ch]

    mov rcx,r15
    call ReleaseDC
   



    add rsp,28h

    mov rax,[rbp-50h]
    ;first pos 0-9,223,372,036,854,775,807
    ;first negative 9,223,372,036,854,775,808 -> max 2^64
    ;cmp rax, 65535
    ;future use

    
    
    test rax, rax
    bt rax, 63
    js _negative_inflate
    
    

    

_positve_inflate:


    sub rsp,28h
    mov r8d,30
    mov r9d,30
    mov r10d,30
    call Color32
    mov rcx,rax
    call CreateSolidBrush
    add rsp,28h
    mov r15,rax

    sub rsp,28h
    mov rcx,[rbp+32]
    lea rdx,[rbp-48]
    mov r8,r15
    call FillRect
    add rsp,28h

    sub rsp,28h
    lea rcx, [rbp-48]
    mov rdx,rdx
    mov r8,rdx
    call InflateRect
    add rsp,28h


    mov rcx,[rbp - 0D8h]
    call ColorBtnRect  

    mov rcx,[rbp - 0B8h]
    call SetForeground
    jmp _HandleT
    
_negative_inflate:
    sub rsp,28h
    mov r8d,30
    mov r9d,30
    mov r10d,30
    call Color32
    
    mov rcx,rax
    call CreateSolidBrush
    add rsp,28h
    mov r15,rax

    

    sub rsp,28h
    mov rcx,[rbp+32]
    lea rdx,[rbp-48]
    mov r8,r15
    call FillRect
    add rsp,28h

    mov rdx, [rbp-50h]
    and rdx, 0FFFFh ;mask out just leave 16 bits

    sub rsp,28h
    lea rcx, [rbp-48]

    mov rbx,0
    sub rbx,rdx
    neg rdx
    mov rdx,rbx
    mov r8,rdx
    
    call InflateRect
    add rsp,28h




    sub rsp,28h
    mov rcx,r15
    call DeleteObject
    add rsp,28h


    mov rcx,[rbp - 0D8h]
    call ColorBtnRect

    mov rcx,[rbp - 0B8h]
    call SetForeground
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

_exit_erase:
    
    mov rax,1
    leave
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
    leave
    ret

_kill_focus:
    leave
    ret

_draw_edit:
    cmp byte ptr[debug],0
    je _exit_edit

    lea rdi, [rbp - 320h]
    mov rcx, 32                 ; 32 QWORDs (256 bytes)
    xor rax, rax
    rep stosq

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

    
    sub rsp,28h
    mov rcx,[rbp+16]
    mov rdx,40
    call GetWindowLongPtrA
    add rsp,28h
    mov rcx, rax
    call ColorBtnRect

    sub rsp,28h
    mov rcx,[rbp+16]
    mov rdx,72
    call GetWindowLongPtrA
    add rsp,28h

    mov rcx, rax
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
_exit_edit:
    mov byte ptr[debug],1
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
