; =========================================================================================
; MASM x64 Layout Engine v0.21
; Description: Dynamic UI parser for Windows Common Controls.
; Syntax: "Type,ID,X,Y,W,H,Text,\c"
; =========================================================================================

include constants.inc

extern AppendMenuA        : proc
extern CreateMenu         : proc
extern CreateLabelEdit    : proc
extern MessageBoxA        : proc
extern DefSubclassProc    : proc
extern SetWindowSubclass  : proc
extern Color32            : proc
extern SetTextColor       : proc
extern SetBkMode          : proc
extern GetStockObject     : proc
extern SendMessageA       : proc
extern FillRect           : proc
extern GetClientRect      : proc
extern EndPaint           : proc
extern BeginPaint         : proc
extern SetWindowTheme     : proc
extern GetDC              : proc
extern ValidateRect       : proc
extern InvalidateRect     : proc
extern ReleaseDC          : proc
extern GetWindowTextA     : proc
extern DrawTextA          : proc
extern SetWindowTextA     : proc
extern SetWindowLongPtrA  : proc
extern GetWindowLongPtrA  : proc
extern UpdateWindow       : proc
extern RegisterBtn        : proc
extern GetLastError        : proc
extern RegisterCustomDlgProc        : proc
extern SetFocus        : proc
extern hwndMain           : qword


