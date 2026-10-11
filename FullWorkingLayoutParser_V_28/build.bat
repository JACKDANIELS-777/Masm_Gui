@echo off
setlocal
cd /d "%~dp0"

rem Find ml64/link: if not already on PATH, load the Visual Studio x64 build environment
where ml64 >nul 2>&1
if errorlevel 1 (
  for /f "usebackq delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
)
if defined VSDIR call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" >nul
cd /d "%~dp0"
where ml64 >nul 2>&1 || (echo ml64 not found. Install Visual Studio with "Desktop development with C++". & exit /b 1)

for %%f in (*.asm) do ml64 /nologo /c %%f || exit /b 1
link /nologo /SUBSYSTEM:WINDOWS /ENTRY:WinMain /OUT:MasmGui.exe *.obj kernel32.lib user32.lib gdi32.lib msimg32.lib d3d11.lib dxguid.lib || exit /b 1
echo Built MasmGui.exe
