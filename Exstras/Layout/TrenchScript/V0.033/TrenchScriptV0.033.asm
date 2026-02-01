


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
LayParsP  qword "LayParsP"
MovRDVl qword   "MovRDVl "
MovRSVl qword   "MovRSVl "
MovRPVl qword   "MovRPVl "
ShlRR   qword   "ShlRR   "
ShlLR   qword   "ShlLR   "
MemFillM qword  "MemFillM"
MemCpyM qword   "MemCpyM "
IncR  qword     "IncR    "
DecR  qword     "DecR    "
AndR  qword     "AndR    "
OrR  qword      "OrR     "
AddReg  qword     "AddR    "
SubReg  qword     "SubR    "
XorReg  qword     "XorR    "
NotReg  qword     "NotR    "
CmpStrP  qword   "CmpStrP "
JeX     qword   "JeX     "
JneX   qword    "JneX    "
StkPshV qword   "StkPshV "
StkPopV qword   "StkPopV "
QueueP   qword  "QueueP  "
DequeE  qword   "DequeE  "
DequeNE qword   "DequeNE "
MovRBDVl qword  "MovRBDVl"
MovRWDVl qword  "MovRWDVl"
SwapRR qword    "SwapRR  "




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
    dq "LayParsP",LayParsP
    dq "MovRDVl ",MovRDVl
    dq "MovRSVl ",MovRSVl 
    dq "MovRPVl ",MovRPVl 
    dq "ShlRR   ",ShlRR
    dq "ShlLR   ",ShlLR
    dq "SwapRR  ",SwapRR
    dq "MemFillM",MemFillM
    dq "MemCpyM ",MemCpyM
    dq "IncR    ",IncR
    dq "DecR    ",DecR
    dq "AndR    ",AndR
    dq "OrR     ",OrR
    dq "AddR    ",AddReg
    dq "SubR    ",SubReg
    dq "XorR    ",XorReg
    dq "NotR    ",NotReg
    dq "CmpStrP ",CmpStrP
    dq "JeX     ",JeX
    dq "JneX    ",JneX
    dq "StkPshV ",StkPshV
    dq "StkPopV ",StkPopV
    dq "QueueP  ",QueueP
    dq "DequeE  ",DequeE
    dq "DequeNE ",DequeNE
    dq "MovRBDVl",MovRBDVl
    dq "MovRWDVl",MovRWDVl
    dq SwapRR ,    "SwapRR  "
   
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
    CmpFlag      dq 0
    CmpFlagCarry dq 0
    Queue        dq 100 dup(0,0)
    Queue_len    dq 0




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

    lea rcx,_LayParsP
    cmp rax,LayParsP
    cmove rbx,rcx

    lea rcx,_MovRDVl
    cmp rax,MovRDVl
    cmove rbx,rcx

    lea rcx,_MovRSVl
    cmp rax,MovRSVl
    cmove rbx,rcx

    lea rcx,_MovRPVl
    cmp rax,MovRPVl
    cmove rbx,rcx

    lea rcx,_ShlRR
    cmp rax,ShlRR
    cmove rbx,rcx

    lea rcx,_ShlLR
    cmp rax,ShlLR
    cmove rbx,rcx


    lea rcx,_MemFillM
    cmp rax,MemFillM
    cmove rbx,rcx



    lea rcx,_MemCpyM
    cmp rax,MemCpyM
    cmove rbx,rcx

    lea rcx,_IncR
    cmp rax,IncR
    cmove rbx,rcx


    lea rcx,_DecR
    cmp rax,DecR
    cmove rbx,rcx


    lea rcx,_AndR
    cmp rax,AndR
    cmove rbx,rcx

    lea rcx,_OrR
    cmp rax,OrR
    cmove rbx,rcx

    
    lea rcx,_AddR
    cmp rax,AddReg
    cmove rbx,rcx

    
    lea rcx,_SubR
    cmp rax,SubReg
    cmove rbx,rcx

    
    lea rcx,_XorR
    cmp rax,XorReg
    cmove rbx,rcx

    
    lea rcx,_NotR
    cmp rax,NotReg
    cmove rbx,rcx

    
    lea rcx,_CmpStrP
    cmp rax,CmpStrP
    cmove rbx,rcx

    
    
    lea rcx,_JeX
    cmp rax,JeX
    cmove rbx,rcx

    
    lea rcx,_JneX
    cmp rax,JneX
    cmove rbx,rcx


    lea rcx,_StkPshV
    cmp rax,StkPshV
    cmove rbx,rcx


    lea rcx,_StkPopV
    cmp rax,StkPopV
    cmove rbx,rcx

    lea rcx,_QueueP
    cmp rax,QueueP
    cmove rbx,rcx

    lea rcx,_DequeE
    cmp rax,DequeE
    cmove rbx,rcx

    lea rcx,_DequeNE
    cmp rax,DequeNE
    cmove rbx,rcx

    lea rcx,_MovRBDVl
    cmp rax,MovRBDVl
    cmove rbx,rcx


    lea rcx,_MovRWDVl
    cmp rax,MovRWDVl
    cmove rbx,rcx



    ;lea rcx,_SwapRR
    ;cmp rax, SwapRR
    ;cmove rbx,rcx



    
    
    jmp rbx

