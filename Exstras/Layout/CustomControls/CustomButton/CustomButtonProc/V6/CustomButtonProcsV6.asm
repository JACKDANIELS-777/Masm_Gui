; =========================================================================================
; MASM_GUI V0.27 - Unified Rendering Engine (Full Build)
; =========================================================================================

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
extern DeleteDC:proc
extern CreateCompatibleBitmap:proc
extern SelectObject:proc
extern SetTextColor:proc
extern SetBkMode:proc
extern GetWindowTextA:proc
extern DrawTextA:proc
extern RoundRect:proc
extern GetStockObject:proc
extern CreatePen:proc

.code

align 8
ColorJumpTable      QWORD default_color      ; 0
                    QWORD red                ; 1
                    QWORD green              ; 2
                    QWORD blue               ; 3
                    QWORD white              ; 4
                    QWORD yellow             ; 5
                    QWORD magenta            ; 6
                    QWORD cyan               ; 7
                    QWORD gray               ; 8
                    QWORD darkgray           ; 9
                    QWORD orange             ; 10
                    QWORD navy               ; 11
                    QWORD lime               ; 12
                    QWORD purple             ; 13
                    QWORD skyblue            ; 14
                    QWORD gold               ; 15
                    QWORD silver             ; 16
                    QWORD pink               ; 17
                    QWORD crimson            ; 18
                    QWORD teal               ; 19
                    QWORD forestgreen        ; 20
                    QWORD violet             ; 21
                    QWORD chocolate          ; 22
                    QWORD hotpink            ; 23
                    QWORD emerald            ; 24
                    QWORD royalblue          ; 25
                    QWORD coral              ; 26
                    QWORD tan                ; 27
                    QWORD midnight           ; 28
                    QWORD neon_lime          ; 29
                    QWORD slate              ; 30
                    QWORD olive              ; 31
                    QWORD steelblue          ; 32
                    QWORD maroon             ; 33
                    QWORD seagreen           ; 34
                    QWORD pureblack          ; 35
                    QWORD amber              ; 36
                    QWORD deepsky            ; 37
                    QWORD plum               ; 38
                    QWORD mint               ; 39
                    QWORD burntorange        ; 40
                    QWORD lavender           ; 41
                    QWORD charcoal           ; 42
                    QWORD acid_green         ; 43
                    QWORD sand               ; 44
                    QWORD blood_orange       ; 45
                    QWORD deep_purple        ; 46
                    QWORD ocean              ; 47
                    QWORD rose               ; 48
                    QWORD gold_leaf          ; 49
                    QWORD glacier            ; 50
                    QWORD bisque             ; 51
                    QWORD firebrick          ; 52
                    QWORD lightseagreen      ; 53
                    QWORD darkturquoise      ; 54
                    QWORD mediumspringgreen  ; 55
                    QWORD azure              ; 56
                    QWORD indigo             ; 57
                    QWORD peachpuff          ; 58
                    QWORD salmon             ; 59
                    QWORD thistle            ; 60
                    QWORD plumviolet         ; 61
                    QWORD darkolivegreen     ; 62
                    QWORD lightcoral         ; 63
                    QWORD darkseagreen       ; 64
                    QWORD mediumturquoise    ; 65
                    QWORD palegreen          ; 66
                    QWORD darkkhaki          ; 67
                    QWORD lightskyblue       ; 68
                    QWORD darkgoldenrod      ; 69
                    QWORD lightslategray     ; 70
                    QWORD darkorange         ; 71
                    QWORD mediumvioletred    ; 72
                    QWORD lightgreen         ; 73
                    QWORD darkred            ; 74
                    QWORD midnight_gold      ; 75 (New)
                    QWORD neon_obsidian     ; 76 (New)
                    QWORD electric_blue      ; 77 (New)
                    QWORD desert_rose        ; 78 (New)
                    QWORD forest_mist        ; 79 (New)
                    QWORD cyber_purple       ; 80 (New)
                    QWORD blood_ruby         ; 81 (New)
                    QWORD arctic_fox         ; 82 (New)
                    QWORD toxic_waste        ; 83 (New)
                    QWORD royal_amber        ; 84 (New)

MaxColorID EQU 84

; =========================================================================================
; DISPATCHERS
; =========================================================================================

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

RoundBtnRect proc
    sub rsp, 28h
    cmp rcx, MaxColorID
    ja default_color
    lea r11, [ColorJumpTable]      
    mov r14, ColorButtonRound
    jmp qword ptr [r11 + rcx * 8]            
RoundBtnRect endp

; =========================================================================================
; COLOR PROCEDURES
; =========================================================================================

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

coral proc
    mov r8d, 80
    mov r9d, 127
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
coral endp