.data
    BTNHANDLE qword 0
    .data
   LayoutStr   db "Y,0,5,5,24,16,A,\c"
    db "Y,0,31,5,24,16,B,\c"
    db "Y,0,57,5,24,16,C,\c"
    db "Y,0,83,5,24,16,D,\c"
    db "Y,0,109,5,24,16,E,\c"
    db "Y,0,135,5,24,16,F,\c"
    db "Y,0,161,5,24,16,G,\c"
    db "Y,0,187,5,24,16,H,\c"
    db "Y,0,213,5,24,16,I,\c"
    db "Y,0,239,5,24,16,J,\c"
    db "Y,0,265,5,24,16,K,\c"
    db "Y,0,291,5,24,16,L,\c"
    db "Y,0,317,5,24,16,M,\c"
    db "Y,0,343,5,24,16,N,\c"
    db "Y,0,369,5,24,16,O,\c"
    db "Y,0,395,5,24,16,P,\c"
    db "Y,0,421,5,24,16,Q,\c"
    db "Y,0,447,5,24,16,R,\c"
    db "Y,0,473,5,24,16,S,\c"
    db "Y,0,499,5,24,16,T,\c"
    db "Y,0,525,5,24,16,U,\c"
    db "Y,0,551,5,24,16,V,\c"
    db "Y,0,577,5,24,16,W,\c"
    db "Y,0,603,5,24,16,X,\c"
    db "Y,0,629,5,24,16,Y,\c"
    db "Y,0,655,5,24,16,Z,\c"
    db "Y,0,681,5,24,16,aa,\c"
    db "Y,0,707,5,24,16,ab,\c"
    db "Y,0,733,5,24,16,ac,\c"
    db "Y,0,759,5,24,16,ad,\c"
    db "Y,0,785,5,24,16,ae,\c"
    db "Y,0,811,5,24,16,af,\c"
    db "Y,0,837,5,24,16,ag,\c"
    db "Y,0,863,5,24,16,ah,\c"
    db "Y,0,889,5,24,16,ai,\c"
    db "Y,0,915,5,24,16,aj,\c"
    db "Y,0,941,5,24,16,ak,\c"
    db "Y,0,967,5,24,16,al,\c"
    db "Y,0,993,5,24,16,am,\c"
    db "Y,0,1019,5,24,16,an,\c"
    db "Y,0,1045,5,24,16,ao,\c"
    db "Y,0,1071,5,24,16,ap,\c"
    db "Y,0,1097,5,24,16,aq,\c"
    db "Y,0,1123,5,24,16,ar,\c"
    db "Y,0,1149,5,24,16,as,\c"
    db "Y,0,1175,5,24,16,at,\c"
    db "Y,0,1201,5,24,16,au,\c"
    db "Y,0,1227,5,24,16,av,\c"
    db "Y,0,1253,5,24,16,aw,\c"
    db "Y,0,1279,5,24,16,ax,\c"
    db "Y,0,1305,5,24,16,ay,\c"
    db "Y,0,1331,5,24,16,az,\c"
    db "Y,0,1357,5,24,16,ba,\c"
    db "Y,0,1383,5,24,16,bb,\c"
    db "Y,0,1409,5,24,16,bc,\c"
    db "Y,0,1435,5,24,16,bd,\c"
    db "Y,0,1461,5,24,16,be,\c"
    db "Y,0,1487,5,24,16,bf,\c"
    db "Y,0,1513,5,24,16,bg,\c"
    db "Y,0,1539,5,24,16,bh,\c"
    db "Y,0,5,23,24,16,bi,\c"
    db "Y,0,31,23,24,16,bj,\c"
    db "Y,0,57,23,24,16,bk,\c"
    db "Y,0,83,23,24,16,bl,\c"
    db "Y,0,109,23,24,16,bm,\c"
    db "Y,0,135,23,24,16,bn,\c"
    db "Y,0,161,23,24,16,bo,\c"
    db "Y,0,187,23,24,16,bp,\c"
    db "Y,0,213,23,24,16,bq,\c"
    db "Y,0,239,23,24,16,br,\c"
    db "Y,0,265,23,24,16,bs,\c"
    db "Y,0,291,23,24,16,bt,\c"
    db "Y,0,317,23,24,16,bu,\c"
    db "Y,0,343,23,24,16,bv,\c"
    db "Y,0,369,23,24,16,bw,\c"
    db "Y,0,395,23,24,16,bx,\c"
    db "Y,0,421,23,24,16,by,\c"
    db "Y,0,447,23,24,16,bz,\c"
    db "Y,0,473,23,24,16,ca,\c"
    db "Y,0,499,23,24,16,cb,\c"
    db "Y,0,525,23,24,16,cc,\c"
    db "Y,0,551,23,24,16,cd,\c"
    db "Y,0,577,23,24,16,ce,\c"
    db "Y,0,603,23,24,16,cf,\c"
    db "Y,0,629,23,24,16,cg,\c"
    db "Y,0,655,23,24,16,ch,\c"
    db "Y,0,681,23,24,16,ci,\c"
    db "Y,0,707,23,24,16,cj,\c"
    db "Y,0,733,23,24,16,ck,\c"
    db "Y,0,759,23,24,16,cl,\c"
    db "Y,0,785,23,24,16,cm,\c"
    db "Y,0,811,23,24,16,cn,\c"
    db "Y,0,837,23,24,16,co,\c"
    db "Y,0,863,23,24,16,cp,\c"
    db "Y,0,889,23,24,16,cq,\c"
    db "Y,0,915,23,24,16,cr,\c"
    db "Y,0,941,23,24,16,cs,\c"
    db "Y,0,967,23,24,16,ct,\c"
    db "Y,0,993,23,24,16,cu,\c"
    db "Y,0,1019,23,24,16,cv,\c"
    db "Y,0,1045,23,24,16,cw,\c"
    db "Y,0,1071,23,24,16,cx,\c"
    db "Y,0,1097,23,24,16,cy,\c"
    db "Y,0,1123,23,24,16,cz,\c"
    db "Y,0,1149,23,24,16,da,\c"
    db "Y,0,1175,23,24,16,db,\c"
    db "Y,0,1201,23,24,16,dc,\c"
    db "Y,0,1227,23,24,16,dd,\c"
    db "Y,0,1253,23,24,16,de,\c"
    db "Y,0,1279,23,24,16,df,\c"
    db "Y,0,1305,23,24,16,dg,\c"
    db "Y,0,1331,23,24,16,dh,\c"
    db "Y,0,1357,23,24,16,di,\c"
    db "Y,0,1383,23,24,16,dj,\c"
    db "Y,0,1409,23,24,16,dk,\c"
    db "Y,0,1435,23,24,16,dl,\c"
    db "Y,0,1461,23,24,16,dm,\c"
    db "Y,0,1487,23,24,16,dn,\c"
    db "Y,0,1513,23,24,16,do,\c"
    db "Y,0,1539,23,24,16,dp,\c"
    db "Y,0,5,41,24,16,dq,\c"
    db "Y,0,31,41,24,16,dr,\c"
    db "Y,0,57,41,24,16,ds,\c"
    db "Y,0,83,41,24,16,dt,\c"
    db "Y,0,109,41,24,16,du,\c"
    db "Y,0,135,41,24,16,dv,\c"
    db "Y,0,161,41,24,16,dw,\c"
    db "Y,0,187,41,24,16,dx,\c"
    db "Y,0,213,41,24,16,dy,\c"
    db "Y,0,239,41,24,16,dz,\c"
    db "Y,0,265,41,24,16,ea,\c"
    db "Y,0,291,41,24,16,eb,\c"
    db "Y,0,317,41,24,16,ec,\c"
    db "Y,0,343,41,24,16,ed,\c"
    db "Y,0,369,41,24,16,ee,\c"
    db "Y,0,395,41,24,16,ef,\c"
    db "Y,0,421,41,24,16,eg,\c"
    db "Y,0,447,41,24,16,eh,\c"
    db "Y,0,473,41,24,16,ei,\c"
    db "Y,0,499,41,24,16,ej,\c"
    db "Y,0,525,41,24,16,ek,\c"
    db "Y,0,551,41,24,16,el,\c"
    db "Y,0,577,41,24,16,em,\c"
    db "Y,0,603,41,24,16,en,\c"
    db "Y,0,629,41,24,16,eo,\c"
    db "Y,0,655,41,24,16,ep,\c"
    db "Y,0,681,41,24,16,eq,\c"
    db "Y,0,707,41,24,16,er,\c"
    db "Y,0,733,41,24,16,es,\c"
    db "Y,0,759,41,24,16,et,\c"
    db "Y,0,785,41,24,16,eu,\c"
    db "Y,0,811,41,24,16,ev,\c"
    db "Y,0,837,41,24,16,ew,\c"
    db "Y,0,863,41,24,16,ex,\c"
    db "Y,0,889,41,24,16,ey,\c"
    db "Y,0,915,41,24,16,ez,\c"
    db "Y,0,941,41,24,16,fa,\c"
    db "Y,0,967,41,24,16,fb,\c"
    db "Y,0,993,41,24,16,fc,\c"
    db "Y,0,1019,41,24,16,fd,\c"
    db "Y,0,1045,41,24,16,fe,\c"
    db "Y,0,1071,41,24,16,ff,\c"
    db "Y,0,1097,41,24,16,fg,\c"
    db "Y,0,1123,41,24,16,fh,\c"
    db "Y,0,1149,41,24,16,fi,\c"
    db "Y,0,1175,41,24,16,fj,\c"
    db "Y,0,1201,41,24,16,fk,\c"
    db "Y,0,1227,41,24,16,fl,\c"
    db "Y,0,1253,41,24,16,fm,\c"
    db "Y,0,1279,41,24,16,fn,\c"
    db "Y,0,1305,41,24,16,fo,\c"
    db "Y,0,1331,41,24,16,fp,\c"
    db "Y,0,1357,41,24,16,fq,\c"
    db "Y,0,1383,41,24,16,fr,\c"
    db "Y,0,1409,41,24,16,fs,\c"
    db "Y,0,1435,41,24,16,ft,\c"
    db "Y,0,1461,41,24,16,fu,\c"
    db "Y,0,1487,41,24,16,fv,\c"
    db "Y,0,1513,41,24,16,fw,\c"
    db "Y,0,1539,41,24,16,fx,\c"
    db "Y,0,5,59,24,16,fy,\c"
    db "Y,0,31,59,24,16,fz,\c"
    db "Y,0,57,59,24,16,ga,\c"
    db "Y,0,83,59,24,16,gb,\c"
    db "Y,0,109,59,24,16,gc,\c"
    db "Y,0,135,59,24,16,gd,\c"
    db "Y,0,161,59,24,16,ge,\c"
    db "Y,0,187,59,24,16,gf,\c"
    db "Y,0,213,59,24,16,gg,\c"
    db "Y,0,239,59,24,16,gh,\c"
    db "Y,0,265,59,24,16,gi,\c"
    db "Y,0,291,59,24,16,gj,\c"
    db "Y,0,317,59,24,16,gk,\c"
    db "Y,0,343,59,24,16,gl,\c"
    db "Y,0,369,59,24,16,gm,\c"
    db "Y,0,395,59,24,16,gn,\c"
    db "Y,0,421,59,24,16,go,\c"
    db "Y,0,447,59,24,16,gp,\c"
    db "Y,0,473,59,24,16,gq,\c"
    db "Y,0,499,59,24,16,gr,\c",0

    Static       db "STATIC", 0
    LBL          db "edit", 0
    BTN          db "BUTTON", 0
    COMBOBOX     db "COMBOBOX", 0
    LISTBOX      db "LISTBOX", 0
    SCROLLBAR    db "SCROLLBAR", 0
    BtnClassName db "Custom Btn",0
    CustomDLGCLASSNAME db "Custom DLG",0

