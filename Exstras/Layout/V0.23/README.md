# 🏆 LayoutParser x64 Layout Engine (V0.23)
### Masm Gui LayoutParser

LayoutParser V0.23 is a data-driven UI engine built in pure x64 assembly, designed for extreme efficiency with a **1.4 MB memory footprint**. Unlike standard Windows frameworks, LayoutParser uses a **Character-Based State Machine** to parse and execute simple to future complex UI layouts from simple, comma-delimited strings.

## 🚀 What makes V0.23 "Different"?
* **Hierarchical Scoping (NEW)**: Introduced the `(` and `)` syntax to define nested control groups.
* **Zero-Branch Decision**: Uses the `cmove` instruction to decide whether to update the handle cursor or stay locked to the parent, keeping the CPU pipeline fast.
* **Recursive Instruction Tape**: By leveraging a "Backwards-Looking" parser, the engine swaps opcodes in memory (e.g., swapping `A` for `Z`) to apply custom styles without adding new code branches.
* **Zero-Latency Parenting**: Anchors children to a parent window with zero branching overhead, ensuring massive layouts load instantly.
* **(Not Yet implemented fully.)Threaded Control Spawning**: Offloads control creation to background threads to keep the Main UI Thread 100% responsive.

## 🛠️ Syntax Overview
The engine parses a command string with the following syntax:
`"Type,ID,X,Y,W,H,Text,\c"`

### Opcodes in V0.23
| Opcode | Description | Logic Branch |
| :--- | :--- | :--- |
| **`Y`** | Custom DLG | Creates the parent container and sets the initial anchor. |
| **`ZA`** | CustomButton Add | A recursive "Add" command that adds CustomButton to the lastwnd. |
| **`(`** | Start Scope | Locks the `hLastWnd` to the current handle, pinning all subsequent controls to this parent. |
| **`)`** | End Scope | Releases the lock and resets the context focus back to `hwndMain`. |

## 📖 Example Layout
```asm
LayoutStr db "Y,0,500,5,240,160,A,\c"             ; Parent DLG
          db "(ZA,10,50,50,24,16,AA,\c"           ; Nested Custom Button 1
          db "ZA,100,500,50,24,16,AA,\c"          ; Nested Custom Button 2
          db "ZA,1000,120,50,24,16,AA,\c)", 0     ; Nested Button 3 & Close Scope
```
### Side Note A just gets appened to control ie. B for regular static Button becomes BA,.... etc. Works for all existing controls
