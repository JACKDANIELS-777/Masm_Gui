include constants.inc

public MainEditptr
.data
szEditClass db "EDIT", 0
szLabelText   db " ", 0  ; Main Label Text.
MainEditptr dq 0


extern CreateWindowExA:proc

.code
MainEdit proc

;rcx hWnd ptr
;rdx hInstance


mov r15,rcx
mov r14,rdx

sub rsp,60h


mov rcx,0
lea rdx,szEditClass
mov r8,0

mov r9,WS_CHILD
or r9, WS_VISIBLE
or r9,WS_VSCROLL
or r9,ES_MULTILINE
or r9,ES_AUTOVSCROLL
or r9,ES_NOHIDESEL

mov qword ptr[rsp+20h],0
mov qword ptr[rsp+28h],30
mov qword ptr[rsp+30h],400
mov qword ptr[rsp+38h],300  ; ie pos
mov qword ptr[rsp+40h],r15 
mov qword ptr[rsp+48h],102
mov qword ptr[rsp+50h],r14	
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,60h

mov MainEditptr, rax

ret


MainEdit endp
end




CreateGeneralEdit proc
;r8 handle to the condrol Hdc device context




ret
CreateGeneralEdit endp