_MovRWDVl:
    add r14, 8                  
    dec r13
    mov rcx, r14
    call StrToInt               
    mov r15, rax

    add r14, 8                  
    dec r13
    mov rcx, r14
    call StrToInt               
    mov r11, rax                
    
    mov rax, r15
    cmp rax, 0
    je _RW_ax
    cmp rax, 1
    je _RW_cx
    cmp rax, 2
    je _RW_dx
    cmp rax, 3
    je _RW_bx
    ; Skip 4 (sp) / 5 (bp) 
    cmp rax, 6
    je _RW_si
    cmp rax, 7
    je _RW_di
    cmp rax, 8
    je _RW_r8w
    cmp rax, 9
    je _RW_r9w
    cmp rax, 10
    je _RW_r10w
    cmp rax, 11
    je _RW_r11w
    cmp rax, 12
    je _RW_r12w
    cmp rax, 13
    je _RW_r13w
    cmp rax, 14
    je _RW_r14w
    cmp rax, 15
    je _RW_r15w
    jmp _Next_Instruction

_RW_ax:
    mov ax, r11w
    jmp _Next_Instruction

_RW_cx:
    mov cx, r11w
    jmp _Next_Instruction

_RW_dx:
    mov dx, r11w
    jmp _Next_Instruction

_RW_bx:
    mov bx, r11w
    jmp _Next_Instruction

_RW_si:
    mov si, r11w
    jmp _Next_Instruction

_RW_di:
    mov di, r11w
    jmp _Next_Instruction

_RW_r8w:
    mov r8w, r11w
    jmp _Next_Instruction

_RW_r9w:
    mov r9w, r11w
    jmp _Next_Instruction

_RW_r10w:
    mov r10w, r11w
    jmp _Next_Instruction

_RW_r11w:
    mov r11w, r11w
    jmp _Next_Instruction

_RW_r12w:
    mov r12w, r11w
    jmp _Next_Instruction

_RW_r13w:
    mov r13w, r11w
    jmp _Next_Instruction

_RW_r14w:
    mov r14w, r11w
    jmp _Next_Instruction

_RW_r15w:
    mov r15w, r11w
    jmp _Next_Instruction
        
_MovRBDVl:

    add r14, 8                  
    dec r13
    mov rcx, r14
    call StrToInt               
    mov r15, rax

    add r14, 8                  
    dec r13
    mov rcx, r14
    call StrToInt               
    mov r11, rax
    
    mov rax, r15
    cmp rax, 0
    je _RB_al
    cmp rax, 1
    je _RB_cl
    cmp rax, 2
    je _RB_dl
    cmp rax, 3
    je _RB_bl
    ; Skip 4 (spl) / 5 (bpl) 
    cmp rax, 6
    je _RB_sil
    cmp rax, 7
    je _RB_dil
    cmp rax, 8
    je _RB_r8b
    cmp rax, 9
    je _RB_r9b
    cmp rax, 10
    je _RB_r10b
    cmp rax, 11
    je _RB_r11b
    cmp rax, 12
    je _RB_r12b
    cmp rax, 13
    je _RB_r13b
    cmp rax, 14
    je _RB_r14b
    cmp rax, 15
    je _RB_r15b
    jmp _Next_Instruction


_RB_al:
    mov al, r11b
    jmp _Next_Instruction

_RB_cl:
    mov cl, r11b
    jmp _Next_Instruction

_RB_dl:
    mov dl, r11b
    jmp _Next_Instruction

_RB_bl:
    mov bl, r11b
    jmp _Next_Instruction

_RB_sil:
    mov sil, r11b
    jmp _Next_Instruction

_RB_dil:
    mov dil, r11b
    jmp _Next_Instruction

_RB_r8b:
    mov r8b, r11b
    jmp _Next_Instruction

_RB_r9b:
    mov r9b, r11b
    jmp _Next_Instruction

_RB_r10b:
    mov r10b, r11b
    jmp _Next_Instruction

_RB_r11b:
    mov r11b, r11b
    jmp _Next_Instruction

_RB_r12b:
    mov r12b, r11b
    jmp _Next_Instruction

_RB_r13b:
    mov r13b, r11b
    jmp _Next_Instruction

_RB_r14b:
    mov r14b, r11b
    jmp _Next_Instruction

_RB_r15b:
    mov r15b, r11b
    jmp _Next_Instruction

_DequeNE:
     dec [Queue_len]

    jmp _Next_Instruction

_DequeE:
    dec [Queue_len]

    mov r12,[Queue_len]
    shl r12,4

    lea r15,[Queue]
    add r15,r12

    mov r14,[r15]
    mov r13,[r15+8]



    jmp _Interpret_Trench