tan proc
    mov r8d, 142
    mov r9d, 180
    mov r10d, 210
    call Color32
    mov rcx, rax
    jmp exit_paint
tan endp

midnight proc
    mov r8d, 112
    mov r9d, 25
    mov r10d, 25
    call Color32
    mov rcx, rax
    jmp exit_paint
midnight endp

neon_lime proc
    mov r8d, 50
    mov r9d, 255
    mov r10d, 50
    call Color32
    mov rcx, rax
    jmp exit_paint
neon_lime endp

slate proc
    mov r8d, 144
    mov r9d, 128
    mov r10d, 112
    call Color32
    mov rcx, rax
    jmp exit_paint
slate endp

olive proc
    mov r8d, 0
    mov r9d, 128
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
olive endp

steelblue proc
    mov r8d, 180
    mov r9d, 130
    mov r10d, 70
    call Color32
    mov rcx, rax
    jmp exit_paint
steelblue endp

maroon proc
    mov r8d, 0
    mov r9d, 0
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
maroon endp

seagreen proc
    mov r8d, 87
    mov r9d, 139
    mov r10d, 46
    call Color32
    mov rcx, rax
    jmp exit_paint
seagreen endp

pureblack proc
    xor r8d, r8d
    xor r9d, r9d
    xor r10d, r10d
    call Color32
    mov rcx, rax
    jmp exit_paint
pureblack endp

amber proc
    mov r8d, 0
    mov r9d, 191
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
amber endp

deepsky proc
    mov r8d, 255
    mov r9d, 191
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
deepsky endp

plum proc
    mov r8d, 221
    mov r9d, 160
    mov r10d, 221
    call Color32
    mov rcx, rax
    jmp exit_paint
plum endp

mint proc
    mov r8d, 200
    mov r9d, 255
    mov r10d, 180
    call Color32
    mov rcx, rax
    jmp exit_paint
mint endp

burntorange proc
    mov r8d, 0
    mov r9d, 69
    mov r10d, 204
    call Color32
    mov rcx, rax
    jmp exit_paint
burntorange endp

lavender proc
    mov r8d, 250
    mov r9d, 230
    mov r10d, 230
    call Color32
    mov rcx, rax
    jmp exit_paint
lavender endp

charcoal proc
    mov r8d, 50
    mov r9d, 50
    mov r10d, 50
    call Color32
    mov rcx, rax
    jmp exit_paint
charcoal endp

acid_green proc
    mov r8d, 0
    mov r9d, 255
    mov r10d, 176
    call Color32
    mov rcx, rax
    jmp exit_paint
acid_green endp

sand proc
    mov r8d, 186
    mov r9d, 223
    mov r10d, 240
    call Color32
    mov rcx, rax
    jmp exit_paint
sand endp

blood_orange proc
    mov r8d, 0
    mov r9d, 69
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
blood_orange endp

deep_purple proc
    mov r8d, 128
    mov r9d, 0
    mov r10d, 48
    call Color32
    mov rcx, rax
    jmp exit_paint
deep_purple endp

ocean proc
    mov r8d, 140
    mov r9d, 100
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
ocean endp

rose proc
    mov r8d, 127
    mov r9d, 120
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
rose endp

gold_leaf proc
    mov r8d, 32
    mov r9d, 170
    mov r10d, 218
    call Color32
    mov rcx, rax
    jmp exit_paint
gold_leaf endp

glacier proc
    mov r8d, 255
    mov r9d, 250
    mov r10d, 240
    call Color32
    mov rcx, rax
    jmp exit_paint
glacier endp

bisque proc
    mov r8d, 240
    mov r9d, 230
    mov r10d, 140
    call Color32
    mov rcx, rax
    jmp exit_paint
bisque endp

firebrick proc
    mov r8d, 192
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
firebrick endp

lightseagreen proc
    mov r8d, 32
    mov r9d, 178
    mov r10d, 173
    call Color32
    mov rcx, rax
    jmp exit_paint
lightseagreen endp

darkturquoise proc
    mov r8d, 0
    mov r9d, 130
    mov r10d, 184
    call Color32
    mov rcx, rax
    jmp exit_paint
darkturquoise endp

mediumspringgreen proc
    mov r8d, 0
    mov r9d, 250
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
mediumspringgreen endp

azure proc
    mov r8d, 0
    mov r9d, 255
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
azure endp

indigo proc
    mov r8d, 75
    mov r9d, 0
    mov r10d, 130
    call Color32
    mov rcx, rax
    jmp exit_paint
indigo endp

peachpuff proc
    mov r8d, 255
    mov r9d, 218
    mov r10d, 185
    call Color32
    mov rcx, rax
    jmp exit_paint
peachpuff endp

salmon proc
    mov r8d, 250
    mov r9d, 128
    mov r10d, 114
    call Color32
    mov rcx, rax
    jmp exit_paint
