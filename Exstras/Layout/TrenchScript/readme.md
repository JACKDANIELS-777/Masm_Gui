# 🏛️ TrenchScript Engine
### 100% x86-64 Assembly

This engine utilizes an 8-byte "Trench" alignment. Every command and argument occupies exactly one 8-byte block to ensure 1-cycle fetch performance and zero-bloat execution.

## ⚔️ The Command Arsenal

| Command  | Arg 1       | Arg 2       | Description |
| :------- | :---------- | :---------- | :---------- |
| `StCl    ` | id          | Hex Color   | **Strike Color**: Sets the GDI background color. |
| `MsgB    ` | String* | -           | **Message Box**: Triggers a Win32 popup strike. |
| `JumpF   ` | Blocks      | -           | **Jump Forward**: Leaps the pointer ahead in the Trench. |
| `JumpB   ` | Blocks      | -           | **Jump Backward**: Loops the execution to a previous block. |
| `Sleep   ` | Millis      | -           | **Rest**: Suspends execution for X ms. |
| `SetVM   ` | Index       | Value       | **Set Variable**: Stores a "Subjective" value in VMEM. |
| `GetD    ` | Index       | -           | **Get Data**: Loads VMEM value into Virtual Register 0. |
| `PrintV  ` | Index       | -           | **Audit**: Sends variable content to the Debug Window. |
| `CmpV    ` | Target Val  | Skip Count  | **Gatekeeper**: If VReg0 != Target, skip X blocks. |
| `SetV    ` | Index REG   | Value (Dec) | **Set Variable**: Converts ASCII to Binary and stores in VREG. |
| `AddDV   ` | Index REG   | Value (Dec) | **Reinforce**: Adds decimal value directly to VREG slot. |
| `SubDV   ` | Index REG   | Value (Dec) | **Attrition**: Subtracts decimal value directly from VREG slot. |
| `CmpSV   ` |  Index REG  |Target Val   | Skip Count  | **Gatekeeper**: If VReg != Target, skip X blocks. |
| `RandV   ` | Index REG  |  Min  | MAX   | RNG |
| `Cls     ` |  Clear Screen |

## 🧠 Memory Map (Binary Alignment)
The engine uses a mirrored memory strategy where `VREG_BASE` and `VMEM` share the same truth for zero-latency access. 

* **Block Size**: 8 Bytes (dq)
* **Data Type**: Raw 64-bit Binary Integers (Post-Conversion)
* **Boundary Safety**: `PrintV` utilizes a temporary `rcx+8` null-swap to ensure zero corruption of adjacent slots.



## 📜 Example: The Subtractive Loop
```Masm
align 8
    TrenchScriptStr:
        db "SetV    "    ; Slot Setup
        db "0       "    ; Slot 0
        db "50      "    ; Start at 50
        
        db "AddDV   "    ; Reinforcement
        db "0       "
        db "10      "    ; 50 + 10 = 60
        
        db "PrintV  "    ; Initial Audit
        db "0       "
        
        db "SubDV   "    ; Attrition
        db "0       "
        db "20      "    ; 60 - 20 = 40
        
        db "PrintV  "    ; Final Audit
        db "0       "
        
        db 0             ; End Strike