_QueueP:

    add r14,8
    dec r13

    lea r15,Queue
    mov r12,Queue_len
    shl r12,4
    add r15,r12
    inc [Queue_len]

    mov r12,[r14]
    mov [r15],r12

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt

    mov [r15+8],rax




   jmp _Next_Instruction

_StkPopV:

    pop r15
    lea r12,VREG_BASE
    mov [r12],r15


    jmp _Next_Instruction
    
_StkPshV:

    add r14,8
    dec r13

    push [r14]


    jmp _Next_Instruction
_JneX:
    cmp qword ptr[CmpFlag],0
    jne _Next_Instruction


    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    
    cmp rax,0
    je _Pos_Jnex

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    add r13,rax
    shl rax,3
    sub r14,rax

    jmp _Interpret_Trench

_Pos_Jnex:
    
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
     
    sub r13,rax
    shl rax,3
    add r14,rax

    jmp _Interpret_Trench
_JeX:
    
    cmp qword ptr[CmpFlag],0
    je _Next_Instruction


    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    
    cmp rax,0
    je _Pos_Jex

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    add r13,rax
    shl rax,3
    sub r14,rax

    jmp _Interpret_Trench

_Pos_Jex:
    
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
     
    sub r13,rax
    shl rax,3
    add r14,rax

    jmp _Interpret_Trench

_CmpStrP:
    

    add r14,8
    dec r13

    mov rdi,[r14]


    add r14,8
    dec r13

    mov rsi,[r14]

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    mov rcx,rax


    cld 
    repe cmpsb

    cmp rcx,0
    je _Match

    mov [CmpFlag],0
    mov [CmpFlagCarry],rcx

    jmp _Next_Instruction

_Match:
    mov [CmpFlag],1
    mov [CmpFlagCarry],0
    jmp _Next_Instruction

_NotR:
    add r14, 8              
    dec r13
    mov rcx, r14
    call StrToInt          
    
    cmp rax, 0
    je _not_rax
    cmp rax, 1
    je _not_rcx
    cmp rax, 2
    je _not_rdx
    cmp rax, 3
    je _not_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _not_rsi
    cmp rax, 7
    je _not_rdi
    cmp rax, 8
    je _not_r8
    cmp rax, 9
    je _not_r9
    cmp rax, 10
    je _not_r10
    cmp rax, 11
    je _not_r11
    cmp rax, 12
    je _not_r12
    cmp rax, 13
    je _not_r13
    cmp rax, 14
    je _not_r14
    cmp rax, 15
    je _not_r15

    jmp _Next_Instruction

_not_rax:
    not rax
    jmp _Next_Instruction

_not_rcx:
    not rcx
    jmp _Next_Instruction

_not_rdx:
    not rdx
    jmp _Next_Instruction

_not_rbx:
    not rbx
    jmp _Next_Instruction

_not_rsi:
    not rsi
    jmp _Next_Instruction

_not_rdi:
    not rdi
    jmp _Next_Instruction

_not_r8:
    not r8
    jmp _Next_Instruction

_not_r9:
    not r9
    jmp _Next_Instruction

_not_r10:
    not r10
    jmp _Next_Instruction

_not_r11:
    not r11
    jmp _Next_Instruction

_not_r12:
    not r12
    jmp _Next_Instruction

_not_r13:
    not r13
    jmp _Next_Instruction

_not_r14:
    not r14
    jmp _Next_Instruction

_not_r15:
    not r15
    jmp _Next_Instruction

    
_XorR:
    add r14, 8             
    dec r13
    mov rcx, r14
    call StrToInt          
    mov r15, rax            

    add r14, 8              
    dec r13
    mov rcx, r14
    call StrToInt
    mov r11, rax           

    mov rax, r15            
    cmp rax, 0
    je _xor_rax
    cmp rax, 1
    je _xor_rcx
    cmp rax, 2
    je _xor_rdx
    cmp rax, 3
    je _xor_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _xor_rsi
    cmp rax, 7
    je _xor_rdi
    cmp rax, 8
    je _xor_r8
    cmp rax, 9
    je _xor_r9
    cmp rax, 10
    je _xor_r10
    cmp rax, 11
    je _xor_r11
    cmp rax, 12
    je _xor_r12
    cmp rax, 13
    je _xor_r13
    cmp rax, 14
    je _xor_r14
    cmp rax, 15
    je _xor_r15

    jmp _Next_Instruction
_xor_rax:
    xor rax, r11
    jmp _Next_Instruction

_xor_rcx:
    xor rcx, r11
    jmp _Next_Instruction

_xor_rdx:
    xor rdx, r11
    jmp _Next_Instruction

_xor_rbx:
    xor rbx, r11
    jmp _Next_Instruction

_xor_rsi:
    xor rsi, r11
    jmp _Next_Instruction

_xor_rdi:
    xor rdi, r11
    jmp _Next_Instruction

_xor_r8:
    xor r8, r11
    jmp _Next_Instruction

