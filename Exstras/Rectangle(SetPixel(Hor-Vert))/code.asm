;This is an imporvement on the Rectangle(SetPixel(Bad))/code.asm
;Don't use SetPixel it is very slow other functions as in MoveToEx and LineTo if not Rect will do the job much better,faster and effienctly
;As before r14 holds our hdc from BeginPaint return value
mov r8d, 255   
    mov r9d,0
    mov r10d,0
    call Color32
    mov r12,rax

    mov r13,150
    _LoopHorizontal:
    
    sub rsp,28h
    mov rcx,r14
    mov rdx,r13
    mov r8,10
    mov r9,r12
    call SetPixel
    add rsp,28h

    sub rsp,28h
    mov rcx,r14
    mov rdx,r13
    mov r8,250
    mov r9,r12
    call SetPixel
    add rsp,28h


    add r13,1
    


    cmp r13,400
    jl _LoopHorizontal
    mov r13,10


    _LoopVertical:

    sub rsp,28h
    mov rcx,r14
    mov rdx,400
    mov r8,r13
    mov r9,r12
    call SetPixel
    add rsp,28h

    sub rsp,28h
    mov rcx,r14
    mov rdx,150
    mov r8,r13
    mov r9,r12
    call SetPixel
    add rsp,28h

    add r13,1
    
    cmp r13,250
    jl _LoopVertical