.code

; -----------------------------------------------------------------------------------------
; LayoutParser
; -----------------------------------------------------------------------------------------
LayoutParser proc
    lea rdx, LayoutStr
    mov r15, rcx            ; Pointer to memory
    mov r14, rdx            ; Pointer to string
    
    mov r13, 0
    mov rbx, 0              ; Command index
    mov r12, 0              ; Current position in segment
    sub rsp, 100h           ; Shadow space and local variable storage
    call RegisterBtn
    call RegisterCustomDlgProc



_loop:
    mov al, byte ptr[r14]
    cmp al, 0
    je _exit
    cmp al, "\"
    je _add_control
    cmp al, ","
    je _Comma

    mov byte ptr[r15], al
    add r15, 1
    add r13, 1
    add r12, 1
    jmp _continue

_Comma:
    cmp rbx, 0
    je _Type
    cmp rbx, 6
    je _Txt
    cmp rbx, 6
    jg _continue
    jmp _IntFound

_Type:
    sub r15, 1
    mov al, byte ptr[r15]
    cmp al, "E"
    je _Edit
    cmp al, "L"
    je _Label
    cmp al, "B"
    je _BTN
    cmp al, "C"
    je _COMBO
    cmp al, "X"
    je _LISTBX
    cmp al, "S"
    je _SCROLL
    cmp al,"Z"
    je _CtmBtn

    cmp al,"Y"
    je _CtmDlg
    jmp _continue
    
    _Label:
        mov qword ptr[rsp+0], 1
        mov r12, 0
        add rbx, 1
        jmp _continue

    _Edit:
        mov qword ptr[rsp+0], 2
        mov r12, 0
        add rbx, 1
        jmp _continue

    _BTN:
        mov qword ptr[rsp+0], 3
        mov r12, 0
        add rbx, 1
        jmp _continue 

    _COMBO:
        mov qword ptr[rsp+0], 4
        mov r12, 0
        add rbx, 1
        jmp _continue 

    _LISTBX:
        mov qword ptr[rsp+0], 5
        mov r12, 0
        add rbx, 1
        jmp _continue 

    _SCROLL:
        mov qword ptr[rsp+0], 6
        mov r12, 0
        add rbx, 1
        jmp _continue 

    _CtmBtn:
        mov qword ptr[rsp+0], 7
        mov r12, 0
        add rbx, 1
        jmp _continue 

    _CtmDlg:
        mov qword ptr[rsp+0], 8
        mov r12, 0
        add rbx, 1
        jmp _continue 