_xor_r9:
    xor r9, r11
    jmp _Next_Instruction

_xor_r10:
    xor r10, r11
    jmp _Next_Instruction

_xor_r11:
    xor r11, r11 ; The "Zero Strike"
    jmp _Next_Instruction

_xor_r12:
    xor r12, r11
    jmp _Next_Instruction

_xor_r13:
    xor r13, r11
    jmp _Next_Instruction

_xor_r14:
    xor r14, r11
    jmp _Next_Instruction

_xor_r15:
    xor r15, r11
    jmp _Next_Instruction

    
_SubR:
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt

    mov r15,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt

    mov r11,rax

    mov rax,r15

    cmp rax, 0
    je _sub_rax
    cmp rax, 1
    je _sub_rcx
    cmp rax, 2
    je _sub_rdx
    cmp rax, 3
    je _sub_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _sub_rsi
    cmp rax, 7
    je _sub_rdi
    cmp rax, 8
    je _sub_r8
    cmp rax, 9
    je _sub_r9
    cmp rax, 10
    je _sub_r10
    cmp rax, 11
    je _sub_r11
    cmp rax, 12
    je _sub_r12
    cmp rax, 13
    je _sub_r13
    cmp rax, 14
    je _sub_r14
    cmp rax, 15
    je _sub_r15

    jmp _Next_Instruction
_sub_rax:
    sub rax, r11
    jmp _Next_Instruction

_sub_rcx:
    sub rcx, r11
    jmp _Next_Instruction

_sub_rdx:
    sub rdx, r11
    jmp _Next_Instruction

_sub_rbx:
    sub rbx, r11
    jmp _Next_Instruction

_sub_rsi:
    sub rsi, r11
    jmp _Next_Instruction

_sub_rdi:
    sub rdi, r11
    jmp _Next_Instruction

_sub_r8:
    sub r8, r11
    jmp _Next_Instruction

_sub_r9:
    sub r9, r11
    jmp _Next_Instruction

_sub_r10:
    sub r10, r11
    jmp _Next_Instruction

_sub_r11:
    sub r11, r11
    jmp _Next_Instruction

_sub_r12:
    sub r12, r11
    jmp _Next_Instruction

_sub_r13:
    sub r13, r11
    jmp _Next_Instruction

_sub_r14:
    sub r14, r11
    jmp _Next_Instruction

_sub_r15:
    sub r15, r11
    jmp _Next_Instruction

_AddR:
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt

    mov r15,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt

    mov r11,rax

    mov rax,r15
    
    cmp rax, 0
    je _add_rax
    cmp rax, 1
    je _add_rcx
    cmp rax, 2
    je _add_rdx
    cmp rax, 3
    je _add_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _add_rsi
    cmp rax, 7
    je _add_rdi
    cmp rax, 8
    je _add_r8
    cmp rax, 9
    je _add_r9
    cmp rax, 10
    je _add_r10
    cmp rax, 11
    je _add_r11
    cmp rax, 12
    je _add_r12
    cmp rax, 13
    je _add_r13
    cmp rax, 14
    je _add_r14
    cmp rax, 15
    je _add_r15

    jmp _Next_Instruction

_add_rax:
    add rax, r11
    jmp _Next_Instruction

_add_rcx:
    add rcx, r11
    jmp _Next_Instruction

_add_rdx:
    add rdx, r11
    jmp _Next_Instruction

_add_rbx:
    add rbx, r11
    jmp _Next_Instruction

_add_rsi:
    add rsi, r11
    jmp _Next_Instruction

_add_rdi:
    add rdi, r11
    jmp _Next_Instruction

_add_r8:
    add r8, r11
    jmp _Next_Instruction

_add_r9:
    add r9, r11
    jmp _Next_Instruction

_add_r10:
    add r10, r11
    jmp _Next_Instruction

_add_r11:
    add r11, r11
    jmp _Next_Instruction

_add_r12:
    add r12, r11
    jmp _Next_Instruction

_add_r13:
    add r13, r11
    jmp _Next_Instruction

_add_r14:
    add r14, r11
    jmp _Next_Instruction

_add_r15:
    add r15, r11
    jmp _Next_Instruction

_OrR:
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r15,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r11,rax

    mov rax,r15
    cmp rax, 0
    je _or_rax
    cmp rax, 1
    je _or_rcx
    cmp rax, 2
    je _or_rdx
    cmp rax, 3
    je _or_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _or_rsi
    cmp rax, 7
    je _or_rdi
    cmp rax, 8
    je _or_r8
    cmp rax, 9
    je _or_r9
    cmp rax, 10
    je _or_r10
    cmp rax, 11
    je _or_r11
    cmp rax, 12
    je _or_r12
    cmp rax, 13
    je _or_r13
    cmp rax, 14
    je _or_r14
    cmp rax, 15
    je _or_r15

    jmp _Next_Instruction


_or_rax:
    or rax, r11
    jmp _Next_Instruction

