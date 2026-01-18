include constants.inc
includelib Msimg32.lib

extern AlphaBlend:proc
extern GradientFill:proc
extern GetLastError:proc
extern CreateWindowExA:proc
extern DefWindowProcA:proc
extern GetSystemMetrics:proc
extern SetLayeredWindowAttributes:proc
extern ShowWindow:proc
extern SetWindowLongPtrA:proc

.data
WC db 80 dup(0)
MainClassName db "Window Manager",0
Button db "Button",0

MainHandle dq 0
.data?
ScreenHeight dd ?
ScreenWidth dd ?

.code

MainWndProc proc


cmp rdx,2
je _Exit

sub rsp, 28h
    call DefWindowProcA
    add rsp, 28h
    ret
_Exit:
    xor rcx, rcx
    call PostQuitMessage
    xor rax, rax
    ret






MainWndProc endp



CreateMainWnd proc

sub rsp,28h
mov rcx,0
call GetSystemMetrics
mov dword ptr[ScreenWidth],eax

mov rcx,1

call GetSystemMetrics
mov dword ptr[ScreenHeight],eax
add rsp,28h

sub rsp,60h


;HWND_TOPMOST add it

mov rcx,80000h
mov rcx,0
lea rdx,MainClassName
;lea r8,MainClassName
mov r8,0
mov r9,10CF0000h 
mov r9,80000000h
mov r9,90000000h
mov r9,92000000h ;;Vsisble
mov qword ptr[rsp+20h],0
mov qword ptr[rsp+28h],0
mov eax, dword ptr[ScreenWidth]
add rax,100
mov qword ptr[rsp+30h],rax
mov eax, dword ptr[ScreenHeight]
add rax,100
mov qword ptr[rsp+38h],rax  ; ie pos
mov qword ptr[rsp+40h],0
mov qword ptr[rsp+48h],0
mov qword ptr[rsp+50h],0 ;r15
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,60h



mov qword ptr[MainHandle],rax

sub rsp,28h
mov rcx, rax           ; Your Ghost Manager
mov rdx, -20                ; GWL_EXSTYLE index
mov r8, 00000080h           ; WS_EX_TOOLWINDOW
call SetWindowLongPtrA      ; Force it to be a ToolWindow late

add rsp,28h

sub rsp,68h




mov rax, MainHandle


mov rcx,0
lea rdx,Button
lea r8,Button
mov r9,50000000h
mov qword ptr[rsp+20h],10
mov qword ptr[rsp+28h],10
mov qword ptr[rsp+30h],100
mov qword ptr[rsp+38h],100  ; ie pos
mov qword ptr[rsp+40h],rax
mov qword ptr[rsp+48h],0
mov qword ptr[rsp+50h],0
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,68h



;sub rsp,28h
;mov rcx, MainHandle           ; The Parent Manager
;mov rdx, 0                 ; crKey (Transparency Color)
;mov r8,0                  ; bAlpha (1 out of 255 - Effectively Invisible)
;mov r9, 2                   ; LWA_ALPHA flag
;call SetLayeredWindowAttributes
;add rsp,28h





ret
CreateMainWnd endp


RegisterMainWnd proc


    push r15
    sub rsp, 30h            ; Extra space for safety and alignment

    xor rcx, rcx
    call GetModuleHandleA 
    mov r15, rax          

    
    mov dword ptr [WC], 80          
    mov dword ptr [WC + 4], 3       
    
    lea rcx, MainWndProc
    mov qword ptr [WC + 8], rcx     
    
    mov dword ptr [WC + 16], 0     
    mov dword ptr [WC + 20], 256    
    
    mov qword ptr [WC + 24], r15    
    
   
    mov qword ptr [WC + 32], 0      
    mov qword ptr [WC + 40], 0      
    mov qword ptr [WC + 48], 0      
    mov qword ptr [WC + 56], 0      
    
    

    lea rcx, MainClassName
    mov qword ptr [WC + 64], rcx    
    
  
    mov qword ptr [WC + 72], 0

    lea rcx, WC
    call RegisterClassExA           

    add rsp, 30h
    pop r15
ret
RegisterMainWnd endp

end
