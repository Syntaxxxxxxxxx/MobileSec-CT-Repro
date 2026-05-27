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
Start-Process python .\\server\\app.py -WindowStyle Hidden -RedirectStandardOutput D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\logs\server_stdout_direct.log -RedirectStandardError D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\logs\server_stderr_direct.log
```n结果：已后台启动，PID=34424

## clear android global proxy and logcat

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings put global http_proxy :0
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings delete global global_http_proxy_host
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell settings delete global global_http_proxy_port
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell logcat -c
```

## E02 launch cases


### launch redirect_http_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_t1.csv'
```

### launch redirect_http_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_t2.csv'
```

### launch redirect_http_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_t3.csv'
```

### launch redirect_html_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_t1.csv'
```

### launch redirect_html_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_t2.csv'
```

### launch redirect_html_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_t3.csv'
```

### launch download_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_t1.csv'
```

### launch download_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_t2.csv'
```

### launch download_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_t3.csv'
```

### launch content_pdf_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_t1.csv'
```

### launch content_pdf_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_t2.csv'
```

### launch content_pdf_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_t3.csv'
```

### launch delay_1000_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_t1.csv'
```

### launch delay_1000_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_t2.csv'
```

### launch delay_1000_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 7
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_t3.csv'
```

### launch delay_3000_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=1&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 10
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_t1.csv'
```

### launch delay_3000_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=2&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 10
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_t2.csv'
```

### launch delay_3000_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=3&run=run_20260527_153912' --ez auto_launch true
Start-Sleep 10
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_t3.csv'
```

## E02 launch cases rerun without shell ampersand in URL


### launch redirect_http_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=redirect_http_ok_t1' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_ok_t1.csv'
```

### launch redirect_http_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=redirect_http_ok_t2' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_ok_t2.csv'
```

### launch redirect_http_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/http?trial=redirect_http_ok_t3' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_http_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_http_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_http_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_http_ok_t3.csv'
```

### launch redirect_html_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=redirect_html_ok_t1' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_ok_t1.csv'
```

### launch redirect_html_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=redirect_html_ok_t2' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_ok_t2.csv'
```

### launch redirect_html_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/redirect/html?trial=redirect_html_ok_t3' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_redirect_html_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_redirect_html_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_redirect_html_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_redirect_html_ok_t3.csv'
```

### launch download_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=download_ok_t1' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_ok_t1.csv'
```

### launch download_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=download_ok_t2' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_ok_t2.csv'
```

### launch download_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/download?trial=download_ok_t3' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_download_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_download_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_download_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_download_ok_t3.csv'
```

### launch content_pdf_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=content_pdf_ok_t1' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_ok_t1.csv'
```

### launch content_pdf_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=content_pdf_ok_t2' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_ok_t2.csv'
```

### launch content_pdf_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/content/pdf?trial=content_pdf_ok_t3' --ez auto_launch true"
Start-Sleep 9
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_content_pdf_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_content_pdf_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_content_pdf_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_content_pdf_ok_t3.csv'
```

### launch delay_1000_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=delay_1000_ok_t1' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_ok_t1.csv'
```

### launch delay_1000_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=delay_1000_ok_t2' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_ok_t2.csv'
```

### launch delay_1000_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/1000?trial=delay_1000_ok_t3' --ez auto_launch true"
Start-Sleep 8
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_1000_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_1000_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_1000_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_1000_ok_t3.csv'
```

### launch delay_3000_ok_t1

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=delay_3000_ok_t1' --ez auto_launch true"
Start-Sleep 11
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_ok_t1.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_ok_t1.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_ok_t1.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_ok_t1.csv'
```

### launch delay_3000_ok_t2

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=delay_3000_ok_t2' --ez auto_launch true"
Start-Sleep 11
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_ok_t2.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_ok_t2.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_ok_t2.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_ok_t2.csv'
```

### launch delay_3000_ok_t3

```powershell
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell "am start -n edu.mobilesec.ctrepro/.MainActivity --es experiment_id E02_state_inference_oracle --es url 'http://198.18.0.1:8000/delay/3000?trial=delay_3000_ok_t3' --ez auto_launch true"
Start-Sleep 11
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell screencap -p /sdcard/e02_delay_3000_ok_t3.png
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull /sdcard/e02_delay_3000_ok_t3.png 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\screenshots\e02_delay_3000_ok_t3.png'
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' shell input keyevent 4
& 'F:\Mobile Security\env\leidian\LDPlayer9\adb.exe' pull '/sdcard/Android/data/edu.mobilesec.ctrepro/files/Documents/ct_repro/events_latest.csv' 'D:\IEEE S&P\experiments\E02_state_inference_oracle\run_20260527_153912\data\events_delay_3000_ok_t3.csv'
```

## collect_logcat full

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d
```

## collect_logcat CT_REPRO

```powershell
& F:\Mobile Security\env\leidian\LDPlayer9\adb.exe logcat -d -s CT_REPRO
```