_or_rcx:
    or rcx, r11
    jmp _Next_Instruction

_or_rdx:
    or rdx, r11
    jmp _Next_Instruction

_or_rbx:
    or rbx, r11
    jmp _Next_Instruction

_or_rsi:
    or rsi, r11
    jmp _Next_Instruction

_or_rdi:
    or rdi, r11
    jmp _Next_Instruction

_or_r8:
    or r8, r11
    jmp _Next_Instruction

_or_r9:
    or r9, r11
    jmp _Next_Instruction

_or_r10:
    or r10, r11
    jmp _Next_Instruction

_or_r11:
    or r11, r11      ; Self-OR
    jmp _Next_Instruction

_or_r12:
    or r12, r11
    jmp _Next_Instruction

_or_r13:
    or r13, r11
    jmp _Next_Instruction

_or_r14:
    or r14, r11
    jmp _Next_Instruction

_or_r15:
    or r15, r11
    jmp _Next_Instruction

_AndR:
    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r15,rax

    add r14,8
    dec r13
    mov rcx,r14
    call StrToInt
    mov r11,rax

    mov rax, r15          
    cmp rax, 0
    je _and_rax
    cmp rax, 1
    je _and_rcx
    cmp rax, 2
    je _and_rdx
    cmp rax, 3
    je _and_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _and_rsi
    cmp rax, 7
    je _and_rdi
    cmp rax, 8
    je _and_r8
    cmp rax, 9
    je _and_r9
    cmp rax, 10
    je _and_r10
    cmp rax, 11
    je _and_r11
    cmp rax, 12
    je _and_r12
    cmp rax, 13
    je _and_r13
    cmp rax, 14
    je _and_r14
    cmp rax, 15
    je _and_r15

    jmp _Next_Instruction
_and_rax:
    and rax, r11
    jmp _Next_Instruction

_and_rcx:
    and rcx, r11
    jmp _Next_Instruction

_and_rdx:
    and rdx, r11
    jmp _Next_Instruction

_and_rbx:
    and rbx, r11
    jmp _Next_Instruction

_and_rsi:
    and rsi, r11
    jmp _Next_Instruction

_and_rdi:
    and rdi, r11
    jmp _Next_Instruction

_and_r8:
    and r8, r11
    jmp _Next_Instruction

_and_r9:
    and r9, r11
    jmp _Next_Instruction

_and_r10:
    and r10, r11
    jmp _Next_Instruction

_and_r11:
    and r11, r11      ; Self-mask
    jmp _Next_Instruction

_and_r12:
    and r12, r11
    jmp _Next_Instruction

_and_r13:
    and r13, r11
    jmp _Next_Instruction

_and_r14:
    and r14, r11
    jmp _Next_Instruction

_and_r15:
    and r15, r11
    jmp _Next_Instruction
_DecR:
    add r14,8
    dec r13
    mov rcx,r14

    call StrToInt
    
    cmp rax, 0
    je _dec_rax
    cmp rax, 1
    je _dec_rcx
    cmp rax, 2
    je _dec_rdx
    cmp rax, 3
    je _dec_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _dec_rsi
    cmp rax, 7
    je _dec_rdi
    cmp rax, 8
    je _dec_r8
    cmp rax, 9
    je _dec_r9
    cmp rax, 10
    je _dec_r10
    cmp rax, 11
    je _dec_r11
    cmp rax, 12
    je _dec_r12
    cmp rax, 13
    je _dec_r13
    cmp rax, 14
    je _dec_r14
    cmp rax, 15
    je _dec_r15

    jmp _Next_Instruction



_dec_rax:
    dec rax
    jmp _Next_Instruction

_dec_rcx:
    dec rcx
    jmp _Next_Instruction

_dec_rdx:
    dec rdx
    jmp _Next_Instruction

_dec_rbx:
    dec rbx
    jmp _Next_Instruction

_dec_rsi:
    dec rsi
    jmp _Next_Instruction

_dec_rdi:
    dec rdi
    jmp _Next_Instruction

_dec_r8:
    dec r8
    jmp _Next_Instruction

_dec_r9:
    dec r9
    jmp _Next_Instruction

_dec_r10:
    dec r10
    jmp _Next_Instruction

_dec_r11:
    dec r11
    jmp _Next_Instruction

_dec_r12:
    dec r12
    jmp _Next_Instruction

_dec_r13:
    dec r13
    jmp _Next_Instruction

_dec_r14:
    dec r14
    jmp _Next_Instruction

_dec_r15:
    dec r15
    jmp _Next_Instruction

_IncR:
    
    add r14,8
    dec r13
    mov rcx,r14

    call StrToInt


    cmp rax, 0
    je _inc_rax
    cmp rax, 1
    je _inc_rcx
    cmp rax, 2
    je _inc_rdx
    cmp rax, 3
    je _inc_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _inc_rsi
    cmp rax, 7
    je _inc_rdi
    cmp rax, 8
    je _inc_r8
    cmp rax, 9
    je _inc_r9
    cmp rax, 10
    je _inc_r10
    cmp rax, 11
    je _inc_r11
    cmp rax, 12
    je _inc_r12
    cmp rax, 13
    je _inc_r13
    cmp rax, 14
    je _inc_r14
    cmp rax, 15
    je _inc_r15

    jmp _Next_Instruction