_Txt:
    sub r15, r12
    jmp _continue

_IntFound:
    mov rcx, r15
    sub rcx, r12
    mov rdx, r12 
    call StrToInt
    mov r12, 0

    cmp rbx, 1 
    je _ID
    cmp rbx, 2
    je _X_coordinate
    cmp rbx, 3
    je _Y_coordinate
    cmp rbx, 4
    je _Width
    cmp rbx, 5
    je _Height
    jmp _continue

    _ID:
        mov qword ptr[rsp+8], rax
        add rbx, 1
        jmp _continue

    _X_coordinate:
        mov qword ptr[rsp+16], rax
        add rbx, 1
        jmp _continue

    _Y_coordinate:
        mov qword ptr[rsp+24], rax
        add rbx, 1
        jmp _continue

    _Width:
        mov qword ptr[rsp+32], rax
        add rbx, 1
        jmp _continue

    _Height:
        mov qword ptr[rsp+40], rax
        add rbx, 1
        jmp _continue
    
_add_control:
    add r14, 1
    mov al, byte ptr[r14]
    cmp al, "c"
    jne _continue 

    mov qword ptr[rsp + 80], r14
    mov qword ptr[rsp + 88], r15
    mov qword ptr[rsp + 72], r13
    mov qword ptr[rsp + 64], r12

    mov rbx, qword ptr[rsp+8]
    lea rdx, Static
    lea r8, LBL
    cmp qword ptr[rsp], 2
    cmove rdx, r8
    lea r8, BTN
    cmp qword ptr[rsp], 3
    cmove rdx, r8
    lea r8, COMBOBOX
    cmp qword ptr[rsp], 4
    cmove rdx, r8
    lea r8, LISTBOX
    cmp qword ptr[rsp], 5
    cmove rdx, r8
    lea r8, SCROLLBAR
    cmp qword ptr[rsp], 6
    cmove rdx, r8
    lea r8,BtnClassName
    cmp qword ptr[rsp],7
    cmove rdx, r8

    lea r8,CustomDLGCLASSNAME
    cmp qword ptr[rsp],8
    cmove rdx, r8
   
    mov qword ptr[r15+r12], 0
    mov r8, r15
    mov r9, 50000000h
    or r9,00010000h

    call CheckWin

    mov r10, qword ptr[rsp+16]
    mov r11, qword ptr[rsp+24]
    mov r12, qword ptr[rsp+32]
    mov r13, qword ptr[rsp+40]
    mov r14, hwndMain
    mov r15, 0
   
    call CreateLabelEdit

    
    call GetLastError
    mov BTNHANDLE,rax



    mov r13, qword ptr[rsp+72]
    mov r12, qword ptr[rsp+64]
    mov r14, qword ptr[rsp+80]
    mov r15, qword ptr[rsp+88]
    mov rbx, 0
    jmp _continue

