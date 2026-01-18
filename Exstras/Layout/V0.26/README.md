# 🏛️ Masm_Gui Layout Engine (v0.26)
### *The Ghost Manager & Entity Reroute System*

This folder contains the modular layout logic for spawning hardware-accelerated, transparent UI elements directly onto the desktop. The engine utilizes a custom string-based parser to birth "Entities" into a full-screen, invisible logic anchor.

## 📜 LayoutStr Syntax Guide

The `LayoutStr` is a comma-delimited instruction set that defines the window hierarchy, coordinates, and visual styles.

### 🔘 Core Tags (Identifiers)
* **`Y!` (Ghost Manager)**:  *! delays execution till on hover of the main wnd.
* **`Y` (Standard Entity)**: Spawns a visible UI container ie custom dialog window.
* **`ZA` (Pulse)**: Adds the control *A to the previos window. 
* **`ZM` (Traffic Manager)**: Initializes the high-frequency data plotting engine for the Traffic Graph HUD.

### 📍 Coordinate Mapping
`TAG, ID, X, Y, W, H, ...`  Last part is the string for the foreground text.
* **X, Y**: Absolute screen coordinates. Since the Ghost Manager is snapped to `0,0`, these coordinates are 1:1 with the monitor pixels.
* **W, H**: Width and Height in pixels.

### 🎨 Style Payloads `{...}`
Styles are passed in a brace-encapsulated format to define the "Silicon Aesthetic":
* **`f:`**: Font ID Selection.
* **`b:`**: Background Color / Brush ID.
* **`s:`**: Inflates rect bigger or smaller. Above a certain threshold it deflates the control.
* **`r`** : Makes a round rectangle.

### 🔗 Nesting & Hierarchy
* **`( ... )`**: Parenthesis define a child relationship. Any tag inside the brackets is automatically linked to the preceding parent handle.
* **`{ ..:. }**: Sets the atrributes / styles of the control.
* **`\c`**: Terminator/Separator for the internal string parser.

---


## 🛰️ The "One-Time Ping" Reroute
Starting in **v0.26**, entities are decoupled from the main engine logic has been updated to move away from the Slow Win api to a more custom self built API.
The orginal controls and code will still work it mereley acts as a add on and hopefully a full fledged fix.

## 🛠️ Implementation Example
```asm
; Example LayoutStr for a Ghost Plane with a Floating Button and Traffic HUD
LayoutStr db "Y!,0,0,0,1920,1080,{s:92000000h,}" ; Delayed
          db "(Z,1,10,10,100,100,{b:10,}Btn1,\c)"   ; Add to the delayed window
          db "ZM,2,50,50,400,200,{f:10,b:17,}10,\c",0 ; Adds the Custom Z button to the Window Manager
