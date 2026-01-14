    ; =========================================================================================
    ; Module Name: CustomDialog.asm (v1.5)
    ; Description: High-performance "Owned" Window Engine for the Binsapd framework.
    ; =========================================================================================

    include constants.inc

    ; --- Win32 API Definitions ---
    extern DefWindowProcA   : proc
    extern RegisterClassExA : proc ; Using 'Ex' for 80-byte WNDCLASSEX support
    extern GetModuleHandleA : proc
    extern BeginPaint       : proc
    extern EndPaint         : proc
    extern FillRect         : proc
    extern GetClientRect    : proc
    extern PostQuitMessage  : proc
    extern InflateRect  : proc
    extern ColorBtnBorder  : proc

    ; --- External Framework Logic ---
    extern ColorBtnRect     : proc ; GPU-level custom drawing engine

    .data
        ; Class Branding
        CustomDLGCLASSNAME  db "Custom DLG", 0
    
        ; WNDCLASSEX Structure (80 bytes for x64)
        align 8
        bwc                 db 80 dup (0)

    .code

    ; -----------------------------------------------------------------------------------------
    ; CustomDlgProc: The "Brain" of the External Dialog
    ; Handles Non-Client (Title Bar) and Client (Custom Drawing) messages.
    ; -----------------------------------------------------------------------------------------
    CustomDlgProc proc
        ; Preserve Home Slots for OS parameters
        mov [rsp + 8],  rcx  ; HWND
        mov [rsp + 16], rdx  ; uMsg
        mov [rsp + 24], r8   ; wParam
        mov [rsp + 32], r9   ; lParam
    
        push rbp
        mov rbp, rsp
        sub rsp, 320h        ; Frame allocation for PAINTSTRUCT and RECT

        ; --- Message Dispatcher ---
        cmp edx, WM_PAINT
        je  _Paint

        cmp edx, WM_DESTROY
        je  _Destroy
  
    HandleDefault:
        ; Restore registers for the Default Window Procedure
        mov rcx, [rbp + 16]  
        mov rdx, [rbp + 24]
        mov r8,  [rbp + 32]
        mov r9,  [rbp + 40]

        sub rsp, 20h         ; 32-byte Shadow Space (16-byte aligned)
        call DefWindowProcA  ; Handles the "Standard Stuff" (Title Bar, X)
        add rsp, 20h
    
        leave
        ret

    _Destroy:
        xor rax, rax         ; OS expects 0 for successful destruction
        leave
        ret



    _Paint:
        ; --- Step 1: Initialize Graphics Context ---
        mov rcx, [rbp + 16]
        lea rdx, [rbp - 128] ; PTR to PAINTSTRUCT
        sub rsp, 20h
        call BeginPaint
        mov r12, rax         ; Store HDC in Non-Volatile R12
        add rsp, 20h

        ; --- Step 2: Fetch Client Dimensions ---
        mov rcx, [rbp + 16]
        lea rdx, [rbp - 48]  ; PTR to RECT
        sub rsp, 20h
        call GetClientRect   ; Gets real 0,0,W,H
        add rsp, 20h

        call WinStyle5;relative
        

        ; --- Step 4: Finalize Frame ---
        mov rcx, [rbp + 16]
        lea rdx, [rbp - 128]
        sub rsp, 20h
        call EndPaint
        add rsp, 20h

        xor rax, rax         ; Flag frame as complete
        leave 
        ret
    CustomDlgProc endp


    WinStyle0 proc
    ;Bordered window
   
    ; --- Step 3: Execute Custom Drawing (Socks Off Logic) ---
        mov rcx, 17          ; Framework Color ID (Grey-Blue)
        ; ColorBtnRect assumes HDC in R12 and RECT at [rbp-48]
        call ColorBtnRect 

     sub rsp,30h
    lea rcx, [rbp-48]
    mov rdx,-10
    mov r8,-10
    call InflateRect
    add rsp,30h
    

    mov rcx,25
    call ColorBtnRect

    ret
    WinStyle0 endp


    WinStyle1 proc

     mov rcx, 17          ; Framework Color ID (Grey-Blue)
        ; ColorBtnRect assumes HDC in R12 and RECT at [rbp-48]
        call ColorBtnRect 

     sub rsp,30h
    lea rcx, [rbp-48]
    mov rdx,0
    mov r8,-100
    call InflateRect
    add rsp,30h
    

    mov rcx,25
    call ColorBtnRect

    ret
    WinStyle1 endp


    WinStyle2 proc

    mov rcx, 17          ; Framework Color ID (Grey-Blue)
        ; ColorBtnRect assumes HDC in R12 and RECT at [rbp-48]
        call ColorBtnRect 

     sub rsp,30h
    lea rcx, [rbp-48]
    mov rdx,-100
    mov r8,0
    call InflateRect
    add rsp,30h
    

    mov rcx,25
    call ColorBtnRect

    ret
    WinStyle2 endp

   Winstyle3 proc

   ;makes first colorbtnrect 
   mov rcx, 17          ; Framework Color ID (Grey-Blue)
        ; ColorBtnRect assumes HDC in R12 and RECT at [rbp-48]
        call ColorBtnRect 

     sub rsp,30h
    lea rcx, [rbp-48]
    mov rdx,0
    mov r8,-100
    call InflateRect
    add rsp,30h

    add dword ptr[rbp-36],1000
    

    mov rcx,25
    call ColorBtnRect

   ret
   Winstyle3 endp


   Winstyle4 proc

   mov rcx,17 
   call ColorBtnRect

   mov eax, dword ptr [rbp-36]   ; EAX = Bottom
   sub eax, dword ptr [rbp-44]   ; EAX = Height (Bottom - Top)

 ; 2. Calculate 20% of Height (Height * 20 / 100)
   imul eax, 50                  ; Height * 20
   cdq                           ; Prepare for division
   mov ecx, 100
   idiv ecx                      ; EAX = 20% of Height

    ; 3. Update the RECT for the next draw
    ; We want the top bar, so NewBottom = OldTop + CalculatedHeight
    mov edx, dword ptr [rbp-44]   ; EDX = OldTop
    add edx, eax                  ; EDX = OldTop + 20% Height
    mov dword ptr [rbp-36], edx   ; Set RECT Bottom to this new point

    ; 4. Now Draw the 20% "Header"
    mov rcx, 25                   ; Color ID 25
    call ColorBtnRect             ; Colors only the top 20%

    

   ret
   Winstyle4 endp

   Winstyle5 proc

   mov rcx,17 
   call ColorBtnRect

   mov eax, dword ptr [rbp-36]   ; EAX = Bottom
   sub eax, dword ptr [rbp-44]   ; EAX = Height (Bottom - Top)

 ; 2. Calculate 20% of Height (Height * 20 / 100)
   imul eax, 20                  ; Height * 20
   cdq                           ; Prepare for division
   mov ecx, 100
   idiv ecx                      ; EAX = 20% of Height

    ; 3. Update the RECT for the next draw
    ; We want the top bar, so NewBottom = OldTop + CalculatedHeight
    mov edx, dword ptr [rbp-44]   ; EDX = OldTop
    add edx, eax                  ; EDX = OldTop + 20% Height
    mov dword ptr [rbp-36], edx   ; Set RECT Bottom to this new point

    ; 4. Now Draw the 20% "Header"
    mov rcx, 25                   ; Color ID 25
    call ColorBtnRect             ; Colors only the top 20%

    mov rcx,0
    call ColorBtnBorder
   ret
   Winstyle5 endp





    ; -----------------------------------------------------------------------------------------
    ; RegisterCustomDlgProc: Injects the Class into the OS Kernel
    ; -----------------------------------------------------------------------------------------
    RegisterCustomDlgProc proc
        push r15
        sub rsp, 20h
        xor rcx, rcx
        call GetModuleHandleA 
        mov r15, rax         ; r15 = Process Instance Handle
        add rsp, 20h

        ; --- Initialize "DNA" of the Dialog ---
        mov dword ptr [bwc], 80             ; Structure Size
        mov dword ptr [bwc + 4], 3          ; CS_HREDRAW | CS_VREDRAW
        lea rcx, CustomDlgProc
        mov qword ptr [bwc + 8], rcx        ; Window Procedure
        mov qword ptr [bwc + 24], r15       ; hInstance
        lea rcx, CustomDLGCLASSNAME
        mov qword ptr [bwc + 64], rcx       ; Class Name

        sub rsp, 20h
        lea rcx, bwc
        call RegisterClassExA               ; Final Registration
        add rsp, 20h

        pop r15
        ret
    RegisterCustomDlgProc endp

    end
