;Keep in mind this is very badly written besides the obvious fact that we are making numerous calls to SetPixel.
;Secondly this assumes that your hdc ie BeginPaint return value in rax has been stored in the r14 register
    mov r8d, 255   
    mov r9d,0
    mov r10d,0
    call Color32
    mov r12,rax

    mov r13,150
    _loop:
    
    sub rsp,28h
    mov rcx,r14
    mov rdx,r13
    mov r8,10
    mov r9,r12
    call SetPixel
    add rsp,28h
    add r13,1
    
    cmp r13,400
    jl _loop
    mov r13,10
    _part2:
    sub rsp,28h
    mov rcx,r14
    mov rdx,400
    mov r8,r13
    mov r9,r12
    call SetPixel
    add rsp,28h
    add r13,1
    
    cmp r13,250
    jl _part2

    mov r13,400
    _part3:
    sub rsp,28h
    mov rcx,r14
    mov rdx,r13
    mov r8,250
    mov r9,r12
    call SetPixel
    add rsp,28h
    dec r13
    
    cmp r13,150
    jg _part3

    mov r13,250
    _part4:
    sub rsp,28h
    mov rcx,r14
    mov rdx,150
    mov r8,r13
    mov r9,r12
    call SetPixel
    add rsp,28h
    dec r13
    
    cmp r13,10
    jg _part4
