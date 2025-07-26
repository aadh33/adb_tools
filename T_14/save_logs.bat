@echo off
setlocal

REM Get timestamp in format: YYYY-MM-DD_HH-MM-SS
for /f %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set timestamp=%%i

REM Set output log filename
set logfile=logcat_%timestamp%.txt

REM Pull logs and save
adb logcat -d > "%logfile%"

echo Log saved as %logfile%
pause