_inc_rax:
    inc rax
    jmp _Next_Instruction

_inc_rcx:
    inc rcx
    jmp _Next_Instruction

_inc_rdx:
    inc rdx
    jmp _Next_Instruction

_inc_rbx:
    inc rbx
    jmp _Next_Instruction

_inc_rsi:
    inc rsi
    jmp _Next_Instruction

_inc_rdi:
    inc rdi
    jmp _Next_Instruction

_inc_r8:
    inc r8
    jmp _Next_Instruction

_inc_r9:
    inc r9
    jmp _Next_Instruction

_inc_r10:
    inc r10
    jmp _Next_Instruction

_inc_r11:
    inc r11
    jmp _Next_Instruction

_inc_r12:
    inc r12
    jmp _Next_Instruction

_inc_r13:
    inc r13
    jmp _Next_Instruction

_inc_r14:
    inc r14
    jmp _Next_Instruction

_inc_r15:
    inc r15
    jmp _Next_Instruction


_MemCpyM:
    ;flag 
    ; src
    ;dest
    ; c
    

    
   



    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    cmp rax,0 
    je _VMEM


     add r14,8
    dec r13

    mov rsi,[r14]


    add r14,8
    dec r13

    mov rdi,[r14]

     add r14,8
    dec r13

    mov rcx, r14
    call StrToInt

    mov rcx,rax


    cld
    rep  movsq


    

    jmp _Next_Instruction






_VMEM:
    add r14,8
    dec r13

    lea rsi,VMEM
    mov rcx,r14
    call StrToInt
    add rsi,rax


    add r14,8
    dec r13

    lea rdi,VMEM
    mov rcx,r14
    call StrToInt
    add rdi,rax

     add r14,8
    dec r13

    mov rcx, r14
    call StrToInt

    mov rcx,rax


    cld
    rep  movsq

    


    jmp _Next_Instruction

_MemFillM:
    ;size into VMEM
    ; qword to int
    ; count
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    shl rax,3
    lea rdi,VMEM
    add rdi,rax

    add r14,8
    dec r13

    mov rcx, r14
    call StrToInt

    mov r12,rax

    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt

    mov rdx,r12
    mov rcx,rax


_MemFill_Loop:
    mov [rdi], rdx          
    add rdi, 8              
    loop _MemFill_Loop      



    
    
    jmp _Next_Instruction


_ShlRR:
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    mov r15,rax

    add r14,8
    dec r13
    mov rcx,StrToInt
    mov r11,rax

    mov rax,r15

    cmp rax, 0
    je _shr_rax
    cmp rax, 1
    je _shr_rcx
    cmp rax, 2
    je _shr_rdx
    cmp rax, 3
    je _shr_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _shr_rsi
    cmp rax, 7
    je _shr_rdi
    cmp rax, 8
    je _shr_r8
    cmp rax, 9
    je _shr_r9
    cmp rax, 10
    je _shr_r10
    cmp rax, 11
    je _shr_r11
    cmp rax, 12
    je _shr_r12
    cmp rax, 13
    je _shr_r13
    cmp rax, 14
    je _shr_r14
    cmp rax, 15
    je _shr_r15

    jmp _Next_Instruction
    
    
    jmp _Next_Instruction

_shr_rax:
    mov rcx, r11
    shr rax, cl
    jmp _Next_Instruction

_shr_rcx:
    mov rax, rcx
    mov rcx, r11
    shr rax, cl
    mov rcx, rax
    jmp _Next_Instruction

_shr_rdx:
    mov rcx, r11
    shr rdx, cl
    jmp _Next_Instruction

_shr_rbx:
    mov rcx, r11
    shr rbx, cl
    jmp _Next_Instruction

_shr_rsi:
    mov rcx, r11
    shr rsi, cl
    jmp _Next_Instruction

_shr_rdi:
    mov rcx, r11
    shr rdi, cl
    jmp _Next_Instruction

_shr_r8:
    mov rcx, r11
    shr r8, cl
    jmp _Next_Instruction

_shr_r9:
    mov rcx, r11
    shr r9, cl
    jmp _Next_Instruction

_shr_r10:
    mov rcx, r11
    shr r10, cl
    jmp _Next_Instruction

_shr_r11:
    mov rax, r11
    mov rcx, r11
    shr rax, cl
    mov r11, rax
    jmp _Next_Instruction

_shr_r12:
    mov rcx, r11
    shr r12, cl
    jmp _Next_Instruction

_shr_r13:
    mov rcx, r11
    shr r13, cl
    jmp _Next_Instruction

_shr_r14:
    mov rcx, r11
    shr r14, cl
    jmp _Next_Instruction