_continue:
    add r14, 1
    jmp _loop

_exit:
    add rsp, 100h
    sub rsp,28h
    mov rcx, BTNHANDLE
    mov rdx, 48059
    mov r8, 0
    xor r9, r9
    call SendMessageA
    add rsp,28h

    
    xor rax, rax
    ret
LayoutParser endp

StrToInt proc
    xor rax, rax
    xor r8, r8
_next_char:
    mov r8b, byte ptr [rcx]
    sub r8b, '0'
    cmp r8b, 9
    ja _done
    imul rax, 10
    add rax, r8
    inc rcx
    jmp _next_char
_done:
    ret
StrToInt endp

AutoEditLogic proc
    push rbp
    mov rbp, rsp
    sub rsp, 40h
    mov [rbp-8],  rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov [rbp-32], r9

    cmp rdx,512 
    je _BUTTONHOVER
    cmp rdx,673
    je _BUTTONHOVER
    cmp rdx,513
    je _BUTTONCLICK
    cmp rdx,48059
    je _BUTTONSTYLE 

_Default:
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8,  [rbp-24]
    mov r9,  [rbp-32]
    mov rax, [rbp+30h]
    mov [rsp+20h], rax
    mov rax, [rbp+38h]
    mov [rsp+28h], rax
    call DefSubclassProc
    leave
    ret

