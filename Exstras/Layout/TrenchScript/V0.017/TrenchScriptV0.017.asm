


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
extern LineTo:proc
extern MoveToEx:proc
extern GetStockObject:proc
extern GetTickCount64:proc
extern CreateFileA:proc
extern GetFileSize:proc
extern ReadFile:proc
extern CloseHandle:proc
extern LayoutParser:proc



.data
StCL qword      "StCl    "
MsgB qword      "MsgB    "
JumpF qword     "JumpF   "
JumpB qword     "JumpB   "
Sleepcom qword  "Sleep   "
SetVD qword     "SetVD   "
GetD qword      "GetD    "
PrintV qword    "PrintV  "
CmpV qword      "CmpV    "
SubDV qword     "SubDV   "
AddDV qword     "AddDV   "
DrawL  qword    "DrawL   "
DrawVL  qword   "DrawVL  "
SetV  qword     "SetV    "
CmpSV  qword    "CmpSV   "
RandV  qword    "RandV   "
Cls  qword      "Cls     "
Proc_init qword "Proc    "
Proc_end  qword "EndP    "
Call_P    qword "CallP   "
Ret_P     qword "RetP    "
ChngCom   qword "ChngCom "
SwapStr   qword "SwapStr "
WarpS     qword "WarpS   "
GetTick   qword "GetTick "
ChgCode   qword "ChgCode "
ReadFilecom  qword "ReadFile"
ReadF      qword "ReadF   "
DumpS     qword "DumpS   "
LayPars   qword "LayPars "
LayParsM  qword "LayParsM"




Command_Table dq "MsgB    ", MsgB
    dq "StCl    ", StCL
    dq "JumpF   ", JumpF
    dq "JumpB   ", JumpB
    dq "Sleep   ", Sleepcom
    dq "SetVD   ", SetVD
    dq "GetD    ", GetD
    dq "PrintV  ", PrintV
    dq "CmpV    ", CmpV
    dq "SubDV   ", SubDV
    dq "AddDV   ", AddDV
    dq "DrawL   ", DrawL
    dq "DrawVL  ", DrawVL
    dq "SetV    ", SetV
    dq "CmpSV   ", CmpSV
    dq "RandV   ", RandV
    dq "Cls     ", Cls
    dq "Proc    ", Proc_init
    dq "EndP    ", Proc_end
    dq "CallP   ", Call_P
    dq "ChngCom ", ChngCom
    dq "SwapStr ", SwapStr
    dq "WarpS   ",WarpS
    dq "GetTick ",GetTick
    dq "ChgCode ",ChgCode
    dq "ReadFile",ReadFilecom
    dq "ReadF   ",ReadF
    dq "DumpS   ",DumpS
    dq "LayPars ",LayPars
    dq "LayParsM",LayParsM
    dq 0, 0 ; The "Void" (Null Terminator)




public RanTrench
RanTrench db 0
IsRanTrench db 0 
Start_Point dq 0


Procs_Table   dq 250 dup(0,0,0,0)
Proc_count dq 0
Proc_ret dq 0
Warp dq 0



.data?
    VREG_BASE    dq 16 dup(0)  
    VREG_LOCK    db ?       
    VMEM         dq 1000 dup(0) 
    scratchpad   dq 0




.code

TrenchScriptProc proc


    cmp byte ptr[RanTrench],255
    jne _Err

    mov r14,rcx
    mov [Start_Point],r14
    call GetTrenchLen
    mov r13,rax

    cmp rdx,0
    jne _Err