_shr_r15:
    mov rcx, r11
    shr r15, cl
    jmp _Next_Instruction

_ShlLR:
    add r14,8
    dec r13

    mov rcx,r14
    call StrToInt
    mov r15,rax

    add r14,8
    dec r13
    mov rcx,StrToInt
    mov r11,rax

    mov rax,r15

    cmp rax, 0
    je _shl_rax
    cmp rax, 1
    je _shl_rcx
    cmp rax, 2
    je _shl_rdx
    cmp rax, 3
    je _shl_rbx
    ; 4 & 5 Protected (Stack)
    cmp rax, 6
    je _shl_rsi
    cmp rax, 7
    je _shl_rdi
    cmp rax, 8
    je _shl_r8
    cmp rax, 9
    je _shl_r9
    cmp rax, 10
    je _shl_r10
    cmp rax, 11
    je _shl_r11
    cmp rax, 12
    je _shl_r12
    cmp rax, 13
    je _shl_r13
    cmp rax, 14
    je _shl_r14
    cmp rax, 15
    je _shl_r15

    jmp _Next_Instruction

_shl_rax:
    mov rcx, r11
    shl rax, cl
    jmp _Next_Instruction

_shl_rcx:
    mov rax, rcx            ; Swap to rax to avoid cl collision
    mov rcx, r11
    shl rax, cl
    mov rcx, rax            ; Move result back
    jmp _Next_Instruction

_shl_rdx:
    mov rcx, r11
    shl rdx, cl
    jmp _Next_Instruction

_shl_rbx:
    mov rcx, r11
    shl rbx, cl
    jmp _Next_Instruction

_shl_rsi:
    mov rcx, r11
    shl rsi, cl
    jmp _Next_Instruction

_shl_rdi:
    mov rcx, r11
    shl rdi, cl
    jmp _Next_Instruction

_shl_r8:
    mov rcx, r11
    shl r8, cl              ; Shifting the VMEM Base
    jmp _Next_Instruction

_shl_r9:
    mov rcx, r11
    shl r9, cl              ; Shifting the Stride
    jmp _Next_Instruction

_shl_r10:
    mov rcx, r11
    shl r10, cl
    jmp _Next_Instruction

_shl_r11:
    mov rax, r11            ; Self-collision protection
    mov rcx, r11
    shl rax, cl
    mov r11, rax
    jmp _Next_Instruction

_shl_r12:
    mov rcx, r11
    shl r12, cl
    jmp _Next_Instruction

_shl_r13:
    mov rcx, r11
    shl r13, cl
    jmp _Next_Instruction

_shl_r14:
    mov rcx, r11
    shl r14, cl
    jmp _Next_Instruction

_shl_r15:
    mov rcx, r11
    shl r15, cl
    jmp _Next_Instruction

_SwapRR:
    
    
    add r14,8
    dec r13
   
   
   mov rcx,r14
   
   
   call StrToInt
   
   mov r15,rax

   add r14,8
   dec r13
 
  mov rcx,r14
  call StrToInt
   mov r11,rax

   
   cmp r11,r15
   je _Next_Instruction


   mov rax,r15

    cmp rax, 0
    je _swap_rax
    cmp rax, 1
    je _swap_rcx
    cmp rax, 2
    je _swap_rdx
    cmp rax, 3
    je _swap_rbx
    ; 4 & 5 are Protected (The Stack)
    cmp rax, 6
    je _swap_rsi
    cmp rax, 7
    je _swap_rdi
    cmp rax, 8
    je _swap_r8
    cmp rax, 9
    je _swap_r9
    cmp rax, 10
    je _swap_r10
    cmp rax, 11
    je _swap_r11
    cmp rax, 12
    je _swap_r12
    cmp rax, 13
    je _swap_r13
    cmp rax, 14
    je _swap_r14
    cmp rax, 15
    je _swap_r15

    jmp _Next_Instruction


_swap_rax:
    xchg rax, r11           ; Atomically swap with the source
    jmp _Next_Instruction

_swap_rcx:
    xchg rcx, r11
    jmp _Next_Instruction

_swap_rdx:
    xchg rdx, r11
    jmp _Next_Instruction

_swap_rbx:
    xchg rbx, r11
    jmp _Next_Instruction

_swap_rsi:
    xchg rsi, r11
    jmp _Next_Instruction

_swap_rdi:
    xchg rdi, r11
    jmp _Next_Instruction

_swap_r8:
    xchg r8, r11            ; Swap with VMEM Base Ptr (Deadly Control!)
    jmp _Next_Instruction

_swap_r9:
    xchg r9, r11            ; Swap with 8-byte Stride
    jmp _Next_Instruction

_swap_r10:
    xchg r10, r11
    jmp _Next_Instruction

_swap_r11:
    xchg r11, r11           ; Redundant but maintains the stride
    jmp _Next_Instruction

_swap_r12:
    xchg r12, r11
    jmp _Next_Instruction

