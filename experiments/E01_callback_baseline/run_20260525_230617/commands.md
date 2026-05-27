# commands


## run_server

```powershell
python D:\IEEE S&P\server\app.py
```

## run_server result

```powershell
PID: 16260
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

## install_app

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe install -r D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

## install_app result

```powershell
adb install -r
```

结果：成功

## open /basic

adb shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url http://127.0.0.1:8000/basic --ez auto_launch true

## open /status/200

adb shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url http://127.0.0.1:8000/status/200 --ez auto_launch true

## open /status/404-empty

adb shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url http://127.0.0.1:8000/status/404-empty --ez auto_launch true

## open /status/404-body

adb shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url http://127.0.0.1:8000/status/404-body --ez auto_launch true

## build_app

```powershell
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

## build_app result

```powershell
APK: D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

结果：成功

## install_app

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe install -r D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

## install_app result

```powershell
adb install -r
```

结果：成功

## build_app

```powershell
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

## build_app result

```powershell
APK: D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

结果：成功

## install_app

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe install -r D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

## install_app result

```powershell
adb install -r
```

结果：成功

## collect_logcat full

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d
```

## collect_logcat CT_REPRO

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d -s CT_REPRO
```

## screenshot

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe shell screencap -p /sdcard/ct_repro_screenshot.png; & F:\Mobile Security\env\leidian\LDPlayer9\adb.exe pull /sdcard/ct_repro_screenshot.png D:\IEEE S&P\experiments\E01_callback_baseline\run_20260525_230617\screenshots\e01_browser_not_found.png
```

## pull csv

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe pull /sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv D:\IEEE S&P\experiments\E01_callback_baseline\run_20260525_230617\data
```
