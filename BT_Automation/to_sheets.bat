@echo off
REM ==== CONFIGURATION ====
REM Tap coordinates for your Bluetooth device (adjust if needed)
set TAP_X=529
set TAP_Y=1101
REM If you can parse BT version from dumpsys, do so; otherwise, edit below:
set BT_VERSION=5.2

REM ==== 1. Gather Device Info ====
for /f "delims=" %%a in ('adb shell getprop ro.product.model') do set DEVICE=%%a
for /f "delims=" %%a in ('adb shell getprop ro.build.version.release') do set ANDROID_VERSION=%%a

REM ==== 2. Reset Bluetooth and Open Settings ====
adb shell svc bluetooth disable
timeout /t 2 >nul
adb shell svc bluetooth enable
timeout /t 2 >nul
adb shell am start -a android.settings.BLUETOOTH_SETTINGS
timeout /t 2 >nul

REM ==== 3. Capture Start Time (hhmmss) ====
for /f "tokens=1-2 delims= " %%a in ('wmic OS Get localdatetime ^| find "."') do set DATETIME1=%%a
set T1=%DATETIME1:~8,2%%DATETIME1:~10,2%%DATETIME1:~12,2%

REM ==== 4. Tap Device (simulate connection) ====
adb shell input tap %TAP_X% %TAP_Y%

REM ==== 5. Wait for Connection ====
timeout /t 5 >nul

REM ==== 6. Capture End Time (hhmmss) ====
for /f "tokens=1-2 delims= " %%a in ('wmic OS Get localdatetime ^| find "."') do set DATETIME2=%%a
set T2=%DATETIME2:~8,2%%DATETIME2:~10,2%%DATETIME2:~12,2%

REM ==== 7. Compute Connection Time (simple) ====
set /a TIME1=%T1%
set /a TIME2=%T2%
set /a DIFF=%TIME2%-%TIME1%
set CONNECTION_TIME=%DIFF%s

REM ==== 8. Human-Readable Run Timestamp ====
set RUN_DATE=%DATETIME2:~0,4%-%DATETIME2:~4,2%-%DATETIME2:~6,2% %DATETIME2:~8,2%:%DATETIME2:~10,2%:%DATETIME2:~12,2%

REM ==== 9. POST Data to Your Apps Script ====
curl -X POST -H "Content-Type: application/json" ^
  -d "{\"date\":\"%RUN_DATE%\",\"device\":\"%DEVICE%\",\"android_version\":\"%ANDROID_VERSION%\",\"bt_version\":\"%BT_VERSION%\",\"connection_time\":\"%CONNECTION_TIME%\"}" ^
  "https://script.google.com/macros/s/AKfycbx8xuPgkFbUCabIDkN4tz6k_zCTAvlD5yvTMwY3wJSS7C_OfCDFX3zO045RHsQ_d0aP/exec"

echo.
echo Results sent! Check the Google Sheet for the new row.
pause
