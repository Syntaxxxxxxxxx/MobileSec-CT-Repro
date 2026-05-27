# commands


## run_server

```powershell
python D:\IEEE S&P\server\app.py
```

## build_app

```powershell
& X:\env\gradle-8.0\bin\gradle.bat -p X:\app assembleDebug --no-daemon --console=plain --stacktrace
```

## run_server result

```powershell
PID: 11116
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

## run_server manual fallback

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\logs\start_server_manual.ps1
```n结果：已后台启动，PID=31584

## run_server manual fallback elevated

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\logs\start_server_manual.ps1
```n结果：已后台启动，PID=33684

## run_server direct fallback

```powershell
Start-Process python .\\server\\app.py -WindowStyle Hidden -RedirectStandardOutput D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\logs\server_stdout_direct.log -RedirectStandardError D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\logs\server_stderr_direct.log
```n结果：已后台启动，PID=26240

## E01 launch cases


### launch basic

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/basic' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_basic.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_basic.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_basic.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_basic.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_200

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/200' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_200.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_200.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_200.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_200.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_404_empty

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/404-empty' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_404_empty.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_404_empty.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_404_empty.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_404_empty.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_404_body

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/404-body' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_404_body.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_404_body.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_404_body.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_404_body.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

## collect_logcat full

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d
```

## collect_logcat CT_REPRO

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d -s CT_REPRO
```

## clear android global proxy before local server test

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings put global http_proxy :0
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings delete global global_http_proxy_host
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings delete global global_http_proxy_port
```

## E01 launch cases after clearing Android proxy


### launch basic_localnet

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/basic' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_basic_localnet.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_basic_localnet.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_basic_localnet.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_basic_localnet.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_200_localnet

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/200' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_200_localnet.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_200_localnet.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_200_localnet.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_200_localnet.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_404_empty_localnet

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/404-empty' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_404_empty_localnet.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_404_empty_localnet.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_404_empty_localnet.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_404_empty_localnet.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### launch status_404_body_localnet

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E01_callback_baseline --es url 'http://198.18.0.1:8000/status/404-body' --ez auto_launch true
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e01_status_404_body_localnet.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e01_status_404_body_localnet.png 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\screenshots\e01_status_404_body_localnet.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E01_callback_baseline\run_20260527_152504\data\events_status_404_body_localnet.csv'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

## collect_logcat full

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d
```

## collect_logcat CT_REPRO

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d -s CT_REPRO
```

## stop_server

```powershell
Stop-Process -Id 26240
```n结果：已停止本次 direct fallback server