_Interpret_Trench:

    test r13, r13               
    jz _Gauntlet_Done           

    mov rax, [r14]              
    bswap rax
    
    lea rbx,_Next_Instruction

    lea rcx,_MsgB
    cmp rax,MsgB
    cmove rbx,rcx

    lea rcx,_MsgB
    cmp rax,MsgB
    cmove rbx,rcx

    lea rcx, _Handle_SetColor
    cmp rax, StCL
    cmove rbx, rcx

    lea rcx, _JumpF
    cmp rax, JumpF
    cmove rbx, rcx

    lea rcx, _JumpB
    cmp rax, JumpB
    cmove rbx, rcx

    lea rcx, _Sleep
    cmp rax, Sleepcom
    cmove rbx, rcx

    lea rcx, _SetVD
    cmp rax, SetVD
    cmove rbx, rcx

    lea rcx, _GetD
    cmp rax, GetD
    cmove rbx, rcx

    lea rcx, _PrintV
    cmp rax, PrintV
    cmove rbx, rcx

    lea rcx, _CmpV
    cmp rax, CmpV
    cmove rbx, rcx

    lea rcx, _SubDV
    cmp rax, SubDV
    cmove rbx, rcx

    lea rcx, _AddDV
    cmp rax, AddDV
    cmove rbx, rcx

    lea rcx, _DrawL
    cmp rax, DrawL
    cmove rbx, rcx

    lea rcx, _DrawVL
    cmp rax, DrawVL
    cmove rbx, rcx

    lea rcx, _SetV
    cmp rax, SetV
    cmove rbx, rcx

    lea rcx, _CmpSV
    cmp rax, CmpSV
    cmove rbx, rcx

    lea rcx, _RandV
    cmp rax, RandV
    cmove rbx, rcx

    lea rcx, _Cls
    cmp rax, Cls
    cmove rbx, rcx

    lea rcx, _Proc_init
    cmp rax, Proc_init
    cmove rbx, rcx

    lea rcx, _Call_P
    cmp rax, Call_P
    cmove rbx, rcx

    lea rcx, _Proc_end
    cmp rax, Proc_end
    cmove rbx, rcx

    lea rcx,_ChngCom
    cmp rax,ChngCom
    cmove rbx,rcx

    lea rcx,_SwapStr
    cmp rax,SwapStr
    cmove rbx,rcx

    lea rcx,_WarpS
    cmp rax,WarpS
    cmove rbx,rcx

    lea rcx,_GetTick
    cmp rax,GetTick
    cmove rbx,rcx


    lea rcx,_ChgCode
    cmp rax,ChgCode
    cmove rbx,rcx


    lea rcx, _ReadFile
    cmp rax,ReadFilecom
    cmove rbx,rcx

    lea rcx, _ReadF
    cmp rax,ReadF
    cmove rbx,rcx

    lea rcx,_DumpS
    cmp rax,DumpS
    cmove rbx,rcx

    lea rcx,_LayPars
    cmp rax,LayPars
    cmove rbx,rcx

    lea rcx,_LayParsM
    cmp rax,LayParsM
    cmove rbx,rcx


    jmp rbx

_LayParsM:
    ;ptr
    ;vmem addr
    
    add r14,8
    dec r13

    mov r15,[r14]

    add r14,8
    dec r13


    mov rcx,r14
    call StrToInt
    
    lea r12,VMEM
    add r12,rax

    push r13

    mov rcx,r12
    mov rdx,r15

    call LayoutParser

    pop r13

    jmp _Next_Instruction

_LayPars:
    ;ptr VMEM
    add r14,8
    dec r13

    lea r15,VMEM
    
    push r13

    mov rcx,r15

    mov rdx,[r14]
    call LayoutParser

    pop r13
     
    jmp _Next_Instruction


_DumpS:

    sub rsp,40h
    mov rcx,r14
    add rcx,8

    mov dil, byte ptr[rcx+8]
    mov byte ptr[rcx+8],0
    call OutputDebugStringA
    add rsp,40h

    
    mov byte ptr[r14+8],dil
    jmp _Next_Instruction

