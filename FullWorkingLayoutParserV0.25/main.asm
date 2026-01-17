;@Ah=0  ; tell VS this is ASCII, not Unicode
include constants.inc

includelib msvcrt.lib
includelib UxTheme.lib
includelib ucrt.lib
includelib Comctl32.lib
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
extern DestroyWindow:proc
extern FillRect :proc
extern CreateSolidBrush :proc
extern SetBkMode :proc
extern SetTextColor :proc
extern SetBkColor :proc
extern Rectangle :proc
extern GetClientRect :proc
extern BeginPaint :proc
extern EndPaint :proc
extern SetPixel :proc
extern GetWindowTextA:proc
extern MoveToEx:proc
extern LineTo:proc
extern CreatePen:proc
extern SelectObject:proc
extern GetLastError:proc
extern CreateFontA:proc
extern GetStockObject:proc
extern IsDialogMessage:proc
extern ThreadPtr:byte
extern PostMessageA:proc
extern SendMessageA:proc



;;

extern GetMenuStringA:proc
extern TextOutA:proc

extern DeleteObject:proc



;external assemblies
extern MainLabel:proc
extern MainEdit:proc
extern CreateLabelEdit:proc
extern ModifyCreateLabelEdit:proc
extern AddMenus:proc
extern CreateMenusString:proc
extern LayoutParser:proc

extern MainLabelptr:qword
extern MainEditptr:qword
;extern AttrDataBuffer : qword
extern VirtualProtect : proc
extern AttrDataBuffer : byte
extern DelayedBuffer:byte








RGB MACRO r,g,b
    ((b << 16) or (g << 8) or r)
ENDM
.data
MsgTitle  db "My ASM Window", 0  ; Null-terminated string
MsgText   db "Hello from pure MASM!", 0
ClassName db "A",0
wnd_Title db "Excel External Window id 0",0
wc db 72 dup (0)
msg db 72 dup (0)
public hwndMain
hwndMain dq 0
hBrush dq 0
textBuffer db 256 dup(0)
menuTextBuffer db 100 dup(0)
textExit db "Exit",0
ps db 72 dup (0)
hOldPen dq 0
hRedPen dq 0
hOldFont dq 0
hNewFont dq 0
out_string db "Jack",0
hMyFont dq 0
font_Arial db "Arial",0
Static db "STATIC",0
Text db "Ok",0
Okptr dq 0


Mem db 100 dup (0)

Mem_String db "Z,1002,100,50,1000,100,{f:10,b:10,}Aqb,\c",0

Mem1 db 1000 dup (0)
Mem2 db 1000 dup (0)
DelayedExe db 0

.data?

.code

Color32 proc


xor eax,eax
mov al,r8b ;r
shl  eax,8
mov al,r9b  ;g
shl eax,8 
mov al,r10b
ret
Color32 endp


WindowProc proc
    LOCAL msg_Title[100]:BYTE 
    LOCAL msg_Body[100]:BYTE 
    
    mov r15,rcx ;ie hWnd
    mov hwndMain,rcx


    ;cmp edx, WM_NCCALCSIZE
    ;je _WM_NCCALCSIZE

    ;cmp edx,WM_PAINT
    ;je _DoPaint

    cmp edx,WM_CTLCOLORSTATIC
    je _CTCOLORSTATIC
    cmp edx,WM_CTLCOLOREDIT
    je _CTLCOLOREDIT

    ;cmp edx,WM_ERASEBKGND
    ;je _ERASEBKGND

    cmp edx,WM_MEASUREITEM
    je _Measure
    cmp edx,WM_DRAWITEM
    je _Draw
    cmp edx,WM_COMMAND
    je _Command
    cmp edx, WM_CREATE
    je  _Create
    cmp edx, WM_DESTROY
    je  _Destroy

   
    cmp edx,WM_MOUSEMOVE
    je _MouseMove

    cmp edx,100000
    je _CustomMsg
    jmp HandleDefault

    


_WM_NCCALCSIZE:
cmp r8,0
jne HandleDefault

xor rax, rax


ret

