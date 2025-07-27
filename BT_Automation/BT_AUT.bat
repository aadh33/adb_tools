@echo off
adb shell am start -a android.settings.BLUETOOTH_SETTINGS
timeout /t 2
adb shell input tap 529 1101
