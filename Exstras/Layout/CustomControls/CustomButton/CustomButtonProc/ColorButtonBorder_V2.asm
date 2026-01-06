; =========================================================================================
; MASM_GUI V0.20 - High-Performance Border Rendering Engine
; Feature: RIP-Relative Jump Table Dispatcher & O(1) Speed Color Selection
;  ColorButtonBorder_V2
; =========================================================================================

include CustomButtonConstants.inc

extern FrameRect:proc
extern CreateSolidBrush:proc
extern Color32:proc
extern DeleteObject:proc

.code

; --- Jump Table: Points to the procedures below ---
; align 8 ensures the CPU reads these addresses at maximum speed
align 8
ColorJumpTable QWORD default_color ; 0
               QWORD red           ; 1
               QWORD green         ; 2
               QWORD blue          ; 3
               QWORD white         ; 4
               QWORD yellow        ; 5
               QWORD magenta       ; 6
               QWORD cyan          ; 7
               QWORD gray          ; 8
               QWORD darkgray      ; 9
               QWORD orange        ; 10
               QWORD navy          ; 11
               QWORD lime          ; 12
               QWORD purple        ; 13
               QWORD skyblue       ; 14
               QWORD gold          ; 15
               QWORD silver        ; 16
               QWORD pink          ; 17
               QWORD crimson       ; 18
               QWORD teal          ; 19
               QWORD forestgreen   ; 20
               QWORD violet        ; 21
               QWORD chocolate     ; 22
               QWORD hotpink       ; 23
               QWORD emerald       ; 24
               QWORD royalblue     ; 25

MaxColorID EQU 25

; -----------------------------------------------------------------------------------------
; ColorBtnBorder: Main Dispatcher
; -----------------------------------------------------------------------------------------
ColorBtnBorder proc
    sub rsp, 28h
    cmp rcx, MaxColorID
    ja default_color

    ; RIP-Relative addressing to bypass ADDR32 relocation errors
    lea r11, [ColorJumpTable]              
    jmp qword ptr [r11 + rcx * 8]          
ColorBtnBorder endp

; -----------------------------------------------------------------------------------------
; Color Procedures (BGR Logic)
; -----------------------------------------------------------------------------------------

default_color proc
    mov r8d, 0
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
default_color endp

red proc
    mov r8d, 0
    mov r9d, 0
    mov r10d, 100
    call Color32
    mov rcx, rax
    jmp exit_paint
red endp

green proc
    mov r8d, 0
    mov r9d, 100
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
green endp

blue proc
    mov r8d, 100
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
blue endp

white proc
    mov r8d, 255
    mov r9d, 255
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
white endp

yellow proc
    mov r8d, 0
    mov r9d, 255
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
yellow endp

magenta proc
    mov r8d, 255
    mov r9d, 0
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
magenta endp

cyan proc
    mov r8d, 255
    mov r9d, 255
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
cyan endp

gray proc
    mov r8d, 128
    mov r9d, 128
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
gray endp

darkgray proc
    mov r8d, 64
    mov r9d, 64
    mov r10d, 64
    call Color32
    mov rcx, rax
    jmp exit_paint
darkgray endp

orange proc
    mov r8d, 0
    mov r9d, 165
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
orange endp

navy proc
    mov r8d, 128
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
navy endp

lime proc
    mov r8d, 50
    mov r9d, 205
    mov r10d, 50
    call Color32
    mov rcx, rax
    jmp exit_paint
lime endp

purple proc
    mov r8d, 128
    mov r9d, 0
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
purple endp

skyblue proc
    mov r8d, 235
    mov r9d, 206
    mov r10d, 135
    call Color32
    mov rcx, rax
    jmp exit_paint
skyblue endp

gold proc
    mov r8d, 0
    mov r9d, 215
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
gold endp

silver proc
    mov r8d, 192
    mov r9d, 192
    mov r10d, 192
    call Color32
    mov rcx, rax
    jmp exit_paint
silver endp

pink proc
    mov r8d, 203
    mov r9d, 192
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
pink endp

crimson proc
    mov r8d, 60
    mov r9d, 20
    mov r10d, 220
    call Color32
    mov rcx, rax
    jmp exit_paint
crimson endp

teal proc
    mov r8d, 128
    mov r9d, 128
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
teal endp

forestgreen proc
    mov r8d, 34
    mov r9d, 139
    mov r10d, 34
    call Color32
    mov rcx, rax
    jmp exit_paint
forestgreen endp

violet proc
    mov r8d, 238
    mov r9d, 130
    mov r10d, 238
    call Color32
    mov rcx, rax
    jmp exit_paint
violet endp

chocolate proc
    mov r8d, 30
    mov r9d, 105
    mov r10d, 210
    call Color32
    mov rcx, rax
    jmp exit_paint
chocolate endp

hotpink proc
    mov r8d, 180
    mov r9d, 105
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
hotpink endp

emerald proc
    mov r8d, 120
    mov r9d, 200
    mov r10d, 80
    call Color32
    mov rcx, rax
    jmp exit_paint
emerald endp

royalblue proc
    mov r8d, 225
    mov r9d, 105
    mov r10d, 65
    call Color32
    mov rcx, rax
    jmp exit_paint
royalblue endp

; -----------------------------------------------------------------------------------------
; exit_paint: Final GDI Draw Sequence & Cleanup
; -----------------------------------------------------------------------------------------
exit_paint proc
    call CreateSolidBrush
    mov r15, rax      ; Store brush handle in non-volatile register
    add rsp, 28h

    sub rsp, 28h
    mov rcx, r12      ; HDC (expected in r12 from BtnProc)
    lea rdx, [rbp-48] ; Stack RECT address
    mov r8, r15       ; The Brush
    call FrameRect
    add rsp, 28h

    ; Mandatory cleanup to prevent GDI handle exhaustion
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject
    add rsp, 28h

    ret
exit_paint endp

end