salmon endp

thistle proc
    mov r8d, 236
    mov r9d, 233
    mov r10d, 229
    call Color32
    mov rcx, rax
    jmp exit_paint
thistle endp

plumviolet proc
    mov r8d, 128
    mov r9d, 0
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
plumviolet endp

darkolivegreen proc
    mov r8d, 0
    mov r9d, 100
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
darkolivegreen endp

lightcoral proc
    mov r8d, 240
    mov r9d, 128
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp exit_paint
lightcoral endp

darkseagreen proc
    mov r8d, 0
    mov r9d, 102
    mov r10d, 51
    call Color32
    mov rcx, rax
    jmp exit_paint
darkseagreen endp

mediumturquoise proc
    mov r8d, 0
    mov r9d, 200
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
mediumturquoise endp

palegreen proc
    mov r8d, 0
    mov r9d, 255
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
palegreen endp

darkkhaki proc
    mov r8d, 149
    mov r9d, 165
    mov r10d, 100
    call Color32
    mov rcx, rax
    jmp exit_paint
darkkhaki endp

lightskyblue proc
    mov r8d, 135
    mov r9d, 206
    mov r10d, 235
    call Color32
    mov rcx, rax
    jmp exit_paint
lightskyblue endp

darkgoldenrod proc
    mov r8d, 184
    mov r9d, 134
    mov r10d, 11
    call Color32
    mov rcx, rax
    jmp exit_paint
darkgoldenrod endp

lightslategray proc
    mov r8d, 119
    mov r9d, 136
    mov r10d, 153
    call Color32
    mov rcx, rax
    jmp exit_paint
lightslategray endp

darkorange proc
    mov r8d, 255
    mov r9d, 140
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
darkorange endp

mediumvioletred proc
    mov r8d, 199
    mov r9d, 21
    mov r10d, 132
    call Color32
    mov rcx, rax
    jmp exit_paint
mediumvioletred endp

lightgreen proc
    mov r8d, 144
    mov r9d, 238
    mov r10d, 144
    call Color32
    mov rcx, rax
    jmp exit_paint
lightgreen endp

darkred proc
    mov r8d, 139
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
darkred endp

; --- NEW COLORS ---

midnight_gold proc
    mov r8d, 0
    mov r9d, 180
    mov r10d, 215
    call Color32
    mov rcx, rax
    jmp exit_paint
midnight_gold endp

neon_obsidian proc
    mov r8d, 20
    mov r9d, 0
    mov r10d, 15
    call Color32
    mov rcx, rax
    jmp exit_paint
neon_obsidian endp

electric_blue proc
    mov r8d, 255
    mov r9d, 120
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp exit_paint
electric_blue endp

desert_rose proc
    mov r8d, 150
    mov r9d, 100
    mov r10d, 230
    call Color32
    mov rcx, rax
    jmp exit_paint
desert_rose endp

forest_mist proc
    mov r8d, 110
    mov r9d, 140
    mov r10d, 80
    call Color32
    mov rcx, rax
    jmp exit_paint
forest_mist endp

cyber_purple proc
    mov r8d, 255
    mov r9d, 20
    mov r10d, 180
    call Color32
    mov rcx, rax
    jmp exit_paint
cyber_purple endp

blood_ruby proc
    mov r8d, 40
    mov r9d, 0
    mov r10d, 150
    call Color32
    mov rcx, rax
    jmp exit_paint
blood_ruby endp

arctic_fox proc
    mov r8d, 245
    mov r9d, 250
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
arctic_fox endp

toxic_waste proc
    mov r8d, 0
    mov r9d, 255
    mov r10d, 120
    call Color32
    mov rcx, rax
    jmp exit_paint
toxic_waste endp

royal_amber proc
    mov r8d, 0
    mov r9d, 126
    mov r10d, 255
    call Color32
    mov rcx, rax
    jmp exit_paint
royal_amber endp

; =========================================================================================
; MAIN LOGIC
; =========================================================================================

exit_paint proc
    cmp r14, ColorButtonForeground
    je _Foreground

    mov r11, rcx
    call CreateSolidBrush
    mov r15, rax
    add rsp, 28h

    cmp r14, ColorButtonBorder
    je _DrawBorder

    cmp r14, ColorButtonRect
    je _DrawFill

    cmp r14, ColorButtonRound
    je _Round

    jmp _cleanup

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
    mov r14, rax
    add rsp, 28h
    sub rsp, 28h
    mov rcx, [rbp+16]
    lea rdx, [rbp-320h]
    mov r8, 100
    call GetWindowTextA
    add rsp, 28h

    sub rsp, 28h
    mov rcx, r12
    mov rdx, r14
    call SetTextColor
    add rsp, 28h

    sub rsp, 28h
    mov rcx, r12
    mov rdx, 1
    call SetBkMode
    add rsp, 28h

    sub rsp, 38h
    mov rcx, r12
    lea rdx, [rbp-320h]
    mov r8, -1
    lea r9, [rbp-48]
    mov qword ptr [rsp+20h], 25h
    call DrawTextA
    add rsp, 38h
    jmp _cleanup

