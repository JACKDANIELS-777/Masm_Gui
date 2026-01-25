; see main.asm to see how this works

extern GetDlgItem:proc
extern MessageBoxA:proc
extern GetDC:proc
extern ReleaseDC:proc
extern GetClientRect:proc
extern CreateSolidBrush:proc
extern DeleteObject:proc
extern FillRect:proc


extern hwndMain:qword
extern StrToInt:proc



.data
StCL qword "StCl    "
MsgB qword "MsgB    "
public RanTrench
RanTrench db 0
IsRanTrench db 0 


.data?
    VREG_BASE    dq 16 dup(?)  
    VREG_LOCK    db ?          


.code

TrenchScriptProc proc
cmp byte ptr[RanTrench],255
jne _Err

;rcx the ptr to the str
mov r14,rcx

call GetTrenchLen
mov r13,rax
cmp rdx,0
jne _Err

_Interpret_Trench:



    test r13, r13              
    jz _Gauntlet_Done           

    mov rax, [r14]              
    bswap rax


    
    cmp rax, MsgB
    je _MsgB


    cmp rax,  StCL              
    je _Handle_SetColor

    jmp _Next_Instruction 

_MsgB:
    add r14,8
    sub rsp,20h
    mov rcx,0
    mov rdx,r14
    mov r8, r14
    mov r9,2

    call MessageBoxA
    add rsp,20h
    
    dec r13

    jmp _Next_Instruction
 _Handle_SetColor:

    add r14,8

    mov rcx,r14
    call StrToInt
    nop
    sub rsp, 28h            
    mov rcx, hwndMain       
    mov rdx, rax      
    call GetDlgItem         
    add rsp, 28h
    ;rax wnd handle

    

    
    sub rsp, 48h                
    mov r12, rax                

 
    mov rcx, r12
    call GetDC
    mov rdi, rax                

   
    mov rcx, r12
    lea rdx, [rsp + 20h]        
    call GetClientRect

    add r14,8
    mov rcx, [r14]          
    call CreateSolidBrush
    mov r15, rax                

  
    mov rcx, rdi                
    lea rdx, [rsp + 20h]        
    mov r8,  r15                
    call FillRect


    mov rcx, r15
    call DeleteObject          
    mov rcx, r12                
    mov rdx, rdi                
    call ReleaseDC              

    add rsp, 48h
    
    sub r13,2
    jmp _Next_Instruction
   
_Next_Instruction:
    add r14, 8                  
    dec r13                     
    jmp _Interpret_Trench
_Gauntlet_Done:
mov byte ptr[IsRanTrench],1
mov byte ptr[RanTrench],0


ret

_Err:
    cmp byte ptr[IsRanTrench],1
    je _done
    inc byte ptr[RanTrench]
    
_done:
    ret
TrenchScriptProc endp



GetTrenchLen proc
          
    mov rdi, rcx        
    xor al, al         
    mov rcx, -1       
    
    repne scasb         
    
   
    not rcx             
    dec rcx             
    
    
    mov rax, rcx
    xor rdx, rdx
    mov r8, 8
    div r8              
    
          
    ret
GetTrenchLen endp


end
