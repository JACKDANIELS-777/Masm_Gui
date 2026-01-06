
; ==============================
; MENU FLAGS - 240 KG EDITION
; ==============================
MF_STRING      EQU 000000000h   ; normal text
MF_POPUP       EQU 000000010h   ; submenu (File ->)
MF_SEPERATOR   EQU 00000800h    ; ----------
MF_ENABLED     EQU 000000000h   ; clickable
MF_GRAYED      EQU 000000001h   ; dimmed
MF_DISABLED    EQU 000000002h   ; gray + no click
MF_CHECKED     EQU 000000008h   ; checkmark checked
MF_UNCHECKED   EQU 000000000h   ; no check
MF_MENUBARBREAK EQU 000000020h  ; necolumn in menu bar
MF_MENUBREAK   EQU 000000040h   ; new column in popup
MF_BITMAP      EQU 000000004h   ; bitmap instead of text
WM_CREATE       equ 0001h
WM_DESTROY      equ 0002h
WM_PAINT        equ 000Fh
WM_CLOSE        equ 0010h
WM_QUIT         equ 0012h
WM_KEYDOWN      equ 0100h
WM_COMMAND equ 0111h
WM_LBUTTONDOWN  equ 0201h
WM_MOUSEMOVE    =  200h
MF_OWNERDRAW equ 100h
WM_CTLCOLORSTATIC equ 138h
WM_ERASEBKGND equ 14h
WM_MEASUREITEM EQU 00000002Ch
WM_DRAWITEM    EQU 0000002Bh
ODT_MENU       EQU 1
ODS_SELECTED   EQU 1
ODS_HOTLIGHT equ 40h 
ODS_GRAYED      equ 0002h
ODS_DISABLED    equ 0004h
ODS_CHECKED     equ 0008h

CLR_RED      EQU 000000FFh
CLR_BLUE     EQU 00FF0000h
CLR_WHITE    EQU 00FFFFFFh
CLR_BLACK    EQU 00000000h

WM_NCCALCSIZE equ 83h 


; constants.inc – ADD THIS
MIIM_STRING    EQU 000000001h
MIIM_BITMAP    EQU 000000002h
MIIM_CHECKMARK EQU 000000004h
MIIM_FTYPE     EQU 000000100h
MIIM_STATE     EQU 000000008h
MFS_CHECKED    EQU 000000008h
MFS_UNCHECKED  EQU 000000000h
MIM_BACKGROUND equ 2h
MIM_APPLYTOSUBMENUS equ 80000000h


WS_VISIBLE equ 10000000h
WS_CHILD equ 40000000h


ES_MULTILINE equ 4h
ES_AUTOVSCROLL equ 40h
WM_CTLCOLOREDIT equ 133h

PS_SOLID equ 0h
FW_BOLD equ 2BCh
DEFAULT_CHARSET equ 1h
OUT_DEFAULT_PRECIS equ 0h
CLIP_DEFAULT_PRECIS equ 0h
DEFAULT_QUALITY equ 0h
DEFAULT_PITCH equ 0h


WHITE_BRUSH     equ 0
LTGRAY_BRUSH    equ 1
GRAY_BRUSH      equ 2
DKGRAY_BRUSH    equ 3
BLACK_BRUSH     equ 4
NULL_BRUSH      equ 5   ; <--- The "Hollow" one you need for labels
WHITE_PEN       equ 6
BLACK_PEN       equ 7
NULL_PEN        equ 8
OEM_FIXED_FONT  equ 10
ANSI_FIXED_FONT equ 11
SYSTEM_FONT     equ 13
DEFAULT_GUI_FONT equ 17

; ==========================================
; Window Style Constants
; ==========================================
WS_CHILD        equ 40000000h
WS_VISIBLE      equ 10000000h
WS_VSCROLL      equ 00200000h

; ==========================================
; Edit Control Style Constants
; ==========================================
ES_MULTILINE    equ 0004h
ES_AUTOVSCROLL  equ 0040h
ES_NOHIDESEL    equ 0100h
WM_CTLCOLORBTN equ 309
