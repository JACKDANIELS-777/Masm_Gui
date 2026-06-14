; =========================================================================================
; Module Name:  main.asm - Decoupled Engine Core with Conditional Platform Compilation
; Assemble:     nasm -f win64 main.asm -o main.obj
; =========================================================================================

default rel

%include "./constants.inc"

; --- Win32 Message Constant Equates for NASM ---
;%define WM_CREATE           0x0001
%define WM_DESTROY          0x0002
%define WM_MOUSEMOVE        0x0200
%define WM_COMMAND          0x0111
%define WM_MEASUREITEM      0x002C
%define WM_DRAWITEM         0x002D
%define WM_CTLCOLORSTATIC   0x0138
%define WM_CTLCOLOREDIT     0x0133

; --- Conditional Platform Linkage Mapping ---
; Defining WINDOWS_BUILD isolates the OS dependencies cleanly without an extra file.
%define WINDOWS_BUILD 1

%ifdef WINDOWS_BUILD
    extern LoadCursorA
    extern RegisterClassA
    extern CreateWindowExA
    extern PeekMessageA
    extern TranslateMessage
    extern DispatchMessageA
    extern DefWindowProcA
    extern PostQuitMessage
    extern CreateSolidBrush
    extern PostMessageA
    extern ExitProcess
    extern LayoutParser
%endif

; --- Global Exports ---
global main
global WindowProc
global Color32
global hwndMain
global RegisterEdit    
global EditClassName   

section .data
    ClassName   db "A", 0
    wnd_Title   db "Excel External Window id 0", 0
    txtStatic   db "txtStatic", 0
    Text        db "Ok", 0
    g_bRunning  db 1
    DelayedExe  db 0

    hwndMain    dq 0
    hBrush      dq 0
    Okptr       dq 0
    Mem_String  db "B,101,100,50,10,100,{f:10,b:10,}Aqb,\cB,1002,100,50,1000,100,{f:10,b:10,}Aqb,\c", 0
    
    Mem1 times 100 db (0)
    EditClassName db "EDIT", 0
    global g_hInstance
g_hInstance dq 0

section .bss
    wc:             resb 72
    msg:            resb 72

section .text

; =========================================================================================
; Pure Core Engine Routines (Platform-Independent Engine Logic)
; =========================================================================================
Color32:
    xor eax, eax
    mov al, r8b 
    shl eax, 8
    mov al, r9b  
    shl eax, 8 
    mov al, r10b
    ret

WindowProc:
    sub rsp, 0xF0 
    mov r15, rcx 
    mov [hwndMain], rcx

    lea rbx, [HandleDefault]

    lea rax, [_CTCOLORSTATIC]
    cmp edx, WM_CTLCOLORSTATIC
    cmove rbx, rax

    lea rax, [_CTLCOLOREDIT]
    cmp edx, WM_CTLCOLOREDIT
    cmove rbx, rax

    lea rax, [_Measure]
    cmp edx, WM_MEASUREITEM
    cmove rbx, rax

    lea rax, [_Draw]
    cmp edx, WM_DRAWITEM
    cmove rbx, rax
    
    lea rax, [_Command]
    cmp edx, WM_COMMAND
    cmove rbx, rax

    lea rax, [_Create]
    cmp edx, WM_CREATE
    cmove rbx, rax

    lea rax, [_Destroy]
    cmp edx, WM_DESTROY
    cmove rbx, rax

    lea rax, [_MouseMove]
    cmp edx, WM_MOUSEMOVE
    cmove rbx, rax

    lea rax, [_CustomMsg]
    cmp edx, 100000
    cmove rbx, rax

    jmp rbx

_WM_NCCALCSIZE:
    cmp r8, 0
    jne HandleDefault
    xor rax, rax
    add rsp, 0xF0
    ret

_CustomMsg:
_donemsg:
    mov byte [DelayedExe], 1
    add rsp, 0xF0
    ret

_MouseMove:
    sub rsp, 0x28
    mov rcx, r15
    mov rdx, 100000
    xor r8, r8
    xor r9, r9
    %ifdef WINDOWS_BUILD
        call PostMessageA
    %endif
    add rsp, 0x28
    add rsp, 0xF0
    ret