_swap_r13:
    xchg r13, r11           ; Swap with Loop Counter
    jmp _Next_Instruction

_swap_r14:
    xchg r14, r11           ; Swap with Ptr Tracker
    jmp _Next_Instruction

_swap_r15:
    xchg r15, r11
    jmp _Next_Instruction

_MovRPVl:
    add r14,8
    dec r13
   
   
   mov rcx,r14
   
   
   call StrToInt
   
   mov r15,rax

   add r14,8
   dec r13
 

   mov r11,r14
   
   
   mov rax,r15
   cmp rax, 0
    je _Rax
    cmp rax, 1
    je _Rcx
    cmp rax, 2
    je _Rdx
    cmp rax, 3
    je _Rbx
    ; Skip 4 and 5 if you want to protect  RSP/RBP ie stack
    cmp rax, 6
    je _Rsi
    cmp rax, 7
    je _Rdi
    cmp rax, 8
    je _R8
    cmp rax, 9
    je _R9
    cmp rax, 10
    je _R10
    cmp rax, 11
    je _R11
    cmp rax, 12
    je _R12
    cmp rax, 13
    je _R13
    cmp rax, 14
    je _R14
    cmp rax, 15
    je _R15

    jmp _Next_Instruction
    
_MovRSVL:
    add r14,8
    dec r13
   
   
   mov rcx,r14
   
   
   call StrToInt
   
   mov r15,rax

   add r14,8
   dec r13
 

   mov r11,[r14]
   
   
   mov rax,r15
   cmp rax, 0
    je _Rax
    cmp rax, 1
    je _Rcx
    cmp rax, 2
    je _Rdx
    cmp rax, 3
    je _Rbx
    ; Skip 4 and 5 if you want to protect  RSP/RBP ie stack
    cmp rax, 6
    je _Rsi
    cmp rax, 7
    je _Rdi
    cmp rax, 8
    je _R8
    cmp rax, 9
    je _R9
    cmp rax, 10
    je _R10
    cmp rax, 11
    je _R11
    cmp rax, 12
    je _R12
    cmp rax, 13
    je _R13
    cmp rax, 14
    je _R14
    cmp rax, 15
    je _R15

    jmp _Next_Instruction
    
_MovRDVl:

    add r14,8
    dec r13
   
   
   mov rcx,r14
   
   
   call StrToInt
   
   mov r15,rax

   add r14,8
   dec r13
   mov rcx, r14
   call StrToInt

   mov r11,rax
   
   
   mov rax,r15
   cmp rax, 0
    je _Rax
    cmp rax, 1
    je _Rcx
    cmp rax, 2
    je _Rdx
    cmp rax, 3
    je _Rbx
    ; Skip 4 and 5 if you want to protect  RSP/RBP ie stack
    cmp rax, 6
    je _Rsi
    cmp rax, 7
    je _Rdi
    cmp rax, 8
    je _R8
    cmp rax, 9
    je _R9
    cmp rax, 10
    je _R10
    cmp rax, 11
    je _R11
    cmp rax, 12
    je _R12
    cmp rax, 13
    je _R13
    cmp rax, 14
    je _R14
    cmp rax, 15
    je _R15
    
    jmp _Next_Instruction

_Rax:
    mov rax, r11           
    jmp _Next_Instruction

_Rcx:
    mov rcx, r11
    jmp _Next_Instruction

_Rdx:
    mov rdx, r11
    jmp _Next_Instruction

_Rbx:
    mov rbx, r11
    jmp _Next_Instruction

_Rsi:
    mov rsi, r11
    jmp _Next_Instruction

_Rdi:
    mov rdi, r11
    jmp _Next_Instruction

_R8:
    mov r8, r11             ; VMEM Base Ptr
    jmp _Next_Instruction

_R9:
    mov r9, r11             ; 8-byte Stride
    jmp _Next_Instruction

_R10:
    mov r10, r11
    jmp _Next_Instruction

_R11:
    mov r11, r11            ; Self-load
    jmp _Next_Instruction

_R12:
    mov r12, r11
    jmp _Next_Instruction

_R13:
    mov r13, r11            ; Loop Counter
    jmp _Next_Instruction

_R14:
    mov r14, r11            ; Ptr Tracker
    jmp _Next_Instruction

_R15:
    mov r15, r11
    jmp _Next_Instruction

_LayParsP:
    ;ptr
    ;ptr mem
    
    add r14,8
    dec r13

    mov r15,[r14]

    add r14,8
    dec r13


    mov r12,[r14]
    

    push r13

    mov rcx,r12
    mov rdx,r15

    call LayoutParser

    pop r13

    jmp _Next_Instruction



    
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

    cmp [Queue_len],0
    je _Exit

    dec [Queue_len]

    lea r12,Queue
    mov r11,Queue_len
    shl r11,4
    add r12,r11

    mov r14,[r12]
    mov r13,[r12+8]
    
    jmp _Interpret_Trench

_Exit:
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



