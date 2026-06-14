;For now its being ported so no win api functions are commented out in the current version
; =========================================================================================
; Module Name:  MainApp.asm - Boilerplate Engine Core (Ported to NASM x86_64)
; Assemble:     nasm -f win64 MainApp.asm -o MainApp.o
; =========================================================================================

default rel

; NASM uses %include instead of include
%include "./constants.inc"

; --- Win32 Message Constant Equates for NASM ---
%define WM_CREATE           0x0001
%define WM_DESTROY          0x0002
%define WM_MOUSEMOVE        0x0200
%define WM_COMMAND          0x0111
%define WM_MEASUREITEM      0x002C
%define WM_DRAWITEM         0x002D
%define WM_CTLCOLORSTATIC   0x0138
%define WM_CTLCOLOREDIT     0x0133

; --- External Win32 API & Global Data Definitions ---
extern LoadCursorA
extern ShowWindow
extern UpdateWindow
extern PeekMessageA
extern RegisterClassA
extern CreateWindowExA
extern GetMessageA
extern TranslateMessage
extern DispatchMessageA
extern DefWindowProcA
extern PostQuitMessage
extern CreateMenu
extern SetMenu
extern AppendMenuA
extern MessageBoxA
extern DestroyWindow
extern FillRect
extern CreateSolidBrush
extern SetBkMode
extern SetTextColor
extern SetBkColor
extern Rectangle
extern GetClientRect
extern BeginPaint
extern EndPaint
extern SetPixel
extern GetWindowTextA
extern MoveToEx
extern LineTo
extern CreatePen
extern SelectObject
extern GetLastError
extern CreateFontA
extern GetStockObject
extern IsDialogMessage
extern ThreadPtr
extern PostMessageA
extern SendMessageA
extern InitDevice
extern Render
extern ExitProcess
extern DeleteObject
extern VirtualProtect

; --- Commented out missing engine files for testing ---
; extern TrenchScriptProc
; extern RanTrench
; extern MainLabel
; extern MainEdit
; extern CreateLabelEdit
; extern ModifyCreateLabelEdit
; extern AddMenus
; extern CreateMenusString
; extern LayoutParser
; extern MainLabelptr
; extern MainEditptr
; extern AttrDataBuffer
; extern DelayedBuffer

; --- Global Exports ---
global main                     ; Changed entry point to match VS project settings
global WindowProc
global Color32
global hwndMain

; --- NASM %macro Translation ---
%macro RGB 3
    ((%3 << 16) | (%2 << 8) | %1)
%endmacro

section .data
    MsgTitle    db "My ASM Window", 0  
    MsgText     db "Hello from pure MASM!", 0
    ClassName   db "A", 0
    wnd_Title   db "Excel External Window id 0", 0
    textExit    db "Exit", 0
    out_string  db "Jack", 0
    font_Arial  db "Arial", 0
    txtStatic   db "txtStatic", 0
    Text        db "Ok", 0
    g_bRunning  db 1
    DelayedExe  db 0

    hwndMain    dq 0
    hBrush      dq 0
    hOldPen     dq 0
    hRedPen     dq 0
    hOldFont    dq 0
    hNewFont    dq 0
    hMyFont     dq 0
    Okptr       dq 0

    Mem_String  db "Z,1002,100,50,1000,100,{f:10,b:10,}Aqb,\c", 0

    ; --- Stride and Script Processing Blocks (Left intact, but loop execution skipped) ---
    align 8
    SecondScript:
        db "Cls     "
        db "WarpS   "
        dq -1

    align 8
    TrenchScriptStr:
        db "SwapStr "      
        dq SecondScript
        db "2       "
        dq -1
        db "ChngCom "
        db "Cls     "
        db "Clear   "
        db "ChngCom "
        db "Clear   "
        db "C       "
        db "C       "
        db 0
        db "Proc    "
        db "Super   "
        db "A       "
        db "Super   "
        db "Super   "
        db "EndP    "
        db "CallP   "
        db "Super   "
        db "Cls     "
        db 0 
        db "RandV   "
        db "0       "
        db "0       "
        db "100     "
        db "SetV    "
        db "0       "
        db "0       "
        db "SetV    "
        db "1       "
        db "100     "
        db "PrintV  "
        db "0       "
        db "DrawVL  "
        db "0       "
        db "0       "
        db "1       "
        db "1       "
        db "AddDV   "
        db "1       "
        db "100     "
        db "Sleep   "
        db "1000    "
        db "CmpSV   "
        db "1       "
        db "1000    "
        db "2       "
        db "JumpB   "
        db "16      "
        db 0           

