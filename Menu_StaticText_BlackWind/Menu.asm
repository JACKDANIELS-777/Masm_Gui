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


.data
Hmenu dq 0
Sub_Menu dq 0
Sub_Sub_Menu dq 0
mi db 40 dup (0)
file db "file",0
new_str db "new",0
exit_str db "exit",0
help_str db "help",0
lbr db 16 dup(0)
Hbrush dq 0



.code 
AddMenus proc

;rcx hWnd



mov r15,rcx
sub rsp, 20h
mov rcx, r15
xor rdx, rdx
xor r8, r8
call SetWindowTheme
add rsp, 20h




;;CREATE Main Menu
sub rsp,28h

call CreateMenu
add rsp,28h

mov Hmenu,rax

;Create Secondary Menus File and New inside file as a popup
;;;;;;;;;;;;;;;;;;;;;;;;
sub rsp,28h

call CreateMenu
add rsp,28h
mov Sub_Menu, rax


;;;CREATE SUB SUB MENU
sub rsp,28h

call CreateMenu
add rsp,28h
mov Sub_Sub_Menu, rax

;Append New Menu
;;;;;;;;;;;;;;;;;;;;;;;;

sub rsp,20h
mov rcx, Sub_Menu
mov rdx,MF_POPUP
mov r8,Sub_Sub_Menu ;ID
lea r9,new_str


call AppendMenuA
add rsp,20h



;;;APPEND SUB SUB MENU
sub rsp,20h
mov rcx, Sub_Sub_Menu
mov rdx,MF_STRING
mov r8,1 ;ID
lea r9,new_str


call AppendMenuA
add rsp,20h

;;APPEND SEPERATOR
sub rsp,20h
mov rcx, Sub_Menu
mov rdx,MF_SEPERATOR
mov r8,0 ;ID NUll
mov r9,0


call AppendMenuA
add rsp,20h


;;;;;;;;;APPEND EXIT
sub rsp,20h
mov rcx, Sub_Menu
mov rdx,0
mov r8,2 ;ID
lea r9,exit_str


call AppendMenuA
add rsp,20h



;Append File Menu
;;;;;;;;;;;;;;;;;;;;;;;;
sub rsp,20h
mov rcx, Hmenu
mov rdx,MF_POPUP
mov r8,Sub_Menu ;ID
lea r9,file


call AppendMenuA
add rsp,20h


;;APPEND MENUBREAK
sub rsp,20h
mov rcx, Hmenu
mov rdx,MF_BITMAP
mov r8,0 ;ID
lea r9,help_str
add rsp,20h

;;;;;APPEND HELP MENU
sub rsp,20h
mov rcx, Hmenu
mov rdx,MF_STRING
mov r8,3 ;ID
lea r9,help_str


call AppendMenuA
add rsp,20h

;sub rsp,20h
;mov rcx,r15
;call GetMenu
;add rsp,20h

;mov r14,rax

;Set Main Window
;;;;;;;;;;;;;;;;;;;;;;;;
sub rsp,28h
mov rcx,r15
mov rdx,Hmenu


call SetMenu
add rsp,28h





ret
AddMenus endp



end
