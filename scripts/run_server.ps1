param(
    [string]$ExperimentId = "E01_callback_baseline",
    [string]$RunId = "",
    [string]$HostName = "0.0.0.0",
    [int]$Port = 8000,
    [string]$PythonPath = "python",
    [switch]$Foreground
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")

# 启动本地 mock server。默认后台启动，并把 PID 写入 run 目录，方便实验后停止。
try {
    $projectRoot = Get-CtProjectRoot
    $runDir = New-CtRunDirectory -ExperimentId $ExperimentId -RunId $RunId
    $serverApp = Join-Path $projectRoot "server\app.py"
    if (-not (Test-Path -LiteralPath $serverApp)) {
        throw "未找到 server/app.py，请确认项目结构完整。"
    }

    $env:CT_REPRO_HOST = $HostName
    $env:CT_REPRO_PORT = [string]$Port
    $env:CT_REPRO_SERVER_LOG = (Join-Path $runDir "server.log")

    $stdoutLog = Join-Path $runDir "logs\server_stdout.log"
    $commandText = "$PythonPath $serverApp"
    Add-CtCommandRecord -RunDir $runDir -Title "run_server" -Command $commandText

    Write-CtInfo "启动本地 mock server：http://$HostName`:$Port"
    Write-CtInfo "Android 模拟器访问：http://10.0.2.2:$Port/basic"
    Write-CtInfo "server CSV log：$env:CT_REPRO_SERVER_LOG"

    if ($Foreground) {
        Set-Location $projectRoot
        & $PythonPath $serverApp
        exit $LASTEXITCODE
    }

    $childCommand = @"
`$env:CT_REPRO_HOST = '$HostName'
`$env:CT_REPRO_PORT = '$Port'
`$env:CT_REPRO_SERVER_LOG = '$env:CT_REPRO_SERVER_LOG'
Set-Location '$projectRoot'
& '$PythonPath' '$serverApp' *> '$stdoutLog'
"@
    $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($childCommand))

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand"
    $startInfo.WorkingDirectory = $projectRoot
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $false
    $startInfo.RedirectStandardError = $false
    $startInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $null = $process.Start()
    Set-Content -Path (Join-Path $runDir "server.pid") -Encoding UTF8 -Value $process.Id

    Add-CtCommandRecord -RunDir $runDir -Title "run_server result" -Command "PID: $($process.Id)" -Result "已后台启动"
    Write-CtInfo "server 已后台启动，PID=$($process.Id)，run 目录：$runDir"
} catch {
    Write-Error "启动 server 失败：$($_.Exception.Message)"
    exit 1
}








