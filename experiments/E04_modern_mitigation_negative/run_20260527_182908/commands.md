# commands


## install_app

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe install -r D:\IEEE S&P\app\app\build\outputs\apk\debug\app-debug.apk
```

## install_app result

```powershell
adb install -r
```

结果：成功

## run_server

```powershell
Start-Process python .\\server\\app.py -WindowStyle Hidden -RedirectStandardOutput D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\logs\server_stdout.log -RedirectStandardError D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\logs\server_stderr.log
```n结果：已后台启动，PID=42152

## restart_server_after_e04_endpoint_patch

```powershell
Stop old server; Start-Process python .\\server\\app.py
```n结果：已重启 server，PID=30512

## E04 SameSite/Header negative result flow


### browser_samesite_clear Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/samesite/clear?step=browser_samesite_clear' com.android.chrome"
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_browser_samesite_clear.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_browser_samesite_clear.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_browser_samesite_clear.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### browser_samesite_set Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/samesite/set?step=browser_samesite_set' com.android.chrome"
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_browser_samesite_set.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_browser_samesite_set.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_browser_samesite_set.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### browser_samesite_check_control Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/samesite/check?step=browser_samesite_check_control' com.android.chrome"
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_browser_samesite_check_control.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_browser_samesite_check_control.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_browser_samesite_check_control.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### browser_samesite_cross_redirect Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://10.12.173.13:8000/samesite/cross-redirect' com.android.chrome"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_browser_samesite_cross_redirect.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_browser_samesite_cross_redirect.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_browser_samesite_cross_redirect.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### ct_samesite_check_direct Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E04_modern_mitigation_negative --es url 'http://198.18.0.1:8000/samesite/check?step=ct_samesite_check_direct' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_ct_samesite_check_direct.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_ct_samesite_check_direct.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_ct_samesite_check_direct.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\data\events_ct_samesite_check_direct.csv'
```

### ct_header_crlf_probe Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E04_modern_mitigation_negative --es url 'http://198.18.0.1:8000/headers/echo?probe=line1%0D%0AX-CT-Repro-Injected:%20yes' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_ct_header_crlf_probe.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_ct_header_crlf_probe.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_ct_header_crlf_probe.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\data\events_ct_header_crlf_probe.csv'
```

### browser_header_crlf_probe Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/headers/echo?probe=line1%0D%0AX-CT-Repro-Injected:%20yes' com.android.chrome"
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e04_browser_header_crlf_probe.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e04_browser_header_crlf_probe.png 'D:\IEEE S&P\experiments\E04_modern_mitigation_negative\run_20260527_182908\screenshots\e04_browser_header_crlf_probe.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
```

### local header detection control

```powershell
Invoke-WebRequest http://198.18.0.1:8000/headers/echo?probe=powershell_control -Headers @{ 'X-CT-Repro-Injected' = 'control-present' }
```n结果：本地控制请求用于证明 server 能检测受控测试 header；不记录 header 值。

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
Stop-Process -Id 30512 -Force
```n结果：已停止 E04 server