_ButtonDraw:
    sub rsp, 60h
    mov rcx, [rbp-8]
    lea rdx, [rsp+20h]
    call BeginPaint
    mov r11, rax
    mov rcx, r11
    mov edx, 0000FFFFh 
    call SetTextColor
    mov rcx, r11
    mov rdx, 1 
    call SetBkMode
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8, r11
    mov r9, [rbp-32]
    call DefSubclassProc
    mov rcx, [rbp-8]
    lea rdx, [rsp+20h]
    call EndPaint
    add rsp, 60h
    mov rax, 0
    leave
    ret
    
_BUTTONSTYLE:
    sub rsp,28h
    mov rcx, [rbp-8]
    xor rdx, rdx
    mov r8, 1
    call InvalidateRect
    mov rcx,[rbp-8]
    call UpdateWindow
    add rsp,28h
    jmp _default

_BUTTONCLICK:
    sub rsp,28h
    mov rcx, [rbp-8]
    lea rdx, LBL
    call SetWindowTextA
    add rsp,28h
    jmp _default

_BUTTONHOVER:
    sub rsp,28h
    mov rcx, [rbp-8]
    lea rdx, Static
    call SetWindowTextA
    add rsp,28h
    jmp _Default
    ret

_HandleColor:
    mov r15, [rbp-24]
    mov r15,BTNHANDLE
    sub rsp,20h
    mov r8d, 0
    mov r9d, 10
    mov r10d, 210
    call Color32
    mov rcx, r15
    mov rdx, rax
    call SetTextColor
    add rsp,20h
    sub rsp,28h
    mov rcx, r15
    mov rdx, 2
    call SetBkMode
    add rsp,28h
    sub rsp,28h
    mov rcx, 4
    call GetStockObject
    add rsp,28h
    leave
    ret

_ButtonPaint:
    mov rcx, [rbp-8]
    sub rsp,28h
    call GetDC
    mov r11, rax
    add rsp,28h
    mov rcx, [rbp-8]
    lea rdx, [rbp-48]
    sub rsp,28h
    call GetClientRect
    add rsp,28h
    sub rsp,28h
    mov rcx, 4
    call GetStockObject
    add rsp,28h
    mov r8, rax
    mov rcx, r11
    lea rdx, [rbp-48]
    sub rsp,28h
    call FillRect
    add rsp,28h
    lea rdx, [rbp-128]
    mov r8, 64
    mov rcx, [rbp-8]
    sub rsp, 28h
    call GetWindowTextA
    add rsp, 28h
    mov rcx, r11
    lea rdx, [rbp-128]
    mov r8, -1
    lea r9, [rbp-48]
    sub rsp, 30h 
    mov dword ptr [rsp+20h], 25h 
    call DrawTextA
    add rsp, 30h
    mov rcx, [rbp-8]
    mov rdx, r11
    sub rsp,28h
    call ReleaseDC
    add rsp,28h
    mov rcx, [rbp-8]
    xor rdx, rdx
    sub rsp,28h
    call ValidateRect
    add rsp,28h
    mov rax, 1
    leave
    ret
AutoEditLogic endp



CheckWin proc
push rdx
push rcx
push rax

mov rcx,90080000h
mov rcx,10CF0000h

lea rax,CustomDLGCLASSNAME
cmp rdx,rax
cmove r9,rcx

pop rax
pop rcx
pop rdx

ret
CheckWin endp
end
