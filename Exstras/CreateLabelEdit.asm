include constants.inc

extern CreateWindowExA:proc

.data


.code

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

sub rsp,60h


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
add rsp,60h

ret  ;returns the handle or 0
CreateLabelEdit endp
end