section .bss
    wc:             resb 72
    msg:            resb 72
    ps:             resb 72
    textBuffer:     resb 256
    menuTextBuffer: resb 100
    Mem:            resb 100
    Mem1:           resb 100
    Mem2:           resb 1000

section .text

; =========================================================================================
; Color32 Procedure
; =========================================================================================
Color32:
    xor eax, eax
    mov al, r8b 
    shl eax, 8
    mov al, r9b  
    shl eax, 8 
    mov al, r10b
    ret

; =========================================================================================
; WindowProc Procedure
; =========================================================================================
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
    ; Commented layout parsing tracking
    ; cmp byte [DelayedExe], 1
    ; je _donemsg
    ; lea rcx, [Mem1]
    ; lea rdx, [DelayedBuffer]
    ; call LayoutParser
    ; cld                     
    ; lea rdi, [Mem1]           
    ; xor rax, rax            
    ; mov rcx, 125            
    ; rep stosq
_donemsg:
    mov byte [DelayedExe], 1
    add rsp, 0xF0
    ret

_MouseMove:
    sub rsp, 0x28
    mov rcx, r15
    mov rdx, 100000
    mov r8, 0
    mov r9, 0
    call PostMessageA
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
    ; cmp r9, [MainLabelptr]  ; Commented due to missing external variable
    ; je _Edit_MainLabel
    jmp _exit_txtStatic

_Edit_MainLabel:
    ; mov r14, r8
    ; mov r8d, 100
    ; mov r9d, 100
    ; mov r10d, 100
    ; mov r15, 1
    ; call ModifyCreateLabelEdit
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
    ; Commented out layout/parsing triggers for isolation
    ; lea rcx, [Mem1]
    ; mov rdx, 0
    ; call LayoutParser 
    ; cld                     
    ; lea rdi, [Mem1]           
    ; xor rax, rax            
    ; mov rcx, 125            
    ; rep stosq
    ; mov byte [RanTrench], 1
    add rsp, 0xF0
    ret

_Destroy:
    sub rsp, 0x28
    xor ecx, ecx
    call PostQuitMessage
    add rsp, 0x28
    mov byte [g_bRunning], 0
    xor eax, eax
    add rsp, 0xF0
    ret

HandleDefault:
    sub rsp, 0x28
    call DefWindowProcA
    add rsp, 0x28
    add rsp, 0xF0
    ret

; =========================================================================================
; Entry Point: main Procedure (Renamed from WinMain to align with Linker properties)
; =========================================================================================
main:
    mov r15, rcx

    mov qword [wc+48], 6

    sub rsp, 0x20
    mov rcx, 0
    mov rdx, 32512
    call LoadCursorA
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
    call CreateSolidBrush
    add rsp, 0x28

    mov qword [wc+48], rax

    sub rsp, 0x28
    lea rcx, [wc]
    call RegisterClassA
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

    call CreateWindowExA        
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
    call PeekMessageA
    add rsp, 0x28

    cmp byte [g_bRunning], 0
    je _Exit

    test rax, rax
    jz _render_now

    sub rsp, 0x28
    lea rcx, [msg]
    call TranslateMessage
    lea rcx, [msg]
    call DispatchMessageA
    add rsp, 0x28

_render_now:
    ; Commented out bytecode stride script loop callback for now
    ; lea rcx, [TrenchScriptStr]
    ; call TrenchScriptProc
    jmp _loop

_Exit:
    xor ecx, ecx      
    call ExitProcess  
    xor eax, eax
    ret
