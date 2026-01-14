; =========================================================================================
; See other CustomButtonProcsV5 for more details
;============================

include CustomButtonConstants.inc

extern FrameRect:proc
extern CreateSolidBrush:proc
extern Color32:proc
extern DeleteObject:proc
extern FillRect:proc
extern GradientFill:proc
extern GetLastError:proc
extern AlphaBlend:proc
extern CreateCompatibleDC:proc
extern DeleteObject:proc
extern DeleteDC:proc
extern CreateCompatibleBitmap:proc
extern SelectObject:proc
extern FillRect:proc
extern SetTextColor:proc
extern SetBkMode:proc
extern GetWindowTextA:proc
extern DrawTextA:proc



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

SetForeground proc
sub rsp, 28h
  cmp rcx, MaxColorID
    ja default_color
    lea r11, [ColorJumpTable]      
    mov r14, ColorButtonForeground
    jmp qword ptr [r11 + rcx * 8]    


SetForeground endp

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

    cmp r14,ColorButtonForeground
    je _Foreground

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

_Foreground:
    mov r14,rax
    add rsp,28h


    sub rsp,28h
    mov rcx,[rbp+16]
    lea rdx, [rbp-320h]
    mov r8,100

    call GetWindowTextA
    add rsp,28h


    sub rsp,28h
    mov rcx,r12
    mov rdx,r14
    call SetTextColor
    add rsp,28h

    sub rsp,28h
    mov rcx,r12
    mov rdx,1
    call SetBkMode
    add rsp,28h

    sub rsp,38h
    mov rcx,r12
    lea rdx,[rbp-320h]
    mov r8,-1
    lea r9,[rbp-48]
    mov qword ptr [rsp+20h], 25h
    call DrawTextA
    add rsp,38h

    jmp _cleanup
    
_cleanup:
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject
    add rsp, 28h
    ret
exit_paint endp



GradFill proc

lea rax,[rbp-320]
lea rbx,[rbp-304]
lea rdi,[rbp-280]
lea r10, [rbp-260]



; --- Vertex 0: Electric Yellow (Top) ---
mov dword ptr[rax], 12            ; x
mov dword ptr[rax+4], 0          ; y
mov word ptr[rax+8], 0FFFFh      ; Red (Full)
mov word ptr[rax+10], 0FFFFh     ; Green (Full)
mov word ptr[rax+12], 0000h      ; Blue (Zero)
mov word ptr[rax+14], 0000h      ; Alpha

; --- Vertex 1: Cyber Purple (Bottom) ---
mov eax, dword ptr[rbp-40]
mov dword ptr[rbx], 0           ; x
mov eax, dword ptr[rbp-36]
mov dword ptr[rbx+4], 25         ; y
mov word ptr[rbx+8], 8000h       ; Red (Medium)
mov word ptr[rbx+10], 0000h      ; Green (Zero)
mov word ptr[rbx+12], 0FF00h     ; Blue (Full)
mov word ptr[rbx+14], 0000h      ; Alpha

mov eax, dword ptr[rbp-40]
mov dword ptr[rdi], 25           ; x
mov eax, dword ptr[rbp-36]
mov dword ptr[rdi+4], 25         ; y
mov word ptr[rdi+8], 8000h      ; Red (Full)
mov word ptr[rdi+10], 0000h     ; Green (Full)
mov word ptr[rdi+12], 0FF00h      ; Blue (Zero)
mov word ptr[rdi+14], 0000h      ; Alpha

mov dword ptr[r10],0
mov dword ptr[r10+4],1
mov dword ptr[r10+8],2

sub rsp,48h
mov rcx,r12
lea rdx,[rbp-320]
mov r8,3
mov r9,r10
mov qword ptr[rsp+20h],1
mov qword ptr[rsp+28h],2h

call GradientFill 
add rsp,48h

call GetLastError
ret

GradFill endp


Blend proc
    ; 1. Setup the Ghost DC
    sub rsp, 28h
    mov rcx, r12
    call CreateCompatibleDC
    mov r14, rax        ; r14 = Ghost HDC

    ; 2. Create the Canvas (The "Paper")
    mov rcx, r12        ; Match screen depth
    mov rdx, 200
    mov r8, 200
    call CreateCompatibleBitmap
    mov r15, rax        ; r15 = Bitmap Handle

    ; 3. Select Bitmap into DC
    mov rcx, r14
    mov rdx, r15
    call SelectObject
    ; rax now holds the "old" 1x1 bitmap; usually we save it to restore later
    
    ; --- THE MISSING PAINT STEP ---
    ; Create a Purple Brush (Red: 80h, Green: 00h, Blue: FFh)
    mov rcx, 00FF0080h  ; ColorRef: 00BBGGRRh
    call CreateSolidBrush
    mov rbx, rax        ; Save brush in rbx

    ; Define the 200x200 Rect on the stack
    sub rsp, 20h
    mov dword ptr [rsp], 0      ; left
    mov dword ptr [rsp+4], 0    ; top
    mov dword ptr [rsp+8], 200  ; right
    mov dword ptr [rsp+12], 200 ; bottom
    
    mov rcx, r14        ; Target: Ghost DC
    mov rdx, rsp        ; Pointer to RECT
    mov r8, rbx         ; The Brush
    call FillRect
    add rsp, 20h
    
    ; Clean up the brush immediately
    mov rcx, rbx
    call DeleteObject
    add rsp, 28h

    ; 4. The 11-Parameter AlphaBlend Call
    sub rsp, 60h
    mov rcx, r12        ; Destination (Screen)
    xor rdx, rdx        ; xDest: 0
    xor r8, r8          ; yDest: 0
    mov r9, 200         ; wDest
    
    mov qword ptr [rsp+20h], 200  ; hDest
    mov qword ptr [rsp+28h], r14  ; hdcSrc (Ghost DC)
    mov qword ptr [rsp+30h], 0    ; xSrc
    mov qword ptr [rsp+38h], 0    ; ySrc
    mov qword ptr [rsp+40h], 200  ; wSrc (Matched to bitmap)
    mov qword ptr [rsp+48h], 200  ; hSrc (Matched to bitmap)
    
    mov eax, 00300000h            ; 50% Transparency
    mov [rsp+50h], rax            ; Pass by VALUE

    call AlphaBlend
    add rsp, 60h

    ; 5. Final Cleanup
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject   ; Delete the Bitmap
    mov rcx, r14
    call DeleteDC       ; Delete the Ghost DC
    add rsp, 28h
    ret
Blend endp

end
