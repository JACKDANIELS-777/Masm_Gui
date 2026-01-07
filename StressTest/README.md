# 🚀 MASM_Gui Layout Parser


## ⚡ The 500-Button "Flash" Benchmarks

While modern frameworks would lag, freeze, or consume hundreds of megabytes to render this many elements, this MASM engine holds a perfect performance line.

* **RAM Usage:** **~2 MB (Verified Flatline)**. Even with 500 independent window handles, memory does not climb.
* **CPU Usage:** **0% - 3%**. Your math is effectively free; the small blip is simply the Windows DWM (Desktop Window Manager) redrawing pixels.
* **Elements:** 500 Independent, fully animated windows.
* **Timers:** 500 Active Timers firing at **100ms** intervals with zero stutter.

## 🛠️ Technical Superpowers

### 1. Streaming Layout Parser
Most apps load massive XML/JSON trees into memory, causing "heap bloat." This engine uses a **Streaming Parser** with a **500byte revolving buffer** for 500 buttons. The buffer size is all dependant on the size of input  strings longer strings bigger buffer. It reads one button's data, creates the window immediately, and moves the buffer for the next one. This allows for 2mb ram usage for 1 - 500 Buttons. The 2mb ram is the same for 1 button as is for 500. The ram usage is negligible.

### 2. L1 Cache Mastery
The `BtnProc` and animation logic are written to stay "hot" in the **L1 Instruction Cache**. By the time the CPU processes the first few buttons, the logic is pre-loaded into the processor's fastest memory, allowing all 500 updates to execute in a single micro-burst.

### 3. Branchless Animation Logic
By leveraging `cmov` (Conditional Move) instructions, the engine ensures the CPU pipeline never stalls during state transitions. This prevents the "jitter" common in high-level languages and keeps the "Flash" effect lightning-fast.

## 🧪 Stress Test Implementation
The `StressTest` code utilizes a high-density `LayoutStr` to generate a dense 20x25 grid of buttons (IDs 1001-1500).

* **Logic:** Each button calculates its own visual state and animation independently.
* **Efficiency:** Uses a recycled **100-byte stack frame** which only around 50 bytes are used for parsing, keeping the stack clean and data "hot" for the CPU.
* **Visuals:** A digital wall of 500 buttons that move in near-perfect unison. Each button animation is independant of the others. As each Button has its own BtnProc that handles the animation. Above they do use the same animation type the timing does obviously differ.

## 📁 Repository Highlights
* **`Layout.asm`**: Contains the high-density string parser and streaming logic.
* **`CustomClasses.asm`**: The raw GDI painting and animation logic.
* **`/StressTest`**: The 500-button layout implementation for performance testing.

---
**"Modern software is slow because developers forgot how hardware works. This repo is the cure."**
