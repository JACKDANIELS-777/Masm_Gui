;@Ah=0  ; tell VS this is ASCII, not Unicode
includelib msvcrt.lib
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

; 2. FOR THE LINKER (tells LINK where to find the function code)
includelib kernel32.lib  ; For ExitProcess, GetModuleHandle, etc.
includelib user32.lib    ; For MessageBox, CreateWindow, etc.
;
includelib gdi32.lib      ; For grap


extern LoadCursorA:proc
extern RegisterClassA:proc
extern CreateWindowExA:proc
extern GetMessageA:proc
extern TranslateMessage:proc
extern DispatchMessageA:proc
extern DefWindowProcA:proc
extern PostQuitMessage:proc
extern DefWindowProcA :proc
extern CreateMenu :proc
extern SetMenu :proc
extern AppendMenuA:proc
extern MessageBoxA:proc

.data
MsgTitle  db "My ASM Window", 0  ; Null-terminated string
MsgText   db "Hello from pure MASM!", 0
ClassName db "A",0
wnd_Title db "Hello",0
wc db 72 dup (0)
msg db 72 dup (0)
Hmenu dq 0
file db "file",0

WM_CREATE       equ 0001h
WM_DESTROY      equ 0002h
WM_PAINT        equ 000Fh
WM_CLOSE        equ 0010h
WM_QUIT         equ 0012h
WM_KEYDOWN      equ 0100h
WM_COMMAND equ 0111h
WM_LBUTTONDOWN  equ 0201h
WM_MOUSEMOVE    =  200h


.code


AddMenus proc

;rcx hWnd
mov r15,rcx
sub rsp,28h

call CreateMenu
add rsp,28h

mov Hmenu,rax

sub rsp,20h
mov rcx, Hmenu
mov rdx,0
mov r8,1 ;ID
lea r9,file

call AppendMenuA
add rsp,20h


sub rsp,28h
mov rcx,r15
mov rdx,Hmenu

call SetMenu
add rsp,28h

ret
AddMenus endp






WindowProc proc
    LOCAL msg_Title[100]:BYTE 
    LOCAL msg_Body[100]:BYTE 
    
    cmp edx,WM_COMMAND
    je _Command
    cmp edx, WM_CREATE
    je  _Create
    cmp edx, WM_DESTROY
    je  _Destroy
    jmp HandleDefault


_Command:
    ;check r8
    cmp r8,1
    je _1


    _1:
    lea rcx, msg_Title
    mov byte ptr [rcx+00], 'C'
    mov byte ptr [rcx+01], 'R'
    mov byte ptr [rcx+02], 'E'
    mov byte ptr [rcx+03], 'A'
    mov byte ptr [rcx+04], 'T'
    mov byte ptr [rcx+05], 'E'
    mov byte ptr [rcx+06], 'D'
    mov byte ptr [rcx+07], ' '
    mov byte ptr [rcx+08], 'B'
    mov byte ptr [rcx+09], 'Y'
    mov byte ptr [rcx+10], ':'
    mov byte ptr [rcx+15], 0
    
    lea rcx, msg_Body
    mov byte ptr [rcx+00], 'J'
    mov byte ptr [rcx+01], 'A'
    mov byte ptr [rcx+02], 'C'
    mov byte ptr [rcx+03], 'K'
    mov byte ptr [rcx+04], 'D'
    mov byte ptr [rcx+05], 'A'
    mov byte ptr [rcx+06], 'N'
    mov byte ptr [rcx+07], 'I'
    mov byte ptr [rcx+08], 'E'
    mov byte ptr [rcx+09], 'L'
    mov byte ptr [rcx+10], 'S'
    mov byte ptr [rcx+11], '-'
    mov byte ptr [rcx+12], '7'
    mov byte ptr [rcx+13], '7'
    mov byte ptr [rcx+14], '7'
    mov byte ptr [rcx+15], 0
    
    sub rsp,20h
    mov rcx,0
    lea rdx,msg_Body
    lea r8,msg_Title
    mov r9,1
    call MessageBoxA
    add rsp,20h
    ret

    
    ret
_Create:
    call AddMenus
    xor eax, eax
    ret

_Destroy:
    sub rsp, 28h
    xor ecx, ecx
    call PostQuitMessage
    add rsp, 28h
    xor eax, eax
    ret

HandleDefault:
    sub rsp, 28h
    call DefWindowProcA
    add rsp, 28h
    ret
WindowProc endp


WinMain proc
mov r15,rcx


mov qword ptr [wc+48], 6

sub rsp,20h
mov rcx,0
mov rdx, 32512
call LoadCursorA
add rsp,20h

mov qword ptr [wc+40], rax
mov qword ptr[wc+24],r15
lea rcx,ClassName
mov qword ptr[wc+64],rcx
lea rcx,WindowProc
mov qword ptr[wc+8],rcx


sub rsp,28h
lea rcx,wc
call RegisterClassA
add rsp,28h


sub rsp, 88h                ; Reserve 96 bytes (8 params + 4 shadow)

xor rcx, rcx                ; 1. dwExStyle <-- THIS IS THE FIX (set to 0)
lea rdx, ClassName          ; 2. lpClassName
lea r8, wnd_Title           ; 3. lpWindowName
mov r9, 10CF0000h          ; 4. dwStyle (WS_OVERLAPPEDWINDOW | WS_VISIBLE)
mov qword ptr [rsp+20h], 100 ; 5. X
mov qword ptr [rsp+28h], 100 ; 6. Y
mov qword ptr [rsp+30h], 500 ; 7. nWidth
mov qword ptr [rsp+38h], 500 ; 8. nHeight
mov qword ptr [rsp+40h], 0   ; 9. hWndParent
mov qword ptr [rsp+48h], 0   ; 10. hMenu
mov qword ptr [rsp+50h], r15 ; 11. hInstance (!!!)
mov qword ptr [rsp+58h], 0   ; 12. lpParam

call CreateWindowExA        ; <-- Call the 'Ex' version
mov r14,0
add rsp, 88h


_loop:

sub rsp,20h
lea rcx,msg
mov rdx,0
mov r8,0
mov r9,0
call GetMessageA
add rsp,20h

cmp rax,0
je _Exit
sub rsp,20h
lea rcx,msg
call TranslateMessage
lea rcx,msg
call DispatchMessageA
add rsp,20h
jmp _loop


_Exit:
mov rax,0
ret
WinMain endp





end
