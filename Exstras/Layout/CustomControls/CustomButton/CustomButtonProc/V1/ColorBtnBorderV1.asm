;Ineffient jump table is better
include CustomButtonConstants.inc



extern FrameRect:proc
extern CreateSolidBrush:proc
extern Color32:proc

.data



.code
ColorBtnBorder proc
    
    ;rcx color code ie red green blue
    sub rsp,28h

    cmp rcx,1
    je _red

    cmp rcx,2
    je _green

    cmp rcx,3
    je _blue

    cmp rcx,4
    je _white

    cmp rcx,5
    je _yellow

    cmp rcx,6
    je _magenta

    cmp rcx,7
    je _cyan

    cmp rcx,8
    je _gray

    cmp rcx,9
    je _dark_gray

    cmp rcx,10
    je _orange

    cmp rcx,11
    je _navy
    cmp rcx,12
    je _lime
    cmp rcx,13
    je _purple
    cmp rcx,14
    je _sky_blue

    je _gold
    cmp rcx, 16

    je _silver
    cmp rcx, 17
    je _pink
    cmp rcx, 18
    je _crimson
    cmp rcx, 19
    je _teal
    cmp rcx, 20
    je _forest_green
    cmp rcx, 21
    je _violet
    cmp rcx, 22
    je _chocolate
    cmp rcx, 23
    je _hot_pink
    cmp rcx, 24
    je _emerald
    cmp rcx, 25
    je _royal_blue




_default:
    mov r8d,0
    mov r9d,0
    mov r10d,0
    call Color32


    mov rcx,rax
    jmp _exit

_red:
    mov r8d,0
    mov r9d,0
    mov r10d,100
    call Color32


    mov rcx,rax
    jmp _exit
_green:
    mov r8d,0
    mov r9d,100
    mov r10d,0
    call Color32


    mov rcx,rax
    jmp _exit
_blue:
    


    mov r8d,100
    mov r9d,0
    mov r10d,0
    call Color32


    mov rcx,rax
    jmp _exit
 _white:
    mov r8d, 255      ; Blue
    mov r9d, 255      ; Green
    mov r10d, 255     ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_yellow:
    mov r8d, 0        ; Blue (0)
    mov r9d, 255      ; Green (255)
    mov r10d, 255     ; Red (255)
    call Color32
    mov rcx, rax
    jmp _exit

_magenta:
    mov r8d, 255      ; Blue
    mov r9d, 0        ; Green
    mov r10d, 255     ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_cyan:
    mov r8d, 255      ; Blue
    mov r9d, 255      ; Green
    mov r10d, 0        ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_gray:
    mov r8d, 128
    mov r9d, 128
    mov r10d, 128
    call Color32
    mov rcx, rax
    jmp _exit

_dark_gray:
    mov r8d, 64
    mov r9d, 64
    mov r10d, 64
    call Color32
    mov rcx, rax
    jmp _exit

_orange:
    mov r8d, 0        ; Blue (0)
    mov r9d, 165      ; Green (165)
    mov r10d, 255     ; Red (255)
    call Color32
    mov rcx, rax
    jmp _exit

_navy:
    mov r8d, 128      ; Blue (Dark)
    mov r9d, 0
    mov r10d, 0
    call Color32
    mov rcx, rax
    jmp _exit

_lime:
    mov r8d, 50       ; Blue
    mov r9d, 205      ; Green
    mov r10d, 50      ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_purple:
    mov r8d, 128      ; Blue
    mov r9d, 0        ; Green
    mov r10d, 128     ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_sky_blue:
    mov r8d, 235      ; Blue
    mov r9d, 206      ; Green
    mov r10d, 135     ; Red
    call Color32
    mov rcx, rax
    jmp _exit

_gold:
    mov r8d, 0        ; B
    mov r9d, 215      ; G
    mov r10d, 255     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_silver:
    mov r8d, 192      ; B
    mov r9d, 192      ; G
    mov r10d, 192     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_pink:
    mov r8d, 203      ; B
    mov r9d, 192      ; G
    mov r10d, 255     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_crimson:
    mov r8d, 60       ; B
    mov r9d, 20       ; G
    mov r10d, 220     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_teal:
    mov r8d, 128      ; B
    mov r9d, 128      ; G
    mov r10d, 0       ; R
    call Color32
    mov rcx, rax
    jmp _exit

_forest_green:
    mov r8d, 34       ; B
    mov r9d, 139      ; G
    mov r10d, 34      ; R
    call Color32
    mov rcx, rax
    jmp _exit

_violet:
    mov r8d, 238      ; B
    mov r9d, 130      ; G
    mov r10d, 238     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_chocolate:
    mov r8d, 30       ; B
    mov r9d, 105      ; G
    mov r10d, 210     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_hot_pink:
    mov r8d, 180      ; B
    mov r9d, 105      ; G
    mov r10d, 255     ; R
    call Color32
    mov rcx, rax
    jmp _exit

_emerald:
    mov r8d, 120      ; B
    mov r9d, 200      ; G
    mov r10d, 80      ; R
    call Color32
    mov rcx, rax
    jmp _exit

_royal_blue:
    mov r8d, 225      ; B
    mov r9d, 105      ; G
    mov r10d, 65      ; R
    call Color32
    mov rcx, rax
    jmp _exit
_exit:
    call CreateSolidBrush
    mov r15,rax


    add rsp,28h


    sub rsp,28h
    mov rcx,r12
    lea rdx,[rbp-48]
    mov r8,r15

    call FrameRect
    add rsp,28h


    mov rax,r15
    ret
ColorBtnBorder endp


end