_CustomMsg:
    
    cmp byte ptr[DelayedExe],1
    je _donemsg

    lea rcx,Mem1
    lea  rdx,  DelayedBuffer
   
    call LayoutParser
    cld                     ; Clear Direction Flag (ensure we move forward)
    lea rdi, Mem1           ; Point RDI to the start of the 1000-byte buffer
    xor rax, rax            ; The value to write (0)
    mov rcx, 125            ; 1000 bytes / 8 bytes per quadword = 125 iterations
    rep stosq
    
    _donemsg:
    mov byte ptr[DelayedExe],1
    
    ret
_MouseMove:
    sub rsp,28h
    mov rcx,r15
    mov rdx,100000
    mov r8,0
    mov r9,0
    call PostMessageA
    add rsp,28h
    

    
    ret
_DoPaint:
    
    mov rax,0
    ret
_ERASEBKGND:

    


mov rax,0
ret

_CTLCOLOREDIT:

    
    ret

    _exit_edit:
        ret
_CTCOLORSTATIC:
    ;r9 has rhe HWND and r9 HDC
    mov r14,r8  ;save the register
    ;r15 is used elsewhere
    cmp r9,MainLabelptr
    je _Edit_MainLabel
    jmp _exit_static

   
    _Edit_MainLabel:
    mov r14,r8
    mov r8d,100
    mov r9d,100
    mov r10d,100
    mov r15,1
    

    call ModifyCreateLabelEdit

    ret
   
    sub rsp,20h
    mov r8d, 255
    mov r9d, 10
    mov r10d, 255
    call Color32
    mov r15,rax


    mov rcx,r14
    mov rdx,r15
    call SetTextColor

    add rsp,20h



    sub rsp,20h
    mov rcx,r14
    mov rdx,1
    call SetBKMode

    add rsp,20h
    
    sub rsp,20h
    mov rcx,NULL_BRUSH ;ie null
    call GetStockObject

    add rsp,20h
    ;return (LRESULT)GetStockObject(NULL_BRUSH);
    ret


    ret

    _exit_static:
    ;return DefWindowProc(hWnd, uMsg, wParam, lParam);
        ret
            
_Draw:
    
    ret

_Measure:
   
    ret
_Command:
    cmp r8,3
    je _cmd3
    jmp _exit

    _cmd3:
    jmp  _Destroy
    jmp _exit
    _exit:
    ret
_Create:



lea rcx,Mem1
mov rdx,0

call LayoutParser 
cld                     ; Clear Direction Flag (ensure we move forward)
    lea rdi, Mem1           ; Point RDI to the start of the 1000-byte buffer
    xor rax, rax            ; The value to write (0)
    mov rcx, 125            ; 1000 bytes / 8 bytes per quadword = 125 iterations
    rep stosq



            ; Don't let the parser move yet!

ret
lea rcx, Mem
lea rdx, Mem_String
call CreateMenusString

sub rsp,20h
mov rcx,hwndMain
mov rdx,rax
call SetMenu
add rsp,20h



ret
mov r14,hwndMain
    call AddMenus
    mov rcx,hwndMain
    mov rdx,0
    call MainLabel

    mov rcx,hwndMain
    mov rdx,0
    ;call MainEdit

    mov rbx,103
    lea rdx,Static
    lea r8,Text
    mov r9,50000001h
    mov r10,50
    mov r11,50
    mov r12,50
    mov r13,50
    mov r14,hwndMain
    mov r15,hwndMain
    call CreateLabelEdit
    mov Okptr, rax 

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
mov r8b,30
    mov r9b,30
    mov r10b,30
    call Color32
    mov rcx,rax
    
  
    call CreateSolidBrush
    add rsp,28h

mov qword ptr[wc+48],rax




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
mov r15,rax
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

;mov rcx,r15
;lea rdx,msg
;sub rsp,28h
;call IsDialogMessage
;add rsp,28h
;test rax, rax
;jnz _loop

sub rsp,28h
lea rcx,msg
call TranslateMessage
lea rcx,msg
call DispatchMessageA
add rsp,28h
jmp _loop


_Exit:
mov rax,0
ret
WinMain endp







end