_Round:
    sub rsp, 38h
    mov rcx, 0                                  
    mov rdx, 1        
    mov r8, r11                                 
    call CreatePen
    mov rdi, rax                                 

    mov rcx, r12                                 
    mov rdx, rdi                                 
    call SelectObject
    mov r13, rax

    mov rcx, r12
    mov rdx, r15
    call SelectObject
    mov r14, rax

    mov rcx, r12
    mov edx, dword ptr[rbp-48]
    mov r8d, dword ptr[rbp-44]
    mov r9d, dword ptr[rbp-40]
    
    mov eax, dword ptr[rbp-36]
    mov dword ptr[rsp+20h], eax 

    mov eax, dword ptr[rbp-36]   
    sub eax, dword ptr[rbp-44]   
    shr eax, 1

    mov dword ptr[rsp+28h], eax  
    mov dword ptr[rsp+30h], eax  

    call RoundRect

    mov rcx, r12
    mov rdx, r13
    call SelectObject

    mov rcx, r12
    mov rdx, r14
    call SelectObject
    add rsp, 38h

_cleanup:
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject
    add rsp, 28h
    ret
exit_paint endp

GradFill proc
    lea rax, [rbp-320]
    lea rbx, [rbp-304]
    lea rdi, [rbp-280]
    lea r10, [rbp-260]

    mov dword ptr[rax], 12
    mov dword ptr[rax+4], 0
    mov word ptr[rax+8], 0FFFFh
    mov word ptr[rax+10], 0FFFFh
    mov word ptr[rax+12], 0000h
    mov word ptr[rax+14], 0000h

    mov eax, dword ptr[rbp-40]
    mov dword ptr[rbx], 0
    mov eax, dword ptr[rbp-36]
    mov dword ptr[rbx+4], 25
    mov word ptr[rbx+8], 8000h
    mov word ptr[rbx+10], 0000h
    mov word ptr[rbx+12], 0FF00h
    mov word ptr[rbx+14], 0000h

    mov eax, dword ptr[rbp-40]
    mov dword ptr[rdi], 25
    mov eax, dword ptr[rbp-36]
    mov dword ptr[rdi+4], 25
    mov word ptr[rdi+8], 8000h
    mov word ptr[rdi+10], 0000h
    mov word ptr[rdi+12], 0FF00h
    mov word ptr[rdi+14], 0000h

    mov dword ptr[r10], 0
    mov dword ptr[r10+4], 1
    mov dword ptr[r10+8], 2

    sub rsp, 48h
    mov rcx, r12
    lea rdx, [rbp-320]
    mov r8, 3
    mov r9, r10
    mov qword ptr[rsp+20h], 1
    mov qword ptr[rsp+28h], 2h
    call GradientFill 
    add rsp, 48h
    call GetLastError
    ret
GradFill endp

Blend proc
    sub rsp, 28h
    mov rcx, r12
    call CreateCompatibleDC
    mov r14, rax
    mov rcx, r12
    mov rdx, 200
    mov r8, 200
    call CreateCompatibleBitmap
    mov r15, rax
    mov rcx, r14
    mov rdx, r15
    call SelectObject
    mov rcx, 00FF0080h
    call CreateSolidBrush
    mov rbx, rax
    sub rsp, 20h
    mov dword ptr [rsp], 0
    mov dword ptr [rsp+4], 0
    mov dword ptr [rsp+8], 200
    mov dword ptr [rsp+12], 200 
    mov rcx, r14
    mov rdx, rsp
    mov r8, rbx
    call FillRect
    add rsp, 20h
    mov rcx, rbx
    call DeleteObject
    add rsp, 28h
    sub rsp, 60h
    mov rcx, r12
    xor rdx, rdx
    xor r8, r8
    mov r9, 200
    mov qword ptr [rsp+20h], 200
    mov qword ptr [rsp+28h], r14
    mov qword ptr [rsp+30h], 0
    mov qword ptr [rsp+38h], 0
    mov qword ptr [rsp+40h], 200
    mov qword ptr [rsp+48h], 200
    mov eax, 00300000h
    mov [rsp+50h], rax
    call AlphaBlend
    add rsp, 60h
    sub rsp, 28h
    mov rcx, r15
    call DeleteObject
    mov rcx, r14
    call DeleteDC
    add rsp, 28h
    ret
Blend endp

end
