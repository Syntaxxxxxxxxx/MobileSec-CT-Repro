# commands


## run_server

```powershell
python D:\IEEE S&P\server\app.py
```

## run_server result

```powershell
PID: 45160
```

结果：已后台启动

## build_app

```powershell
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

## build_app result

```powershell
APK: D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

结果：成功

## install_app attempt

`powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install_app.ps1 -ExperimentId E01_callback_baseline -RunId run_20260525_225429
`

结果：失败，雷电模拟器未进入 adb device 状态。详见 logs/install_app_attempt.log。

## collect_logcat attempt

`powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\collect_logcat.ps1 -ExperimentId E01_callback_baseline -RunId run_20260525_225429
`

结果：失败，雷电模拟器未进入 adb device 状态。详见 logs/collect_logcat_attempt.log。

## screenshot attempt

`powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\screenshot.ps1 -ExperimentId E01_callback_baseline -RunId run_20260525_225429 -Name e01_blocked
`

结果：失败，雷电模拟器未进入 adb device 状态。详见 logs/screenshot_attempt.log。
