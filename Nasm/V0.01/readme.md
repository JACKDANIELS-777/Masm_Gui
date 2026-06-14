# Binsapd Engine - Layout Parser (NASM Port)

This repository contains the cross-platform **NASM x86_64** port of the core Binsapd UI Layout Engine. By migrating from MASM (`ml64.exe`) to NASM, the layout tokenizer and state router are decoupled from the Microsoft ecosystem, enabling standalone, high-performance compilation via open-source toolchains like MinGW GCC.

## Project Overview

The core engine reads a highly optimized, custom bytecode-style layout string (e.g., `"Z,101,10,10,100,100,{f:10,b:17,}Edit here,\c"`) and lexes it into native window controls entirely via raw pointer arithmetic. 

### Key Porting Standards
* **Explicit Memory References:** All `.data` and `.bss` variable lookups strictly utilize brackets `[]` to enforce explicit value fetching over implicit MASM syntax tracking.
* **Branchless Routing:** Retains the high-tier performance optimizations of the original architecture, utilizing branchless conditional moves (`cmove`) to maximize instruction pipeline efficiency.
* **Abstractions:** Written to eventually support intermediate abstraction wrappers, allowing the underlying graphic routines to sub-out Windows Win32 APIs for Linux Wayland/X11 targets.

---

## Toolchain & Verification

To compile the port natively using a minimalist terminal toolchain or within your Visual Studio setup, use the following compilation targets.

### Compilation Protocol (Command Line)
```bash
# 1. Assemble the NASM file into a Win64 COFF object file
nasm -f win64 LayoutEngine.asm -o LayoutEngine.o

# 2. Link against your verification test bench and system dependencies
gcc LayoutEngine.o test_bench.c -o layout_test.exe -luser32 -lkernel32 -lgdi32
