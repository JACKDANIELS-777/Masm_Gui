include constants.inc

extern CreateMenu :proc
extern SetMenu :proc
extern AppendMenuA:proc
extern SetMenuItemInfoA :proc
extern SetMenuInfo :proc
extern GetMenu :proc
extern CreateBrushIndirect:proc
extern GetLastError:proc
extern SetWindowTheme:proc
extern DrawMenuBar:proc
extern Color32:proc
extern CreateSolidBrush:proc


.data

l db "h",0


.code 

AddMenus proc




;;CREATE Main Menu
sub rsp,20h
call CreateMenu
add rsp,20h
mov r15,rax


sub rsp,20h
mov rcx,rax
mov rdx,MF_STRING
mov r8,1
lea r9,l

call AppendMenuA
add rsp,20h


sub rsp,20h
mov rcx,r14
mov rdx,r15
call SetMenu
add rsp,20h



;mov r14,rax


ret
AddMenus endp



CreateMenusString proc
;rcx ptr memory 
;rdx the string

mov r12,rcx
mov r14,rdx

;;CREATE Main Menu
sub rsp,20h
call CreateMenu
add rsp,20h
mov r15,rax


mov r13,0
mov rbx,0; ie cmnds

sub rsp,100h

_loop:
	mov al, byte ptr[r14]
	
	cmp al,0
	je _exit
	
	cmp al, "\"
	je _add_menu
	mov byte ptr[r12],al
	add r12,1
	add r13,1

	jmp _continue
_add_menu:
	add r14,1
	mov al, byte ptr[r14]
	cmp al,"c"
	jne _continue 

	mov byte ptr[r12],0
	add r12,1
	add r13,1
	sub r12,r13
	

	sub rsp,20h
	mov rcx,r15
	mov rdx,MF_STRING
	mov r8,rbx
	lea r9,qword ptr[r12]

	call AppendMenuA
	add rsp,20h

	add r14,1
	add r12,r13
	mov r13,0
	add rbx,1
	
	jmp _loop

_continue:
	add r14,1
	jmp _loop


_exit:
add rsp,100h
mov rax,r15
	ret
CreateMenusString endp
end



