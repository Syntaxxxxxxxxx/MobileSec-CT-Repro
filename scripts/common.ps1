Set-StrictMode -Version Latest

function Get-CtProjectRoot {
    # 根据 scripts/ 目录反推项目根目录，避免依赖当前 shell 所在位置。
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function New-CtRunDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$ExperimentId,
        [string]$RunId = ""
    )

    $projectRoot = Get-CtProjectRoot
    if ([string]::IsNullOrWhiteSpace($ExperimentId)) {
        throw "experiment_id 不能为空，例如 E01_callback_baseline。"
    }

    if ([string]::IsNullOrWhiteSpace($RunId)) {
        $RunId = "run_{0}" -f (Get-Date -Format "yyyyMMdd_HHmmss")
    }

    $experimentDir = Join-Path (Join-Path $projectRoot "experiments") $ExperimentId
    if (-not (Test-Path -LiteralPath $experimentDir)) {
        throw "未找到实验目录：$experimentDir。请确认 experiment_id 是否正确。"
    }

    $runDir = Join-Path $experimentDir $RunId
    New-Item -ItemType Directory -Force -Path $runDir | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $runDir "data") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $runDir "logs") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $runDir "screenshots") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $runDir "videos") | Out-Null

    return (Resolve-Path $runDir).Path
}

function Add-CtCommandRecord {
    param(
        [Parameter(Mandatory = $true)][string]$RunDir,
        [Parameter(Mandatory = $true)][string]$Title,
        [Parameter(Mandatory = $true)][string]$Command,
        [string]$Result = ""
    )

    $commandsPath = Join-Path $RunDir "commands.md"
    if (-not (Test-Path -LiteralPath $commandsPath)) {
        "# commands`n" | Set-Content -Path $commandsPath -Encoding UTF8
    }

    Add-Content -Path $commandsPath -Encoding UTF8 -Value ""
    Add-Content -Path $commandsPath -Encoding UTF8 -Value "## $Title"
    Add-Content -Path $commandsPath -Encoding UTF8 -Value ""
    Add-Content -Path $commandsPath -Encoding UTF8 -Value '```powershell'
    Add-Content -Path $commandsPath -Encoding UTF8 -Value $Command
    Add-Content -Path $commandsPath -Encoding UTF8 -Value '```'
    if (-not [string]::IsNullOrWhiteSpace($Result)) {
        Add-Content -Path $commandsPath -Encoding UTF8 -Value ""
        Add-Content -Path $commandsPath -Encoding UTF8 -Value "结果：$Result"
    }
}

function Get-CtAdbPath {
    param([string]$AdbPath = "")

    $projectRoot = Get-CtProjectRoot
    $candidates = @()
    if (-not [string]::IsNullOrWhiteSpace($AdbPath)) {
        $candidates += $AdbPath
    }
    $candidates += (Join-Path $projectRoot "env\leidian\LDPlayer9\adb.exe")
    $candidates += (Join-Path $projectRoot "env\android-sdk\platform-tools\adb.exe")

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path $candidate).Path
        }
    }

    throw "未找到 adb.exe。已检查 env\leidian\LDPlayer9\adb.exe 和 env\android-sdk\platform-tools\adb.exe。"
}

function Assert-CtAdbDevice {
    param([Parameter(Mandatory = $true)][string]$Adb)

    # adb devices 至少应有一行 device 状态；offline/unauthorized 都视为不可用。
    $devices = & $Adb devices
    $ready = $devices | Select-String -Pattern "`tdevice$"
    if (-not $ready) {
        throw "未发现可用 Android 设备。请先启动雷电模拟器，并确认 adb devices 显示 device 状态。当前输出：`n$($devices -join "`n")"
    }
}

function Get-CtSubstRoot {
    # Android/Gradle .bat 在包含 & 的路径下容易被 cmd.exe 截断，因此需要临时盘符。
    $projectRoot = Get-CtProjectRoot
    foreach ($drive in @("X", "Y", "Z", "W", "V")) {
        $driveRoot = "$drive`:\"
        $promptPath = "$driveRoot`docs\01_CODEX_PROMPTS.md"
        if (Test-Path -LiteralPath $promptPath) {
            return $driveRoot.TrimEnd([char]'\')
        }
    }

    foreach ($drive in @("X", "Y", "Z", "W", "V")) {
        $driveRoot = "$drive`:\"
        $driveExists = Test-Path -LiteralPath $driveRoot -ErrorAction SilentlyContinue
        if (-not $driveExists) {
            $substCommand = 'subst {0}: "{1}"' -f $drive, $projectRoot
            cmd.exe /c $substCommand | Out-Null
            $promptPath = "$driveRoot`docs\01_CODEX_PROMPTS.md"
            if (Test-Path -LiteralPath $promptPath) {
                return $driveRoot.TrimEnd([char]'\')
            }
        }
    }

    throw "无法为项目目录创建临时盘符映射。请手动执行：subst X: `"$projectRoot`"。"
}

function Write-CtInfo {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[CT_REPRO] $Message"
}








