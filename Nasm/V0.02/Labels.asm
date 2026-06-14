; =========================================================================================
; Module Name:  WindowManager.asm - Strict 1:1 Port to NASM x86_64
; Assemble:     nasm -f win64 WindowManager.asm -o WindowManager.obj
; =========================================================================================

default rel

%include "./constants.inc"

; --- External Symbol Linkage Maps ---
extern CreateWindowExA
extern Color32
extern SetTextColor
extern SetBkMode
extern GetStockObject
extern GetCurrentThreadId
extern AttachThreadInput
extern GetWindowThreadProcessId
extern InvalidateRect
extern UpdateWindow
extern ShowWindow
extern SendMessageA
extern RedrawWindow
extern GetLastError

extern ThreadPtr
extern ThreadData
extern hwndMain

; --- Global Exports ---
global MainLabelptr
global MainLabel
global CreateLabelEdit
global CreateLabelEditThread
global ModifyCreateLabelEdit

section .data
    szStaticClass db "STATIC", 0
    szLabelText   db "Filename: test.txt", 0  ; Main Label Text
    
    global MainLabelptr
    MainLabelptr  dq 0

section .text

; =========================================================================================
; MainLabel Procedure
; =========================================================================================
MainLabel:
    ; rcx hWnd ptr
    ; rdx hInstance

    mov r15, rcx
    mov r14, rdx

    sub rsp, 0x60

    mov rcx, 0
    lea rdx, [szStaticClass]
    lea r8, [szLabelText]
    mov r9, 0x50000001              ; WS_CHILD | WS_VISIBLE | SS_CENTER
    
    mov qword [rsp+0x20], 10
    mov qword [rsp+0x28], 10
    mov qword [rsp+0x30], 400
    mov qword [rsp+0x38], 25        ; ie pos
    mov qword [rsp+0x40], r15
    mov qword [rsp+0x48], 101
    mov qword [rsp+0x50], r14
    mov qword [rsp+0x58], 0

    call CreateWindowExA
    add rsp, 0x60

    mov [MainLabelptr], rax

    ret

; =========================================================================================
; CreateLabelEdit Procedure
; =========================================================================================
CreateLabelEdit:
    ; rbx id
    ; rdx type static/edit
    ; r8 Text
    ; r9 type
    ; r10 x
    ; r11 y
    ; r12 width
    ; r13 height
    ; r14 hWnd ptr
    ; r15 hInstance

    ; rcx hWnd ptr
    ; rdx hInstance

    sub rsp, 0x68

    mov rcx, 0
    mov qword [rsp+0x20], r10
    mov qword [rsp+0x28], r11
    mov qword [rsp+0x30], r12
    mov qword [rsp+0x38], r13       ; ie pos
    mov qword [rsp+0x40], r14 
    mov qword [rsp+0x48], rbx
    mov qword [rsp+0x50], r15
    mov qword [rsp+0x58], 0

    call CreateWindowExA
    add rsp, 0x68   

    call GetLastError
    nop

    ret

; =========================================================================================
; CreateLabelEditThread Procedure
; =========================================================================================
CreateLabelEditThread:
_loop:
    pause
    cmp byte [ThreadPtr], 0
    je _loop

    sub rsp, 0x68

    mov rcx, qword [ThreadData]
    mov rcx, 0

    mov rdx, qword [ThreadData+8]
    mov r8, qword [ThreadData+16]
    mov r9, qword [ThreadData+24]

    mov rax, qword [ThreadData+32]
    mov qword [rsp+0x20], rax       ; r10

    mov rax, qword [ThreadData+40]
    mov qword [rsp+0x28], rax       ; r11

    mov rax, qword [ThreadData+48]
    mov qword [rsp+0x30], rax       ; r12

    mov rax, qword [ThreadData+56]
    mov qword [rsp+0x38], rax       ; r13

    mov rax, qword [ThreadData+64]
    mov qword [rsp+0x40], rax       ; r14

    mov rax, qword [ThreadData+72]
    mov qword [rsp+0x48], rax

    mov qword [rsp+0x58], 0
    call CreateWindowExA
    add rsp, 0x68

    lock dec byte [ThreadPtr]

    jmp _loop

    ; rbx id
    ; rdx type static/edit
    ; r8 Text
    ; r9 type
    ; r10 x
    ; r11 y
    ; r12 width
    ; r13 height
    ; r14 hWnd ptr
    ; r15 hInstance

    ; rcx hWnd ptr
    ; rdx hInstance

    sub rsp, 0x68

    mov rcx, 0
    mov qword [rsp+0x20], r10
    mov qword [rsp+0x28], r11
    mov qword [rsp+0x30], r12
    mov qword [rsp+0x38], r13       ; ie pos
    mov qword [rsp+0x40], r14 
    mov qword [rsp+0x48], rbx
    mov qword [rsp+0x50], r15
    mov qword [rsp+0x58], 0

    call CreateWindowExA
    add rsp, 0x68

    ret

; =========================================================================================
; ModifyCreateLabelEdit Procedure
; =========================================================================================
ModifyCreateLabelEdit:
    ; r14 hdc  control handle
    ; r8d r9d and r10d bgr not rgb
    ; r15 bk mode

    sub rsp, 0x20
    call Color32
    mov r13, rax

    mov rcx, r14
    mov rdx, r13
    call SetTextColor
    add rsp, 0x20

    sub rsp, 0x20
    mov rcx, r14
    mov rdx, r15
    call SetBkMode
    add rsp, 0x20
    
    sub rsp, 0x20
    mov rcx, 5                      ; NULL_BRUSH constant value = 5
    call GetStockObject
    add rsp, 0x20
    
    ret
