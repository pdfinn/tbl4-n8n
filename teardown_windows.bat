@echo off
REM Double-click this file to uninstall on Windows.
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "teardown_windows.ps1"
echo.
pause
