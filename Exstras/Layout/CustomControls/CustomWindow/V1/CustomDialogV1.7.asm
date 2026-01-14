; =========================================================================================
; Module Name: CustomDialog.asm (v1.7)
; =========================================================================================

include constants.inc

extern DefWindowProcA   : proc
extern RegisterClassExA : proc
extern GetModuleHandleA : proc
extern BeginPaint       : proc
extern EndPaint         : proc
extern FillRect         : proc
extern GetClientRect    : proc
extern PostQuitMessage  : proc
extern InflateRect      : proc
extern ColorBtnBorder   : proc
extern ColorBtnRect     : proc 

.data
    CustomDLGCLASSNAME  db "Custom DLG", 0
    
    align 8
    bwc                 db 80 dup (0)

.code

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

    call WinStyle10

    mov rcx, [rbp + 16]
    lea rdx, [rbp - 128]
    sub rsp, 20h
    call EndPaint
    add rsp, 20h

    xor rax, rax         
    leave 
    ret
CustomDlgProc endp

WinStyle0 proc
    mov rcx, 17          
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
    mov rcx, 17          
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
    mov rcx, 17          
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
    mov rcx, 17          
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
    mov rcx,17 
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

    mov rcx,0
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

    sub rsp,8
    mov dword ptr [rbp-8],eax

    mov rcx,10
    call ColorBtnRect

    mov r13,19
_loop:
    mov eax,dword ptr[rbp-8]
    add dword ptr[rbp-44],eax
    mov rcx,15
    call ColorBtnRect

    mov eax,dword ptr[rbp-8]
    add dword ptr[rbp-44],eax
    mov rcx,10
    call ColorBtnRect

    dec r13
    cmp r13,0
    jg _loop

    add rsp,8
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
    
    mov edx,r9d

    sub rsp,30h
    lea rcx, [rbp-48]
    neg r8d
    neg edx
    call InflateRect
    add rsp,30h
    
    mov rcx,25
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
    
    mov edx,0
    sub edx,r9d

    mov eax,r8d
    mov r8d,0
    sub r8d,eax

    sub rsp,30h
    lea rcx, [rbp-48]
    call InflateRect
    add rsp,30h
    
    mov rcx,25
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

    mov eax,edx
    mov edx,0
    sub edx,eax

    mov r8d,0
    sub r8d,eax

    sub rsp,30h
    lea rcx, [rbp-48]
    call InflateRect
    add rsp,30h

    mov rcx,25
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

    mov eax,edx
    mov edx,0
    sub edx,eax

    mov r8d,0
    sub r8d,r9d

    sub rsp,30h
    lea rcx, [rbp-48]
    
    call InflateRect
    add rsp,30h
    
    mov rcx,25
    call ColorBtnRect
    ret
WinStyle10 endp

RegisterCustomDlgProc proc
    push r15
    sub rsp, 20h
    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax         
    add rsp, 20h

    mov dword ptr [bwc], 80             
    mov dword ptr [bwc + 4], 3          
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
