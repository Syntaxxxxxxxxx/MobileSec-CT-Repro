param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$AdbPath = "",
    [switch]$ClearBefore
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 导出完整 logcat 和仅包含 CT_REPRO tag 的 logcat。
try {
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $adb = Get-CtAdbPath -AdbPath $AdbPath
    Assert-CtAdbDevice -Adb $adb

    if ($ClearBefore) {
        Add-CtCommandRecord -RunDir $runDir -Title "logcat clear" -Command "& $adb logcat -c"
        & $adb logcat -c
        if ($LASTEXITCODE -ne 0) {
            throw "清空 logcat 失败，exit code=$LASTEXITCODE。"
        }
    }

    $fullLog = Join-Path $runDir "logcat_full.txt"
    $tagLog = Join-Path $runDir "logcat_ct_repro.txt"

    Add-CtCommandRecord -RunDir $runDir -Title "collect_logcat full" -Command "& $adb logcat -d"
    & $adb logcat -d | Set-Content -Path $fullLog -Encoding UTF8
    if ($LASTEXITCODE -ne 0) {
        throw "采集完整 logcat 失败，exit code=$LASTEXITCODE。"
    }

    Add-CtCommandRecord -RunDir $runDir -Title "collect_logcat CT_REPRO" -Command "& $adb logcat -d -s CT_REPRO"
    & $adb logcat -d -s CT_REPRO | Set-Content -Path $tagLog -Encoding UTF8
    if ($LASTEXITCODE -ne 0) {
        throw "采集 CT_REPRO logcat 失败，exit code=$LASTEXITCODE。"
    }

    Write-CtInfo "完整 logcat：$fullLog"
    Write-CtInfo "CT_REPRO logcat：$tagLog"
} catch {
    Write-Error "采集 logcat 失败：$($_.Exception.Message)"
    exit 1
}








