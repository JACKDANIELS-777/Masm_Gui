# MASM_GUI: Exploring the Win32 API through x64 Assembly

MASM_GUI is a project focused on developing a 100% Assembly-based GUI framework. The goal is to move away from high-level abstractions and explore the limits of the Windows GDI and User32 subsystems using raw x64 instructions.

By managing the stack, registers, and memory manually, this project serves as a roadmap for building low-latency, state-driven UI components without the overhead of C/C++ runtimes.

---

## 🏗️ Architectural Exploration

The project currently focuses on several core "low-level" concepts:

* **RBP-Relative Stack Management:** Using a stable stack frame anchor to ensure O(1) access to local RECT structures and PAINTSTRUCT data during high-frequency paint cycles.
* **HDC Register Persistence:** Pinning the Device Context to the R12 register to minimize memory fetches and maximize rendering throughput.
* **Unified Message Dispatching:** Consolidating component behavior (Hover, Focus, Click, Timer) into a singular, optimized `BtnProc` to study message-loop efficiency.
* **GDI Lifecycle Control:** Manual tracking of GDI objects (Brushes, Pens) to ensure absolute memory integrity and zero handle exhaustion.

---

## 🎬 Procedural UI & Animations

One of the project's primary areas of development is procedural animation—calculating UI physics in real-time rather than using pre-baked assets.

* **State-Based Rendering:** Utilizing a 64-byte data vector to track animation "points" and coordinates across frames.
* **Animation 5 (Mirror Sweep):** A recent discovery in the codebase where boundary-checking logic creates a "Ping-Pong" width transition ($-><-$ then $<-->$).
* **Vector Logic:** Exploring `MoveToEx` and `LineTo` for custom vector-based UI borders and internal wireframes.

---

## 🛠️ Development Philosophy

This project is built on the belief that GUI frameworks can be both powerful and lean.

* **100% Assembly:** No external C libraries or high-level wrappers.
* **Logic-First Growth:** The engine has grown a bit.
* **Future Framework Goals:** Transitioning from individual component procs toward a modular system where any developer can register a custom MASM component with a single call via a string or file.

---

## 📈  Status (Jan 2026)
* **Status:** V0.20 (Active Alpha)
* **Development Velocity:** 61 commits in the last 7 days.
* **Core Focus:** Enhancing the Procedural Animation Engine and State Transition stability.

---
*Developed as a contribution to the x64 Assembly and Low-Level community.*
