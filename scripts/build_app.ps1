param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 构建 Android app，并把构建日志保存到本次实验 run 目录。
try {
    $projectRoot = Get-CtProjectRoot
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $toolRoot = Get-CtSubstRoot

    $javaHome = Join-Path $toolRoot "env\jdk-17.0.19+10"
    $androidHome = Join-Path $toolRoot "env\android-sdk"
    $gradle = Join-Path $toolRoot "env\gradle-8.0\bin\gradle.bat"
    $appDir = Join-Path $toolRoot "app"

    if (-not (Test-Path -LiteralPath $gradle)) {
        throw "未找到 Gradle：$gradle。请先完成环境配置。"
    }
    if (-not (Test-Path -LiteralPath $javaHome)) {
        throw "未找到 JDK：$javaHome。请检查 env/jdk-17.0.19+10。"
    }
    if (-not (Test-Path -LiteralPath $androidHome)) {
        throw "未找到 Android SDK：$androidHome。请检查 env/android-sdk。"
    }

    $env:JAVA_HOME = $javaHome
    $env:ANDROID_HOME = $androidHome
    $env:ANDROID_SDK_ROOT = $androidHome
    $env:Path = "$javaHome\bin;$env:Path"

    $logPath = Join-Path $runDir "logs\build_app.log"
    $tasks = @()
    if ($Clean) { $tasks += "clean" }
    $tasks += "assembleDebug"

    $commandText = "& $gradle -p $appDir $($tasks -join ' ') --no-daemon --console=plain --stacktrace"
    Add-CtCommandRecord -RunDir $runDir -Title "build_app" -Command $commandText
    Write-CtInfo "开始构建 Android app，日志：$logPath"

    $cmdLine = '"{0}" -p "{1}" {2} --no-daemon --console=plain --stacktrace > "{3}" 2>&1' -f $gradle, $appDir, ($tasks -join " "), $logPath
    cmd.exe /c $cmdLine
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "Gradle 构建失败，exit code=$exitCode。请查看 $logPath。"
    }

    $apkPath = Join-Path $projectRoot "app\app\build\outputs\apk\debug\app-debug.apk"
    if (-not (Test-Path -LiteralPath $apkPath)) {
        throw "构建命令成功但未找到 APK：$apkPath。"
    }

    Set-Content -Path (Join-Path $runDir "apk_path.txt") -Encoding UTF8 -Value $apkPath
    Add-CtCommandRecord -RunDir $runDir -Title "build_app result" -Command "APK: $apkPath" -Result "成功"
    Write-CtInfo "构建成功，APK：$apkPath"
    Write-CtInfo "run 目录：$runDir"
} catch {
    Write-Error "构建 app 失败：$($_.Exception.Message)"
    exit 1
}