_DoPaint:
    xor rax, rax
    add rsp, 0xF0
    ret

_ERASEBKGND:
    xor rax, rax
    add rsp, 0xF0
    ret

_CTLCOLOREDIT:
    add rsp, 0xF0
    ret

_exit_edit:
    add rsp, 0xF0
    ret

_CTCOLORSTATIC:
    mov r14, r8  
    jmp _exit_txtStatic

_Edit_MainLabel:
    add rsp, 0xF0
    ret

_exit_txtStatic:
    add rsp, 0xF0
    ret
            
_Draw:
    add rsp, 0xF0
    ret

_Measure:
    add rsp, 0xF0
    ret

_Command:
    cmp r8, 3
    je _cmd3
    jmp _cmd_exit

_cmd3:
    jmp _Destroy

_cmd_exit:
    add rsp, 0xF0
    ret

_Create:
    lea rcx, [Mem1]    
    mov rdx,0
    ;lea rdx, [Mem_String]    
    call LayoutParser
    add rsp, 0xF0
    ret

_Destroy:
    sub rsp, 0x28
    xor ecx, ecx
    %ifdef WINDOWS_BUILD
        call PostQuitMessage
    %endif
    add rsp, 0x28
    mov byte [g_bRunning], 0
    xor eax, eax
    add rsp, 0xF0
    ret

HandleDefault:
    sub rsp, 0x28
    %ifdef WINDOWS_BUILD
        call DefWindowProcA
    %endif
    add rsp, 0x28
    add rsp, 0xF0
    ret

; =========================================================================================
; Platform Main Instantiation Layer
; =========================================================================================
main:
    mov r15, rcx
    mov [g_hInstance], rcx 
    mov qword [wc+48], 6

    sub rsp, 0x20
    mov rcx, 0
    mov rdx, 32512
    %ifdef WINDOWS_BUILD
        call LoadCursorA
    %endif
    add rsp, 0x20

    mov qword [wc+40], rax
    mov qword [wc+24], r15
    lea rcx, [ClassName]
    mov qword [wc+64], rcx
    lea rcx, [WindowProc]
    mov qword [wc+8], rcx

    sub rsp, 0x28
    mov r8b, 30
    mov r9b, 30
    mov r10b, 30
    call Color32
    mov rcx, rax
    %ifdef WINDOWS_BUILD
        call CreateSolidBrush
    %endif
    add rsp, 0x28

    mov qword [wc+48], rax

    sub rsp, 0x28
    lea rcx, [wc]
    %ifdef WINDOWS_BUILD
        call RegisterClassA
    %endif
    add rsp, 0x28

    sub rsp, 0x88 

    xor rcx, rcx                
    lea rdx, [ClassName]        
    lea r8, [wnd_Title]         
    mov r9, 0x10CF0000          

    mov qword [rsp+0x20], 100   
    mov qword [rsp+0x28], 100   
    mov qword [rsp+0x30], 500   
    mov qword [rsp+0x38], 500   
    mov qword [rsp+0x40], 0     
    mov qword [rsp+0x48], 0     
    mov qword [rsp+0x50], r15   
    mov qword [rsp+0x58], 0     

    %ifdef WINDOWS_BUILD
        call CreateWindowExA        
    %endif
    mov r14, 0
    mov r15, rax
    add rsp, 0x88

_loop:
    sub rsp, 0x28
    lea rcx, [msg]
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    mov qword [rsp+0x20], 1
    %ifdef WINDOWS_BUILD
        call PeekMessageA
    %endif
    add rsp, 0x28

    cmp byte [g_bRunning], 0
    je _Exit

    test rax, rax
    jz _render_now

    sub rsp, 0x28
    lea rcx, [msg]
    %ifdef WINDOWS_BUILD
        call TranslateMessage
        lea rcx, [msg]
        call DispatchMessageA
    %endif
    add rsp, 0x28

_render_now:
    jmp _loop

_Exit:
    xor ecx, ecx      
    %ifdef WINDOWS_BUILD
        call ExitProcess  
    %endif
    xor eax, eax
    ret


global RegisterEdit
RegisterEdit:
    xor eax, eax
    ret
