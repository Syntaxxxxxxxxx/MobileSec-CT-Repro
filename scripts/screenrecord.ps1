param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$AdbPath = "",
    [int]$Seconds = 20,
    [string]$Name = ""
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 使用 adb shell screenrecord 录屏，并保存到 run 目录的 videos/ 下。
try {
    if ($Seconds -lt 1 -or $Seconds -gt 180) {
        throw "录屏时长必须在 1 到 180 秒之间。"
    }

    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $adb = Get-CtAdbPath -AdbPath $AdbPath
    Assert-CtAdbDevice -Adb $adb

    if ([string]::IsNullOrWhiteSpace($Name)) {
        $Name = "screenrecord_{0}.mp4" -f (Get-Date -Format "yyyyMMdd_HHmmss")
    }
    if (-not $Name.EndsWith(".mp4")) {
        $Name = "$Name.mp4"
    }

    $remotePath = "/sdcard/ct_repro_screenrecord.mp4"
    $localPath = Join-Path (Join-Path $runDir "videos") $Name

    Add-CtCommandRecord -RunDir $runDir -Title "screenrecord" -Command "& $adb shell screenrecord --time-limit $Seconds $remotePath"
    Write-CtInfo "开始录屏 $Seconds 秒，请保持模拟器画面在目标状态。"
    & $adb shell screenrecord --time-limit $Seconds $remotePath
    if ($LASTEXITCODE -ne 0) { throw "设备录屏失败，exit code=$LASTEXITCODE。" }

    & $adb pull $remotePath $localPath | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "拉取录屏失败，exit code=$LASTEXITCODE。" }

    & $adb shell rm $remotePath | Out-Null
    Write-CtInfo "录屏已保存：$localPath"
} catch {
    Write-Error "录屏失败：$($_.Exception.Message)"
    exit 1
}








