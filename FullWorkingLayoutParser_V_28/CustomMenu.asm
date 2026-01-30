include constants.inc



.data
WC db 80 dup(0)
CustomMenuName db "Custom Menu",0



.code





CustMenuProc proc

cmp rdx,2
je _Exit

sub rsp, 28h
    call DefWindowProcA
    add rsp, 28h
    ret
_Exit:
    xor rcx, rcx
    call PostQuitMessage
    xor rax, rax
    ret


CustMenuProc endp


CreateCustMenu proc



ret
CreateCustMenu endp

RegisterCustMenu proc
push r15
    sub rsp, 30h            ; Extra space for safety and alignment

    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax          

    
    mov dword ptr [WC], 80          
    mov dword ptr [WC + 4], 3       
    
    lea rcx, CustMenuProc
    mov qword ptr [WC + 8], rcx     
    
    mov dword ptr [WC + 16], 0     
    mov dword ptr [WC + 20], 256    
    
    mov qword ptr [WC + 24], r15    
    
   
    mov qword ptr [WC + 32], 0      
    mov qword ptr [WC + 40], 0      
    mov qword ptr [WC + 48], 0      
    mov qword ptr [WC + 56], 0      
    
    

    lea rcx, CustomMenuName
    mov qword ptr [WC + 64], rcx    
    
  
    mov qword ptr [WC + 72], 0

    lea rcx, WC
    call RegisterClassExA           

    add rsp, 30h
    pop r15




ret
RegisterCustMenu endp


end
