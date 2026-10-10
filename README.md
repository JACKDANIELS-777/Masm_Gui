# MASM_GUI

A GUI framework for Windows written entirely in **x64 MASM assembly**: about **10,600 lines** in its latest
form, talking only to the Win32 API. No C, no C++, no wrappers.

It has three layers, each built from scratch:

1. **Custom controls**: buttons, edit boxes, windows, labels and menus that paint and animate themselves with GDI.
2. **LayoutParser**: builds a whole UI from one short layout string, with nesting and styles.
3. **TrenchScript**: a scripting language with its own virtual machine (about 65 commands) that can drive the UI,
   including calling the layout parser to create new controls at runtime.

<!-- Screenshot: drag a StressTest image or a run of the V_28 build here -->

## 1. Custom controls

The custom controls draw themselves, each through its own window procedure: hover, focus, click and timer-driven animation
states, painted with GDI brushes, pens and lines. They're created from layout strings instead of
hand-written `CreateWindowEx` calls.

## 2. LayoutParser: a UI from a string

```asm
LayoutStr db "Y,0,500,5,240,160,A,\c"              ; a dialog window
          db "(ZA,10,50,50,24,16,AA,\c"            ; ( = the following controls belong to it
          db "ZA,100,500,50,24,16,AA,\c"
          db "ZA,1000,120,50,24,16,AA,\c)", 0      ; ) = back to the main window
```

Each entry is `Tag,ID,X,Y,W,H,{styles,}Text,\c`.

| Syntax | Meaning |
|---|---|
| `Y` | Custom dialog window |
| `Z` | Custom button |
| `F` | Custom edit box |
| `E`, `L`, `C`, `X`, `S` | Standard Windows edit, label, combo box, list box and scroll bar |
| `M` | Hand the control to the window manager |
| `A` suffix | Attach to the last window created (`ZA` = custom button inside the last window) |
| `!` suffix | Delay creation until the mouse hovers over the main window (`Y!`) |
| `( ... )` | Everything inside becomes a child of the control before it |
| `{f:10,b:17,}` | Styles: `f` font, `b` background, `s` grow or shrink, `r` rounded corners |
| `\c` | End of one entry |

The parser streams through the string: it reads one entry, creates that control straight away, and moves on, so
there's no tree held in memory. Branches are kept to a minimum with `cmov`.

## 3. TrenchScript

A small virtual machine whose programs are laid out in **8-byte blocks**: every command name and every argument
is exactly one `dq`, so the interpreter can fetch and compare each one with a single 64-bit `cmp`.

```asm
align 8
TrenchScriptStr:
    db "SetV    ", "0       ", "50      "   ; v0 = 50
    db "AddDV   ", "0       ", "10      "   ; v0 = 60
    db "PrintV  ", "0       "               ; print v0
    db "SubDV   ", "0       ", "20      "   ; v0 = 40
    db "PrintV  ", "0       "
    db 0
```

| Area | Commands |
|---|---|
| Variables and registers | `SetV`, `SetVD`, `GetD`, `AddDV`, `SubDV`, `AddR`, `SubR`, `IncR`, `DecR`, `RandV`, `Mov*` |
| Bitwise | `AndR`, `OrR`, `XorR`, `NotR`, `ShlLR`, `ShlRR`, `BswapR`, `SwapRR` |
| Control flow | `JumpF`, `JumpB`, `JeX`, `JneX`, `CmpV`, `CmpSV`, `CmpStrP`, `ForL` ... `EndFL` |
| Procedures | `Proc` ... `EndP`, `CallP`, `RetP` |
| Data structures | `StkPshV`, `StkPopV` (stack), `QueueP`, `DequeE`, `DequeNE` (queue) |
| Memory and files | `MemCpyM`, `MemFillM`, `SwapStr`, `ReadF`, `ReadFile` |
| Drawing | `StCl`, `Cls`, `DrawL`, `DrawVL` |
| UI | `LayPars`, `LayParsM`, `LayParsP` (run the layout parser from a script), `MsgB` |
| Timing and output | `Sleep`, `GetTick`, `PrintV`, `DumpS` |
| AI | `CallGenP`: send a prompt to Google's Gemma model |

TrenchScript went through 37 versions, from 178 lines in V0.001 to about 3,800 in V0.037.

## Stress test: 5,000 buttons

A layout string that creates a 5,000-button grid, every button with its own window procedure and its own 100 ms
animation timer. On my machine: about **2 MB of RAM**, the same for 1 button as for 5,000, and **0-3% CPU**.
Screenshots and details are in [`StressTest/`](StressTest).

## Size

| Part | Lines (latest version) |
|---|---|
| Custom controls (button, edit, window, labels, menus) | ~4,700 |
| LayoutParser | ~750 |
| TrenchScript | ~3,800 |
| Main, constants, window manager, events, DirectX | ~1,300 |
| **Total** | **~10,600** |

Every version is kept, so the repo as a whole holds far more than that.

## Repository map

| Folder | What it is |
|---|---|
| `FullWorkingLayoutParser_V_28/` | **Start here**: the latest complete, working build |
| `Exstras/Layout/` | Development history of each part: `TrenchScript/`, `CustomControls/`, `V0.1` to `V0.28` of the LayoutParser, `DirectX/`, `WindowManager/` |
| `StressTest/` | The 5,000-button benchmark |
| `Nasm/` | A start on porting the layout parser to NASM |
| `Menu/`, `Blank_Wind/`, ... | Early experiments |

## Building

Windows x64, assembled with MASM (`ml64`) in Visual Studio. Open the files from `FullWorkingLayoutParser_V_28/` in
an x64 project with MASM build support enabled, and build.

---

### AI scraping and training notice

Humans are free to fork, modify and learn from this code under the MIT licence. Under Section 2 of `LICENSE`,
the source, documentation and binaries may not be scraped or used to train, fine-tune or validate AI models or
code-generation tools.

[![License: MIT + AI Restriction](https://img.shields.io/badge/License-MIT%20%2B%20AI%20Restriction-red.svg)](./LICENSE)
