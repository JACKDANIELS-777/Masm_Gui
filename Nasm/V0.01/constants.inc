; =========================================================================================
; Module Name:  constants.inc - Engine Constant Definitions & Component Layout Offsets
; Assemble:     Included via %include in main file
; =========================================================================================

%ifndef CONSTANTS_INC
%define CONSTANTS_INC

; --- Graphics Formats ---
%define DXGI_FORMAT_R8G8B8A8_UNORM 28

; ==============================
; MENU FLAGS - 240 KG EDITION
; ==============================
%define MF_STRING          0x00000000   ; normal text
%define MF_POPUP           0x00000010   ; submenu (File ->)
%define MF_SEPERATOR       0x00000800   ; ----------
%define MF_ENABLED         0x00000000   ; clickable
%define MF_GRAYED          0x00000001   ; dimmed
%define MF_DISABLED        0x00000002   ; gray + no click
%define MF_CHECKED         0x00000008   ; checkmark checked
%define MF_UNCHECKED       0x00000000   ; no check
%define MF_MENUBARBREAK    0x00000020   ; necolumn in menu bar
%define MF_MENUBREAK       0x00000040   ; new column in popup
%define MF_BITMAP          0x00000004   ; bitmap instead of text
%define MF_OWNERDRAW       0x00000100

; --- Core Win32 Message Types ---
%define WM_CREATE          0x0001
%define WM_DESTROY         0x0002
%define WM_SETFOCUS        0x0007
%define WM_KILLFOCUS       0x0008
%define WM_ERASEBKGND      0x0014
%define WM_PAINT           0x000F
%define WM_CLOSE           0x0010
%define WM_QUIT            0x0012
%define WM_GETDLGCODE      0x0087
%define WM_NCCALCSIZE      0x0083
%define WM_KEYDOWN         0x0100
%define WM_COMMAND         0x0111
%define WM_CTLCOLOREDIT    0x0133
%define WM_CTLCOLORSTATIC  0x0138
%define WM_CTLCOLORBTN     309
%define WM_LBUTTONDOWN     0x0201
%define WM_MOUSEMOVE       0x0200
%define WM_MEASUREITEM     0x0000002C
%define WM_DRAWITEM        0x0000002B

; --- Owner Draw State Flags ---
%define ODT_MENU           1
%define ODS_SELECTED       1
%define ODS_HOTLIGHT       0x0040 
%define ODS_GRAYED         0x0002
%define ODS_DISABLED       0x0004
%define ODS_CHECKED        0x0008

; --- Hex Color Schemes ---
%define CLR_RED            0x000000FF
%define CLR_BLUE           0x00FF0000
%define CLR_WHITE          0x00FFFFFF
%define CLR_BLACK          0x00000000

; --- Menu Modifications ---
%define MIIM_STRING        0x00000001
%define MIIM_BITMAP        0x00000002
%define MIIM_CHECKMARK     0x00000004
%define MIIM_FTYPE         0x00000100
%define MIIM_STATE         0x00000008
%define MFS_CHECKED        0x00000008
%define MFS_UNCHECKED      0x00000000
%define MIM_BACKGROUND     0x00000002
%define MIM_APPLYTOSUBMENUS 0x80000000

; --- Structural Windows Layout Properties ---
%define WS_VISIBLE         0x10000000
%define WS_CHILD           0x40000000
%define WS_VSCROLL         0x00200000

; --- Edit Box Style Customization Flags ---
%define ES_MULTILINE       0x0004
%define ES_AUTOVSCROLL     0x0040
%define ES_NOHIDESEL       0x0100

; --- Graphics Object / Font Primitives ---
%define PS_SOLID           0x0000
%define FW_BOLD            0x02BC
%define DEFAULT_CHARSET    0x0001
%define OUT_DEFAULT_PRECIS 0x0000
%define CLIP_DEFAULT_PRECIS 0x0000
%define DEFAULT_QUALITY    0x0000
%define DEFAULT_PITCH      0x0000

; --- Stock Object Brushes and Fonts ---
%define WHITE_BRUSH        0
%define LTGRAY_BRUSH       1
%define GRAY_BRUSH         2
%define DKGRAY_BRUSH       3
%define BLACK_BRUSH        4
%define NULL_BRUSH         5   ; Hollow background brush hook
%define WHITE_PEN          6
%define BLACK_PEN          7
%define NULL_PEN           8
%define OEM_FIXED_FONT     10
%define ANSI_FIXED_FONT    11
%define SYSTEM_FONT        13
%define DEFAULT_GUI_FONT   17

; --- Direct3D 11 Render Target Index Maps (ID3D11DeviceContext Virtual Layouts) ---
%define IDX_Context_Release                 2
%define IDX_Context_IASetInputLayout        11
%define IDX_Context_IASetVertexBuffers      12
%define IDX_Context_IASetIndexBuffer        13
%define IDX_Context_IASetPrimitiveTopology  24
%define IDX_Context_VSSetShader             18
%define IDX_Context_PSSetShader             9
%define IDX_Context_PSSetSamplers           10
%define IDX_Context_OMSetBlendState         47
%define IDX_Context_OMSetRenderTargets      33
%define IDX_Context_RSSetViewports          44
%define IDX_Context_ClearRenderTargetView   50
%define IDX_Context_Draw                    8
%define IDX_Context_DrawIndexed             12

; --- DXGI Swap Chain Virtual Layout Tables ---
%define IDX_SwapChain_Release               2
%define IDX_SwapChain_Present               8
%define IDX_SwapChain_GetBuffer             9
%define IDX_SwapChain_ResizeBuffers         13

; --- Direct3D 11 Hardware Creator Resource Allocations (ID3D11Device) ---
%define IDX_Device_CreateRenderTargetView   9
%define IDX_Device_CreateTexture2D          5
%define IDX_Device_CreateBuffer             3
%define IDX_Device_CreateVertexShader       12
%define IDX_Device_CreatePixelShader        15
%define IDX_Device_CreateInputLayout        11

; --- SDK Core Dependencies ---
%define D3D11_SDK_VERSION                  0x0007
%define D3D_DRIVER_TYPE_HARDWARE           1

; --- Core Library Dynamic Procedure Links ---
extern DefWindowProcA
extern RegisterClassExA
extern GetModuleHandleA
extern BeginPaint
extern EndPaint
extern FillRect
extern GetClientRect
extern PostQuitMessage
extern InflateRect
extern ColorBtnBorder
extern ColorBtnRect
extern GetWindowLongPtrA
extern SetWindowLongPtrA
extern SetWindowPos
extern GetWindowRect
extern GetParent
extern ScreenToClient
extern ClientToScreen

%endif ; CONSTANTS_INC
