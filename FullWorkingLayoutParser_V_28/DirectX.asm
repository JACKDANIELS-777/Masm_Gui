    ;The below is almost finished
    ;It needs an update because the offsets mayb vary between machines so a different measure has to be taken.

    include constants.inc
    includelib d3d11.lib
    includelib dxguid.lib

    GUID STRUCT
        Data1    DWORD ?
        Data2    WORD  ?
        Data3    WORD  ?
        Data4    BYTE  8 DUP(?)
    GUID ENDS

    EXTERN IID_ID3D11Texture2D:GUID
    EXTERN IID_IDXGIFactory:GUID
    EXTERN IID_IDXGISwapChain:GUID
    EXTERN IID_ID3D11Device:GUID

    .data
    extern hwndMain : qword
    extern D3D11CreateDeviceAndSwapChain:proc

    ALIGN 8
    g_pSwapChain dq 0
    g_pd3dDevice dq 0
    g_pImmediateContext dq 0
    g_pRenderTargetView dq 0

    ALIGN 8         
    pBackBuffer dq 20 dup(0) 
    pBackBufferptr DQ pBackBuffer 
    dq 0

    ALIGN 16
    ClearColor dd 3DCCCCCDh, 3E4CCCCDh, 3ECCCCCDh, 3F800000h ; 0.1, 0.2, 0.4, 1.0

    sd db 72 dup(0)

    ALIGN 16
    MyVP REAL4 0.0, 0.0, 800.0, 600.0, 0.0, 1.0 ; X, Y, Width, Height, MinDepth, MaxDepth

    .code 

    InitDevice proc
        mov dword ptr [sd + 0], 800
        mov dword ptr [sd + 4], 600
        mov dword ptr [sd + 16], 28
        mov dword ptr [sd + 28], 1
        mov dword ptr [sd + 36], 20h
        mov dword ptr [sd + 40], 2
        mov rax, hwndMain
        mov qword ptr [sd + 48], rax
        mov dword ptr [sd + 56], 1
        mov dword ptr [sd + 60], 0
        mov dword ptr [sd + 64], 2

        sub rsp, 80h
        mov rcx, 0
        mov rdx, 1
        mov r8, 0
        mov r9, 0
        mov qword ptr [rsp + 20h], 0
        mov qword ptr [rsp + 28h], 0
        mov qword ptr [rsp + 30h], 7h
        lea rax, sd
        mov qword ptr [rsp + 38h], rax
        lea rax, g_pSwapChain
        mov qword ptr [rsp + 40h], rax
        lea rax, g_pd3dDevice
        mov qword ptr [rsp + 48h], rax
        xor rax, rax
        mov qword ptr [rsp + 50h], rax
        lea rax, g_pImmediateContext
        mov qword ptr [rsp + 58h], rax
        call D3D11CreateDeviceAndSwapChain
        add rsp, 80h

        sub rsp, 50h
        mov rcx, [g_pSwapChain]
        mov rax, [rcx]
        xor rdx, rdx
        lea r8, IID_ID3D11Texture2D
        lea r9, [rsp + 30h]
        call qword ptr [rax +        (IDX_SwapChain_GetBuffer * 8)      ];             48h]
        mov rax, [rsp + 30h]
        mov [pBackBuffer], rax
        add rsp, 50h

        push rbp
        mov rbp, rsp
        and rsp, -16
        sub rsp, 30h
        mov rcx, [g_pd3dDevice]
        mov rax, [rcx]
        mov rdx, [pBackBuffer]
        xor r8, r8
        lea r9, [g_pRenderTargetView]
        call qword ptr [rax + (IDX_Device_CreateRenderTargetView *8)];;;48h] ;; 48
        add rsp, 30h
        mov rsp, rbp
        pop rbp

        mov rcx, [pBackBuffer]
        mov rax, [rcx]
        sub rsp, 20h
        call qword ptr [rax +       (IDX_Context_Release * 8)  ]                    ;10h]
        add rsp, 20h



    
        push rbp
        mov rbp, rsp
        and rsp, -16
        sub rsp, 40h
        mov rcx, [g_pImmediateContext]
        mov rax, [rcx]
        mov edx, 1
        lea r8, [g_pRenderTargetView]
        xor r9, r9
        call qword ptr [rax +   (IDX_Context_OMSetRenderTargets * 8)]       ;108h]
        add rsp, 40h
        mov rsp, rbp
        pop rbp


    
        push rbp
        mov rbp, rsp
        and rsp, -16
        sub rsp, 30h
        mov rcx, [g_pImmediateContext]
        mov rax, [rcx]
        mov edx, 1
        lea r8, [MyVP]
        call qword ptr [rax + (IDX_Context_RSSetViewports * 8)];168h]
        add rsp, 30h
        mov rsp, rbp
        pop rbp
        ret


    InitDevice endp

    Render proc

    

        sub rsp, 50h
       

        mov rcx, [g_pImmediateContext]
    mov rax, [rcx]
    mov edx, 1
    lea r8, [MyVP]
    call qword ptr [rax +     (IDX_Context_RSSetViewports * 8)]      ;160h] ; RSSetViewports
   

        mov rcx, [g_pImmediateContext]
        mov rax, [rcx]
        mov rdx, [g_pRenderTargetView]
        lea r8, ClearColor
        call qword ptr [rax + (IDX_Context_ClearRenderTargetView * 8)];190h]

        mov rcx, [g_pSwapChain]
        mov rax, [rcx]
        xor rdx, rdx
        mov rdx,1
        xor r8, r8
  
        call qword ptr [rax + (IDX_SwapChain_Present * 8)]            ;40h]
        add rsp, 50h
        ret
    Render endp

    end
