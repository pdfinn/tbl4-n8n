@echo off
REM Double-click this file to run setup on Windows.
REM Spawns PowerShell in a fresh classic console window, bypassing the
REM Windows 11 Terminal ghost-window rendering bug.
cd /d "%~dp0"
start "Tarkas Brainlab IV - n8n Setup" "%SystemRoot%\System32\conhost.exe" powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup_windows.ps1"
