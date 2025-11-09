

include constants.inc
extern CreateWindowExA:proc
extern GetLastError:proc

.data
static db "static",0
Dummy_Text db "Dummy_Text",0
edit db "edit",0




.code


AddControls proc
;rcx contains parent

mov r15,rcx

sub rsp,80h

mov rcx,0
lea rdx,static
lea r8, Dummy_Text
mov r9,WS_VISIBLE
or r9,WS_CHILD
mov qword ptr[rsp+20h],200
mov qword ptr[rsp+28h],100
mov qword ptr[rsp+30h],100
mov qword ptr[rsp+38h],50
mov qword ptr[rsp+40h],r15
mov qword ptr[rsp+48h],0
mov qword ptr[rsp+50h],0
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,80h
call GetLastError
ret
AddControls endp

end