_ReadF:

    add r14,8
    dec r13

    lea rdi,VMEM
    mov rcx,r14
    call StrToInt

  
    add rdi,rax


    add r14,8
    dec r13

    sub rsp,40h
    mov rcx,r14
    mov rdx,80000000h
    mov r8,1
    mov r9,0
    mov qword ptr[rsp+20h],3
    mov qword ptr[rsp+28h],80h
    mov qword ptr[rsp+30h],0
    call CreateFileA

    add rsp,40h
    mov r15,rax

    sub rsp,28h
    mov rcx,r15
    mov rdx,0
    call GetFileSize
    mov r12,rax

    mov rcx,r15
    mov rdx,rdi
    mov r8,r12
    lea r9,scratchpad
    mov qword ptr[rsp+20h],0

    call ReadFile
    add rsp,28h

    sub rsp,20h
    mov rcx,r15
    call CloseHandle

    add rsp,20h
    lea r12,VMEM

    mov r15,r14
    mov rax,0

    _loop_null_0:
        add rax,1
        add r15,8
        cmp byte ptr[r15],0
        jne _loop_null_0


    sub r13,rax
    shl rax,3
    add r14,rax


    jmp _Next_Instruction
_ReadFile:

    add r14,8
    dec r13

    sub rsp,40h
    mov rcx,r14
    mov rdx,80000000h
    mov r8,1
    mov r9,0
    mov qword ptr[rsp+20h],3
    mov qword ptr[rsp+28h],80h
    mov qword ptr[rsp+30h],0

    call CreateFileA
    add rsp,40h
    mov r15,rax

    sub rsp,28h
    mov rcx,r15
    mov rdx,0
    call GetFileSize
    mov r12,rax

    mov rcx,r15
    lea rdx,VMEM
    mov r8,r12
    lea r9,scratchpad
    mov qword ptr[rsp+20h],0

    call ReadFile
    add rsp,28h

    sub rsp,20h
    mov rcx,r15
    call CloseHandle

    add rsp,20h
    lea r12,VMEM

    mov r15,r14
    mov rax,0

    _loop_null:
        add rax,1
        add r15,8
        cmp byte ptr[r15],0
        jne _loop_null


    sub r13,rax
    shl rax,3
    add r14,rax


    jmp _Next_Instruction


_ChgCode:


    add r14,8
    dec r13   ;how faR BACK 
    mov rcx,r14
    call StrToInt
    shl rax,3
    mov r15,rax



    add r14,8
    dec r13
    mov r12,[r14] ; ptr

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    shl rax,3
    mov r11,rax

    mov r10,r14
    sub r14,r15
    mov rdi,r14
    mov r14,r12
    mov rcx,r11
    call strcopy_ultra 

    mov r14,r10


    

    jmp _Next_Instruction


_GetTick:

    lea r15,VREG_BASE


    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    shl rax,3
    add r15,rax


    sub rsp, 28h      
    call GetTickCount64
    add rsp, 28h     
    
    mov r12, rax      

    mov [r15],r12


    jmp _Next_Instruction

_WarpS:
    
    mov r14,[Warp]
    jmp _Next_Instruction


_SwapStr:
    add r14,8
    dec r13

    mov r15,[r14]

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r13,rax

    mov [Warp],r14
    mov r14,r15
    
    
    jmp _Interpret_Trench

    
_ChngCom:


    add r14,8
    dec r13

    mov r15,[r14] ; command to change

    add r14,8
    dec r13

    mov r12,[r14] ; new command

    lea r11,Command_Table
    sub r11,16

_Find_Com:


    add r11,16
    mov r10,[r11]

    cmp r10,0
    je _done_com
    bswap r10
    cmp r10,r15
    jne _Find_Com

    bswap r12

    mov [r11],r12
    mov r8,[r11+8]
    mov [r8],r12


_done_com:

    jmp _Next_Instruction
    
_Proc_end:

    mov r14,[Proc_ret]
    dec r13

    jmp _Interpret_Trench
    
_Call_P:

    add r14,8
    dec r13


    mov r10,[r14]

    lea r11,Procs_Table
    sub r11,32


    
