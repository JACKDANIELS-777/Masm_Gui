; =========================================================================================
; MASM_GUI V0.21 - Unified Rendering Engine (Sanitized)
; Stayed the same is needed for CustomWindow to function properly.
; =========================================================================================

include CustomButtonConstants.inc

extern FrameRect:proc
extern CreateSolidBrush:proc
extern Color32:proc
extern DeleteObject:proc
extern FillRect:proc

.code

align 8
ColorJumpTable QWORD default_color
               QWORD red
               QWORD green
               QWORD blue
               QWORD white
               QWORD yellow
               QWORD magenta
               QWORD cyan
               QWORD gray
               QWORD darkgray
               QWORD orange
               QWORD navy
               QWORD lime
               QWORD purple
               QWORD skyblue
               QWORD gold
               QWORD silver
               QWORD pink
               QWORD crimson
               QWORD teal
               QWORD forestgreen
               QWORD violet
               QWORD chocolate
               QWORD hotpink
               QWORD emerald
               QWORD royalblue

MaxColorID EQU 25

ColorBtnBorder proc
    sub rsp, 28h
    cmp rcx, MaxColorID
    ja default_color
    lea r11, [ColorJumpTable]   
    mov r14, ColorButtonBorder
    jmp qword ptr [r11 + rcx * 8]   
ColorBtnBorder endp

ColorBtnRect proc
    sub rsp, 28h
    cmp rcx, MaxColorID
    ja default_color
    lea r11, [ColorJumpTable]      
    mov r14, ColorButtonRect
    jmp qword ptr [r11 + rcx * 8]           
ColorBtnRect endp



; --- Shared Color Procedures ---

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

; --- Unified GDI Logic ---

exit_paint proc
    call CreateSolidBrush
    mov r15, rax
    add rsp, 28h

    cmp r14, ColorButtonBorder
    je _DrawBorder
    cmp r14, ColorButtonRect
    je _DrawFill

_DrawBorder:
    sub rsp, 28h
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FrameRect
    add rsp, 28h
    jmp _cleanup

_DrawFill:
    sub rsp, 28h
    mov rcx, r12
    lea rdx, [rbp-48]
    mov r8, r15
    call FillRect
    add rsp, 28h
    jmp _cleanup

_cleanup:
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject
    add rsp, 28h
    ret
exit_paint endp

end
