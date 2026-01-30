


extern procs:proc
.data
;hwnd ; 8 bytes
;event id ;4
;proc index ;4 
; 48 bytes  exstra space
public EventManagerTable
EventManagerTable db 100 dup( 64 dup(0) )
public LenEMT
LenEMT equ $ - EventManagerTable


.code

EventManager proc
;rcx hwnd
;rdx UINT 
; r8 WPARAM 
;r9 LPARAM 
;r10 event if
;r11 proc index

;r14 r15
lea r14,EventManagerTable

_Checked_loop:
	mov rax,qword ptr[r14]
	cmp qword ptr[r14], rcx
	jne _reloop
	mov eax,dword ptr[r14+12]
	cmp dword ptr[r14+8],r10d
	jne _reloop

	mov r10d, dword ptr[r14+12]
	shl r10,3
	lea r11, procs
	add r11,r10
	call qword ptr[r11]

	jmp _done
	_reloop:
		cmp qword ptr[r14],0
		je _done
		add r14,64
		jmp _Checked_loop
_done:
ret
EventManager endp


end
