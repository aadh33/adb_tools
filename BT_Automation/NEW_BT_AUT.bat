@echo off
adb shell svc bluetooth enable
timeout /t 3
adb shell am start -a android.settings.BLUETOOTH_SETTINGS
timeout /t 2
adb shell input tap 529 1101