_Find_proc:


    add r11,32
    mov r12,[r11]
    cmp r12,r10
    jne _Find_proc
    
    add r14,8
    dec r13
    mov [Proc_ret],r14 

    mov r14,[r11+24]  
    mov r12,[r11+16]
    shr r12,3
    add r13,r12
    sub r13,2
    

    jmp _Interpret_Trench
_Proc_init:
    
    
    add r14,8
    dec r13

    mov r11,r14
    add r11,8

    mov rax, [Proc_count]  
    shl rax, 5             
    lea r15, [Procs_Table] 
    add r15, rax          
 

    mov rax,[r14]
    mov [r15],rax
    add r15,8
    mov rax,[Proc_count]
    mov [r15],rax
    inc Proc_count
    ;dec r13



    mov r8, Proc_end
 
    mov r9,r14

     
        
  
    mov r10,2  ;1 for Proc_Init included and proc name
    

_Search_end:


    inc r10
    add r9,8
    mov r12,[r9]
    bswap r12
    cmp r12,r8
    jne _Search_End

   
    sub r13,r10
    inc r13
    shl r10,3
    add r14,r10
    sub r14,8

    add r15,8
    mov [r15],r10
    add r15,8
    mov [r15],r11

    jmp _Interpret_Trench
    
_Cls:

    sub rsp,28h
    mov rcx,hwndMain
    call GetDC
    mov r12,rax



    mov rcx,4
    call GetStockObject
    mov r15,rax

    sub rsp,48

    mov rcx,hwndMain
    lea rdx, [rsp+60]
    call GetClientRect



    mov rcx,r12
    lea rdx,[rsp+60]
    mov r8,r15
    call FillRect
    add rsp,48

    mov rcx,hwndMain
    mov rdx,r12
    call ReleaseDC
    add rsp,28h

    jmp _Next_Instruction   


_RandV:
    
    lea r15,VREG_BASE
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    shl rax,3
    add r15,rax

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    mov rdi,rax


    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    mov rsi,rax




_RetryRand:
    
    
    rdrand rax             
    jnc _RetryRand         

    
    sub rsi, rdi          
    inc rsi              
    xor rdx, rdx
    div rsi                
    add rdx, rdi           

    mov [r15], rdx         





    jmp _Next_Instruction
    
_CmpSV:


    add r14,8
    dec r13


    lea r15,VREG_BASE

    mov rcx,r14
    call StrToInt
    shl rax,3

    add r15,rax


    add r14,8
    dec r13

    mov rcx, r14
    call StrToInt

    mov rdi,rax
    mov rsi,[r15]


    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    shl rax,3 
    mov r12,rax

    mov rbx,0
    cmp rdi,rsi


    cmovne rbx,r12


    add r14,rbx
    shr rbx,3
    sub r13,rbx



    jmp _Interpret_Trench
    
_SetV:
    
    
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    mov r15,rax
    shl r15,3

    lea r12,VREG_BASE
    add r12,r15

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt


    mov [r12],rax

    jmp _Next_Instruction



_DrawVL:
    
    
    add r14,8
    dec r13

    sub rsp,28h
    mov rcx, hwndMain
    call GetDC
    mov r12,rax


    mov rcx,r14
    call StrToInt
    mov rdi,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    
    lea rcx, VREG_BASE
    shl rdi,3
    add rcx,rdi
    mov rdx,[rcx]

    lea rcx, VREG_BASE
    shl rax,3
    add rcx,rax
    mov r8,[rcx]


    mov r9,0
    mov rcx,r12
    call MoveToEx



    add r14,8
    dec r13
    mov rcx, r14
    call StrToInt
    mov rdi,rax

    add r14,8
    dec r13
    mov rcx, r14
    call StrToInt
    

    lea rcx, VREG_BASE
    shl rdi,3
    add rcx,rdi
    mov rdx,[rcx]

    lea rcx, VREG_BASE
    shl rax,3
    add rcx,rax
    mov r8,[rcx]

    mov rcx,r12
    call LineTo



    mov rcx,hwndMain
    mov rdx,r12
    call ReleaseDC
    add rsp,28h




    jmp _Next_Instruction


