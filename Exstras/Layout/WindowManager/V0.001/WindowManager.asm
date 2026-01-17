;super super early

include constants.inc
includelib Msimg32.lib

extern AlphaBlend:proc
extern GradientFill:proc
extern GetLastError:proc
extern CreateWindowExA:proc
extern DefWindowProcA:proc

.data
WC db 80 dup(0)
MainClassName db "Window Manager",0

.code

MainWndProc proc


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






MainWndProc endp



CreateMainWnd proc




sub rsp,60h


mov rcx,0
lea rdx,MainClassName
lea r8,MainClassName
mov r9,10CF0000h 
mov qword ptr[rsp+20h],10
mov qword ptr[rsp+28h],10
mov qword ptr[rsp+30h],400
mov qword ptr[rsp+38h],25  ; ie pos
mov qword ptr[rsp+40h],0
mov qword ptr[rsp+48h],0
mov qword ptr[rsp+50h],r15
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,60h

ret
CreateMainWnd endp


RegisterMainWnd proc


    push r15
    sub rsp, 30h            ; Extra space for safety and alignment

    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax          

    
    mov dword ptr [WC], 80          
    mov dword ptr [WC + 4], 3       
    
    lea rcx, MainWndProc
    mov qword ptr [WC + 8], rcx     
    
    mov dword ptr [WC + 16], 0     
    mov dword ptr [WC + 20], 256    
    
    mov qword ptr [WC + 24], r15    
    
   
    mov qword ptr [WC + 32], 0      
    mov qword ptr [WC + 40], 0      
    mov qword ptr [WC + 48], 0      
    mov qword ptr [WC + 56], 0      
    
    

    lea rcx, MainClassName
    mov qword ptr [WC + 64], rcx    
    
  
    mov qword ptr [WC + 72], 0

    lea rcx, WC
    call RegisterClassExA           

    add rsp, 30h
    pop r15
ret
RegisterMainWnd endp

end
