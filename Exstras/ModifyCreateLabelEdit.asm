include constants.inc

Color32 proc


xor eax,eax
mov al,r8b ;r
shl  eax,8
mov al,r9b  ;g
shl eax,8 
mov al,r10b
ret
Color32 endp ;Highly advised to put this in a general file and just extern Color32:proc



ModifyCreateLabelEdit proc

    ;r14 hdc  control handle
    ;r15 bk mode 1 or 2
    ;r8d r9d and r10d bgr not rgb
    
    

    sub rsp,20h
    call Color32
    mov r13,rax


    mov rcx,r14
    mov rdx,r13
    call SetTextColor

    add rsp,20h


 
    sub rsp,20h
    mov rcx,r14
    mov rdx,r15
    call SetBKMode

    add rsp,20h
    
    sub rsp,20h
    mov rcx,NULL_BRUSH ;ie null ie number 5
    call GetStockObject

    add rsp,20h
    
    ret

ModifyCreateLabelEdit endp

ModifyCreateLabelEdit endp
