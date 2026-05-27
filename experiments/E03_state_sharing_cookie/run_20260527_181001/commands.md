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

## run_server direct

```powershell
Start-Process python .\\server\\app.py -WindowStyle Hidden -RedirectStandardOutput D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\logs\server_stdout_direct.log -RedirectStandardError D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\logs\server_stderr_direct.log
```n结果：已后台启动，PID=36484

## E03 state sharing flow


### ct_profile_before Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/profile?step=ct_profile_before' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_ct_profile_before.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_ct_profile_before.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_ct_profile_before.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_ct_profile_before.csv'
```

### ct_login Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/login?step=ct_login' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_ct_login.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_ct_login.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_ct_login.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_ct_login.csv'
```

### ct_profile_after Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/profile?step=ct_profile_after' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_ct_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_ct_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_ct_profile_after.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_ct_profile_after.csv'
```

### browser_profile_after Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/profile?step=browser_profile_after' com.android.chrome"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_browser_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_browser_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_browser_profile_after.png'
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

## restart_server_clean

```powershell
Stop old python servers; Start-Process python .\\server\\app.py
```n结果：已重启本次 server，PID=42364

## E03 clean state sharing flow on 172.16.1.1


### clean_ct_profile_before Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://172.16.1.1:8000/profile?step=clean_ct_profile_before' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_clean_ct_profile_before.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_clean_ct_profile_before.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_clean_ct_profile_before.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_clean_ct_profile_before.csv'
```

### clean_ct_login Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://172.16.1.1:8000/login?step=clean_ct_login' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_clean_ct_login.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_clean_ct_login.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_clean_ct_login.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_clean_ct_login.csv'
```

### clean_ct_profile_after Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://172.16.1.1:8000/profile?step=clean_ct_profile_after' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_clean_ct_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_clean_ct_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_clean_ct_profile_after.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_clean_ct_profile_after.csv'
```

### clean_browser_profile_after Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://172.16.1.1:8000/profile?step=clean_browser_profile_after' com.android.chrome"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_clean_browser_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_clean_browser_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_clean_browser_profile_after.png'
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

## restart_server_with_logout

```powershell
Stop current server; Start-Process python .\\server\\app.py
```n结果：已启动带 /logout 的本次 server，PID=13228

## E03 final state sharing flow on 198.18.0.1 with /logout reset


### final_ct_logout_reset Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/logout?step=final_ct_logout_reset' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_final_ct_logout_reset.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_final_ct_logout_reset.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_final_ct_logout_reset.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_final_ct_logout_reset.csv'
```

### final_ct_profile_before Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/profile?step=final_ct_profile_before' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_final_ct_profile_before.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_final_ct_profile_before.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_final_ct_profile_before.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_final_ct_profile_before.csv'
```

### final_ct_login Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/login?step=final_ct_login' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_final_ct_login.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_final_ct_login.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_final_ct_login.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_final_ct_login.csv'
```

### final_ct_profile_after Custom Tab

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E03_state_sharing_cookie --es url 'http://198.18.0.1:8000/profile?step=final_ct_profile_after' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_final_ct_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_final_ct_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_final_ct_profile_after.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\data\events_final_ct_profile_after.csv'
```

### final_browser_profile_after Chrome browser

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -a android.intent.action.VIEW -d 'http://198.18.0.1:8000/profile?step=final_browser_profile_after' com.android.chrome"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e03_final_browser_profile_after.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e03_final_browser_profile_after.png 'D:\IEEE S&P\experiments\E03_state_sharing_cookie\run_20260527_181001\screenshots\e03_final_browser_profile_after.png'
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
Stop-Process -Id 13228 -Force
```n结果：已停止 E03 server
