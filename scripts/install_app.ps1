param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$AdbPath = "",
    [string]$ApkPath = ""
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 安装 debug APK 到雷电模拟器或其他已授权测试设备。
try {
    $projectRoot = Get-CtProjectRoot
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $adb = Get-CtAdbPath -AdbPath $AdbPath

    if ([string]::IsNullOrWhiteSpace($ApkPath)) {
        $ApkPath = Join-Path $projectRoot "app\app\build\outputs\apk\debug\app-debug.apk"
    }
    if (-not (Test-Path -LiteralPath $ApkPath)) {
        throw "未找到 APK：$ApkPath。请先运行 scripts/build_app.ps1。"
    }

    Assert-CtAdbDevice -Adb $adb
    $logPath = Join-Path $runDir "logs\install_app.log"
    $commandText = "& $adb install -r $ApkPath"
    Add-CtCommandRecord -RunDir $runDir -Title "install_app" -Command $commandText
    Write-CtInfo "开始安装 APK，日志：$logPath"

    & $adb install -r $ApkPath 2>&1 | Tee-Object -FilePath $logPath
    if ($LASTEXITCODE -ne 0) {
        throw "adb install 失败，exit code=$LASTEXITCODE。请查看 $logPath。"
    }

    Add-CtCommandRecord -RunDir $runDir -Title "install_app result" -Command "adb install -r" -Result "成功"
    Write-CtInfo "安装成功。run 目录：$runDir"
} catch {
    Write-Error "安装 app 失败：$($_.Exception.Message)"
    exit 1
}








