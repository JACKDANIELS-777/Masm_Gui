
extern GetDlgItem:proc
extern MessageBoxA:proc
extern GetDC:proc
extern ReleaseDC:proc
extern GetClientRect:proc
extern CreateSolidBrush:proc
extern DeleteObject:proc
extern FillRect:proc
extern Sleep:proc


extern hwndMain:qword
extern StrToInt:proc
extern GetStdHandle:proc
extern WriteConsoleA:proc
extern OutputDebugStringA:proc
extern GetLastError:proc



.data
StCL qword      "StCl    "
MsgB qword      "MsgB    "
JumpF qword     "JumpF   "
JumpB qword     "JumpB   "
Sleepcom qword  "Sleep   "
SetV qword      "SetV    "
GetD qword      "GetD    "
PrintV qword    "PrintV  "
CmpV qword      "CmpV    "
public RanTrench
RanTrench db 0
IsRanTrench db 0 



.data?
    VREG_BASE    dq 16 dup(0)  
    VREG_LOCK    db ?       
    VMEM         dq 100 dup(0) ; This should now be at BASE + 136 bytes
    scratchpad   dq 0

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

    cmp rax,JumpF
    je _JumpF

    cmp rax,JumpB
    je _JumpB
    
    cmp rax,Sleepcom
    je _Sleep

    cmp rax,SetV
    je _SetV

    cmp rax,GetD
    je _GetD

    cmp rax,PrintV
    je _PrintV

    cmp rax,CmpV
    je _CmpV





    jmp _Next_Instruction
_CmpV:
    add r14,8
    dec r13

    lea rdi, VREG_BASE
    mov rdi,qword ptr[rdi]
    ;VR 0
    mov rsi,qword ptr[r14]


    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    shl rax,3

    mov rbx,0
    cmp rdi,rsi
    cmovne rbx,rax



    
    add r14,rbx
    shr rbx,3
    sub r13,rbx

    jmp _Interpret_Trench
    
_PrintV:

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    mov rdi,rax
    shl rdi,3

    sub rsp,40h
    lea rcx,VREG_BASE
    add rcx,rdi
    mov byte ptr[rcx+8],0

    call OutputDebugStringA
    add rsp,40h


    jmp _Next_Instruction
    sub rsp,28h

    mov rcx,-11
    call GetStdHandle
    add rsp,28h


    sub rsp,30h
    mov rcx,rax
    
    lea rdx,VMEM
    add rdx,rdi
    mov r8,8
    lea r9,scratchpad

    mov qword ptr[rsp+20h],0
    call WriteConsoleA
    
    call GetLastError

    add rsp,30h

    jmp _Next_Instruction


    
_GetD:
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    shl rax,3

    lea rbx, VMEM
    add rbx ,rax

    mov rcx, qword ptr[rbx]

    mov qword ptr[VREG_BASE],rcx

    
    jmp _Next_Instruction
_SetV:

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    mov rdi,rax
    shl rdi,3


    add r14,8
    dec r13

    mov rcx,[r14]

   lea rax,VMEM
   add rax,rdi

 
   mov qword ptr[rax],rcx

   jmp _Next_Instruction

_Sleep:
    add r14,8
    
    mov rcx,r14
    call StrToInt
    sub rsp,28h
    mov rcx,rax
    call Sleep
    add rsp,28h

    dec r13
    jmp _Next_Instruction

_JumpB:

    mov rcx, r14
    add rcx,8
    call StrToInt

    add r13,rax

    shl rax,3
    sub r14,rax

    jmp _Interpret_Trench
_JumpF:
    mov rcx, r14
    add rcx,8
    call StrToInt 
    sub r13,rax

    shl rax,3
    add r14,rax

    
    jmp _Interpret_Trench
_MsgB:
    add r14,8
    mov dil, byte ptr[r14+8]

    cmp dil,0
    je _exit_mem 

    mov byte ptr[r14+8],0
 _exit_mem:  
    sub rsp,20h
    mov rcx,0
    mov rdx,r14
    mov r8, r14
    mov r9,2

    call MessageBoxA
    add rsp,20h


    cmp dil,0
    je  _exit_mem1  
    mov byte ptr[r14+8],dil

  _exit_mem1:  
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
