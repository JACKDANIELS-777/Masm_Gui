# 🏛️ TrenchScript Engine
### 100% x86-64 Assembly

This engine utilizes an 8-byte "Trench" alignment. Every command and argument occupies exactly one 8-byte block to ensure 1-cycle fetch performance and zero-bloat execution.

## ⚔️ The Command Arsenal

| Command  | Arg 1       | Arg 2       | Description |
| :------- | :---------- | :---------- | :---------- |
| `StCl    ` | id   | -    Hex Color       | **Strike Color**: Sets the GDI background color. |
| `MsgB    ` | String* | -           | **Message Box**: Triggers a Win32 popup strike. |
| `JumpF   ` | Blocks      | -           | **Jump Forward**: Leaps the pointer ahead in the Trench. |
| `JumpB   ` | Blocks      | -           | **Jump Backward**: Loops the execution to a previous block. |
| `Sleep   ` | Millis      | -           | **Rest**: Suspends execution for X ms. |
| `SetV    ` | Index       | Value       | **Set Variable**: Stores a "Subjective" value in VMEM. |
| `GetD    ` | Index       | -           | **Get Data**: Loads VMEM value into Virtual Register 0. |
| `PrintV  ` | Index       | -           | **Audit**: Sends variable content to the Debug Window. |
| `CmpV    ` | Target Val  | Skip Count  | **Gatekeeper**: If VReg0 != Target, skip X blocks. Compares to Vregister 0|

## 🧠 Memory Map (Subjective Alignment)
The engine uses a mirrored memory strategy where `VREG_BASE` and `VMEM` share the same truth for zero-latency access. 

* **Block Size**: 8 Bytes (dq)
* **VMEM Slots**: 100
* **Data Type**: Polymorphic/Subjective ASCII

**Example**  
align 8
    TrenchScriptStr:
        db "SetV    "
        db "0       "
        db "100     "
        db "GetD    "
        db "0       "
        db "CmpV    "
        db "10      "
        db "2       "
        db "PrintV  "
        db "0       "
        db 0 
