param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$AdbPath = "",
    [string]$PackageName = "edu.mobilesec.ctrepro"
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 汇总实验 artifacts：复制 server log，拉取 app 导出的 CSV，并记录路径清单。
try {
    $projectRoot = Get-CtProjectRoot
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $adb = Get-CtAdbPath -AdbPath $AdbPath
    Assert-CtAdbDevice -Adb $adb

    $manifestPath = Join-Path $runDir "artifacts.md"
    "# artifacts`n" | Set-Content -Path $manifestPath -Encoding UTF8

    $serverLogInRun = Join-Path $runDir "server.log"
    $legacyServerLog = Join-Path $projectRoot "server\server.log"
    if (Test-Path -LiteralPath $serverLogInRun) {
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- server log: $serverLogInRun"
    } elseif (Test-Path -LiteralPath $legacyServerLog) {
        Copy-Item -LiteralPath $legacyServerLog -Destination $serverLogInRun -Force
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- server log: $serverLogInRun"
    } else {
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- server log: 未找到"
    }

    $remoteCsvDir = "/sdcard/Android/data/$PackageName/files/Documents/ct_repro"
    $localDataDir = Join-Path $runDir "data"
    $csvList = & $adb shell "ls $remoteCsvDir/*.csv 2>/dev/null"
    if ($LASTEXITCODE -eq 0 -and $csvList) {
        foreach ($remoteCsv in $csvList) {
            $remoteCsv = $remoteCsv.Trim()
            if ([string]::IsNullOrWhiteSpace($remoteCsv)) { continue }
            Add-CtCommandRecord -RunDir $runDir -Title "pull csv" -Command "& $adb pull $remoteCsv $localDataDir"
            & $adb pull $remoteCsv $localDataDir | Out-Null
        }
        Get-ChildItem -Path $localDataDir -Filter "*.csv" -File | ForEach-Object {
            Add-Content -Path $manifestPath -Encoding UTF8 -Value "- events csv: $($_.FullName)"
        }
    } else {
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- events csv: 未在设备上找到；请先在 app 内点击导出 CSV。"
    }

    foreach ($path in @("logcat_full.txt", "logcat_ct_repro.txt")) {
        $fullPath = Join-Path $runDir $path
        if (Test-Path -LiteralPath $fullPath) {
            Add-Content -Path $manifestPath -Encoding UTF8 -Value "- logcat: $fullPath"
        }
    }

    Get-ChildItem -Path (Join-Path $runDir "screenshots") -File -ErrorAction SilentlyContinue | ForEach-Object {
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- screenshot: $($_.FullName)"
    }
    Get-ChildItem -Path (Join-Path $runDir "videos") -File -ErrorAction SilentlyContinue | ForEach-Object {
        Add-Content -Path $manifestPath -Encoding UTF8 -Value "- video: $($_.FullName)"
    }

    Write-CtInfo "artifact 清单已生成：$manifestPath"
} catch {
    Write-Error "导出 artifacts 失败：$($_.Exception.Message)"
    exit 1
}








