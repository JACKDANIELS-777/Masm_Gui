;The below is almost finished
;It needs an update because the offsets mayb vary between machines so a different measure has to be taken.

include constants.inc
includelib d3d11.lib
includelib dxguid.lib
GUID STRUCT
    Data1   DWORD ?
    Data2   WORD  ?
    Data3   WORD  ?
    Data4   BYTE  8 DUP(?)
GUID ENDS

EXTERN IID_ID3D11Texture2D:GUID
EXTERN IID_IDXGIFactory:GUID
EXTERN IID_IDXGISwapChain:GUID
EXTERN IID_ID3D11Device:GUID

.data
extern hwndMain               : qword
extern D3D11CreateDeviceAndSwapChain:proc



ALIGN 8
g_pSwapChain dq 0
g_pd3dDevice dq 0
g_pImmediateContext dq 0
g_pRenderTargetView dq 0

ALIGN 8         
pBackBuffer dq 20 dup( 0) 
pBackBufferptr DQ pBackBuffer 

dq 0




ALIGN 16
ClearColor REAL4 1.0, 0.0, 0.0, 1.0 ; Let's use RED for the test!

sd db 72 dup(0)

ALIGN 16
MyVP REAL4 0.0, 0.0, 800.0, 600.0, 0.0, 1.0


.code 


InitDevice proc

; --- [ THE SWAP CHAIN FORGE ] ---
mov dword ptr [sd + 0],  800      ; width
mov dword ptr [sd + 4],  600      ; height
mov dword ptr [sd + 16], 28       ; DXGI_FORMAT_R8G8B8A8_UNORM (1Ch)
mov dword ptr [sd + 28], 1        ; count
; 32 is the quality
mov dword ptr [sd + 36], 20h      ; bufferusage (DXGI_USAGE_RENDER_TARGET_OUTPUT)
mov dword ptr [sd + 40], 1        ; buffercount
mov rax, hwndMain
mov qword ptr [sd + 48], rax      ; OutputWindow (QWORD Offset 48 in x64!)
mov dword ptr [sd + 56], 1        ; windowed (TRUE)
;mov dword ptr [sd + 56], 4       





sub rsp,80h
mov rcx,0
mov rdx,1
mov r8,0
mov r9,0
mov qword ptr [rsp+20h],0
mov qword ptr [rsp+28h],0
mov qword ptr [rsp+30h],7h
lea rax, sd
mov qword ptr[rsp+38h],rax
lea rax, g_pSwapChain
mov qword ptr[rsp+40h],rax
lea rax, g_pd3dDevice
mov qword ptr[rsp+48h],rax

xor rax, rax
mov qword ptr [rsp + 50h], rax

lea rax, g_pImmediateContext
mov qword ptr[rsp+58h],rax



call D3D11CreateDeviceAndSwapChain
add rsp,80h


    

sub rsp, 50h                ; 32 (Shadow) + 16 (Alignment/Local)

    mov rcx, [g_pSwapChain]     ; RCX = This
    mov rax, [rcx]              ; RAX = V-Table

    xor rdx, rdx                ; RDX = Buffer 0
    lea r8, IID_ID3D11Texture2D ; R8 = Pointer to GUID

    lea r9, [rsp+30h]    ; R9 = Pointer to Pointer (The Hole)
    
 
    call qword ptr [rax + 48h]  ; THE STRIKE
     ; Strike was successful (RAX = 0)
    mov rax, [rsp+30h]      ; Grab the pointer from the stack hole
    mov [pBackBuffer], rax  ; Save it to your .data section for the next fight
    add rsp, 50h

  

; --- [ THE FINAL 48h REVENGE ] ---
push rbp
mov rbp, rsp
and rsp, -16                ; THE ALIGNED LAW
sub rsp, 30h                ; 32 bytes shadow + 16 bytes for safety

mov rcx, [g_pd3dDevice]     ; The Device
mov rax, [rcx]              ; The V-Table

mov rdx, [pBackBuffer]      ; Param 2: The Texture
xor r8, r8                  ; Param 3: NULL Desc
lea r9, [g_pRenderTargetView] ; Param 4: The Pointer to the View

call qword ptr [rax + 48h]  ; STRIKE AT 48h (Index 9)

add rsp,30h
mov rsp, rbp
pop rbp


mov rcx, [pBackBuffer]
mov rax, [rcx]
sub rsp, 20h                ; Shadow space
call qword ptr [rax + 10h]  ; Strike Release
add rsp, 20h

; --- [ THE DIRECT SILICON STRIKE ] ---
push rbp
mov rbp, rsp
and rsp, -16                ; THE ALIGNED LAW (Must be 16-byte aligned)
sub rsp, 40h                ; 32 (Shadow) + 32 (Extra for the 8 pushes)

; --- THE PARAMS (Modern D3D11 Context5) ---
mov rcx, [g_pImmediateContext]
mov rax, [rcx]
mov edx, 1                     ; NumViews = 1
lea r8, [g_pRenderTargetView]  ; ppRTView (Address of your pointer)
xor r9, r9                     ; pDepthStencilView = NULL

; --- THE DIRECT CALL ---
;mov rax, 00007FFC7DDBB950h

call qword ptr[rax+108h]


add rsp, 40h
mov rsp, rbp
pop rbp


push rbp
mov rbp, rsp
and rsp, -16
sub rsp, 30h

mov rcx, [g_pImmediateContext]
mov rax, [rcx]

mov edx, 1                 ; NumViewports
lea r8, [MyVP]             ; Address of the 6 floats

; STRIKE! (Use the index you found in the watch window)
call qword ptr [rax + 168h] 

add rsp, 30h
mov rsp, rbp
pop rbp




ret
InitDevice endp



Render proc








sub rsp,50h


mov rcx, [g_pImmediateContext]
mov rax, [rcx]
mov edx, 1                     ; NumViews = 1
lea r8, [g_pRenderTargetView]  ; ppRTView (Address of your pointer)
xor r9, r9                     ; pDepthStencilView = NULL


call qword ptr[rax+108h]



; 1. THE CLEAR (Wiping the Canvas)
mov rcx, [g_pImmediateContext]  ; JUMP 1: Get the Interface Pointer
mov rax, [rcx]                  ; JUMP 2: Get the V-Table (lpVtbl)
mov rdx, [g_pRenderTargetView]  ; Param 2: The View
lea r8,  ClearColor          ; Param 3: {0.1, 0.2, 0.4, 1.0}
call qword ptr [rax + 378h]     ; JUMP 3: Strike ClearRenderTargetView (Offset 378h)

; 2. THE PRESENT (Flipping the Switch)
mov rcx, [g_pSwapChain]         ; JUMP 1: Get SwapChain Pointer
mov rax, [rcx]                  ; JUMP 2: Get SwapChain V-Table
xor rdx, rdx                    ; Param 2: SyncInterval (0 = No VSync)
xor r8, r8                      ; Param 3: Flags (0)
call qword ptr [rax + 40h]      ; JUMP 3: Strike Present (Offset 40h)

add rsp, 50h




ret
Render endp

end
