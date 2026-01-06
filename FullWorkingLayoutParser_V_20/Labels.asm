include constants.inc

extern CreateWindowExA:proc
extern Color32:proc
extern SetTextColor:proc
extern SetBkMode:proc
extern GetStockObject:proc




public MainLabelptr
.data
szStaticClass db "STATIC", 0
szLabelText   db "Filename: test.txt", 0  ; Main Label Text
MainLabelptr dq 0

.code


MainLabel proc
;rcx hWnd ptr
;rdx hInstance


mov r15,rcx
mov r14,rdx

sub rsp,60h


mov rcx,0
lea rdx,szStaticClass
lea r8,szLabelText
mov r9,50000001h ; WS_CHILD | WS_VISIBLE | SS_CENTER
mov qword ptr[rsp+20h],10
mov qword ptr[rsp+28h],10
mov qword ptr[rsp+30h],400
mov qword ptr[rsp+38h],25  ; ie pos
mov qword ptr[rsp+40h],r15 
mov qword ptr[rsp+48h],101
mov qword ptr[rsp+50h],r14
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,60h

mov MainLabelptr, rax

ret
MainLabel endp




CreateLabelEdit proc
;rbx id
;rdx type static/edit
;r8 Text
;r9 type
;r10 x
;r11 y
;r12 width
;r13 height
;r14 hWnd ptr
;r15 hInstance

;rcx hWnd ptr
;rdx hInstance




sub rsp,68h


mov rcx,0
mov qword ptr[rsp+20h],r10
mov qword ptr[rsp+28h],r11
mov qword ptr[rsp+30h],r12
mov qword ptr[rsp+38h],r13 ; ie pos
mov qword ptr[rsp+40h],r14 
mov qword ptr[rsp+48h],rbx
mov qword ptr[rsp+50h],r15
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,68h





ret
CreateLabelEdit endp



ModifyCreateLabelEdit proc

    ;r14 hdc  control handle
    ;r8d r9d and r10d bgr not rgb
    ;r15 bk mode
    

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
end