_DrawL:
    
    
    add r14,8
    dec r13

    sub rsp,28h
    mov rcx, hwndMain
    call GetDC
    mov r12,rax


    mov rcx,r14
    call StrToInt
    mov rdi,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r8,rax
    mov rdx,rdi
    mov r9,0
    mov rcx,r12
    call MoveToEx



    add r14,8
    dec r13
    mov rcx, r14
    call StrToInt
    mov rdi,rax

    add r14,8
    dec r13
    mov rcx, r14
    call StrToInt
    mov r8,rax
    mov rdx,rdi
    mov rcx,r12
    call LineTo



    mov rcx,hwndMain
    mov rdx,r12

    call ReleaseDC
    add rsp,28h


    

    
    jmp _Next_Instruction


_AddDV:


    add r14,8
    dec r13
    lea r15,VREG_BASE

    mov rcx,r14
    call StrToInt
    shl rax,3
    add r15,rax
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r12,rax
    ;mov rcx, r15
    mov rax, [r15]
    ;call StrToInt
    add rax,r12
    mov rcx,rax

    mov rdi,r15
    mov [r15],rcx

    ;call IntToStr
    jmp _Next_Instruction



_SubDV:


    add r14,8
    dec r13
    lea r15,VREG_BASE
    mov rcx,r14
    call StrToInt
    shl rax,3
    add r15,rax
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r12,rax

    mov rax, [r15]

    ;call StrToInt

    sub rax,r12

    mov rcx,rax


    mov [r15],rcx
    ;mov rdi,r15
    ;call IntToStr

    jmp _Next_Instruction



_CmpV:

    add r14,8
    dec r13
    lea rdi, VREG_BASE
    mov rdi,qword ptr[rdi]
    mov rsi,r14

    mov rcx, rsi
    call StrToInt
    mov rsi,rax
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
    mov r15,rcx
    mov dil, byte ptr[rcx+8]
    mov byte ptr[rcx+8],0
    call OutputDebugStringA
    add rsp,40h
    mov byte ptr[r15+8],dil
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



_SetVD:


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

    sub rsp, 28h            
    mov rcx, hwndMain       
    mov rdx, rax      

    call GetDlgItem         
    add rsp, 28h
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




;GetTrenchLen proc
;    mov rdi, rcx        
 ;   xor al, al         
  ;  mov rcx, -1       
   ; repne scasb         
   ; not rcx             
   ; dec rcx             
    ;mov rax, rcx
    ;xor rdx, rdx
    ;mov r8, 8
   ; div r8              
    ;ret
;GetTrenchLen endp



GetTrenchLen proc


    mov rdi, rcx        
    mov rax, -1         
    mov rcx, -1         
    repne scasq         
    
    not rcx             
    dec rcx             
    
    
    
    mov rax, rcx        
           
    
    xor rdx, rdx
               
    ret

GetTrenchLen endp



IntToStr PROC

    push rdi
    mov rcx, 8


_fill_loop:

    mov [rdi], al
    inc rdi
    loop _fill_loop
    pop rdi
    push rdi
    mov rbx, 10
    xor rcx, rcx


_convert_loop:
    xor rdx, rdx
    div rbx
    push rdx
    inc rcx
    test rax, rax
    jnz _convert_loop




_write_loop:

    pop rax
    add al, '0'
    mov [rdi], al
    inc rdi
    loop _write_loop
    mov rax,[rdi]
    bswap rax
    and rax, 0000000000FFFFFFh
    mov [rdi],rax
    pop rdi
    ret
IntToStr ENDP








strcopy_ultra proc
    ; r14 = Source
    ; rdi = Destination
    ; rcx = Length (Number of bytes)

    cld
    mov rsi, r14        
    
    
    shr rcx, 3          
    rep movsq           
    
    ;mov byte ptr [rdi], 0 ; Final Sentinel

    ret
strcopy_ultra endp
end



