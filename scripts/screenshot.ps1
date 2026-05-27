param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$AdbPath = "",
    [string]$Name = ""
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 使用 adb 截图，并保存到 run 目录的 screenshots/ 下。
try {
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $adb = Get-CtAdbPath -AdbPath $AdbPath
    Assert-CtAdbDevice -Adb $adb

    if ([string]::IsNullOrWhiteSpace($Name)) {
        $Name = "screenshot_{0}.png" -f (Get-Date -Format "yyyyMMdd_HHmmss")
    }
    if (-not $Name.EndsWith(".png")) {
        $Name = "$Name.png"
    }

    $remotePath = "/sdcard/ct_repro_screenshot.png"
    $localPath = Join-Path (Join-Path $runDir "screenshots") $Name

    Add-CtCommandRecord -RunDir $runDir -Title "screenshot" -Command "& $adb shell screencap -p $remotePath; & $adb pull $remotePath $localPath"
    & $adb shell screencap -p $remotePath
    if ($LASTEXITCODE -ne 0) { throw "设备截图失败，exit code=$LASTEXITCODE。" }

    & $adb pull $remotePath $localPath | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "拉取截图失败，exit code=$LASTEXITCODE。" }

    & $adb shell rm $remotePath | Out-Null
    Write-CtInfo "截图已保存：$localPath"
} catch {
    Write-Error "截图失败：$($_.Exception.Message)"
    exit 1
}








