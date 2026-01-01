; =============================================================
; CUSTOM CALLING CONVENTION FOR UI CREATION
; =============================================================
; INPUTS:
;   RBX      : Control ID (Menu ID)
;   RDX      : Class Name Address (e.g., &StaticClass)
;   R8       : Window Text Address
;   R9       : Window Style (e.g., WS_VISIBLE | WS_CHILD)
;   R10-R11  : X, Y Position (Volatile - Reset each call)
;   R12-R13  : Width, Height (Preserved)
;   R14      : Parent Handle (Preserved)
;   R15      : Instance Handle (Preserved)
; =============================================================

include constants.inc

extern CreateWindowExA:proc

.data


.code

CreateLabelEdit proc

sub rsp,60h


mov rcx,0
mov qword ptr[rsp+20h],r10
mov qword ptr[rsp+28h],r11
mov qword ptr[rsp+30h],r12
mov qword ptr[rsp+38h],r13 ; ie pos
mov qword ptr[rsp+40h],r14 
mov qword ptr[rsp+48h],rbx
mov qword ptr[rsp+50h],r15
mov qword ptr[rsp+58h],0

call CreateWindowExA
add rsp,60h

ret  ;returns the handle or 0
CreateLabelEdit endp
end

