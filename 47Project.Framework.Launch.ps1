<#
.SYNOPSIS
  Launches 47Project Framework and ensures PowerShell 7 is available.
.DESCRIPTION
  Windows-friendly launcher that locates or installs pwsh and then starts the GUI or CLI shell.
.PARAMETER NoGui
  Launch the CLI shell instead of the GUI.
.PARAMETER Elevated
  Relaunch elevated on Windows.
.PARAMETER Args
  Extra args passed through to the target script.
#>


<# 
47Project Framework - Launcher
- Ensures PowerShell 7 (pwsh) exists
- Launches the GUI shell
#>

[CmdletBinding()]
param(
  [switch]$NoGui,
  [switch]$Elevated,
  [string[]]$Args
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-Root {
  $here = Split-Path -Parent $MyInvocation.MyCommand.Path
  # If launcher is in root, root is $here; if in Launcher folder, root is parent
  if (Test-Path -LiteralPath (Join-Path $here 'Framework\47Project.Framework.ps1')) { return $here }
  $p = Split-Path -Parent $here
  return $p
}

function Find-Pwsh {
  $candidates = @()
  try { $candidates += @(Get-Command pwsh -ErrorAction SilentlyContinue) } catch { }
  $paths = @(
    "$env:ProgramFiles\PowerShell\7\pwsh.exe",
    "$env:ProgramFiles\PowerShell\7-preview\pwsh.exe",
    "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe"
  )
  foreach ($p in $paths) { if ($p -and (Test-Path -LiteralPath $p)) { return $p } }
  if ($candidates -and $candidates[0].Source) { return $candidates[0].Source }
  return $null
}

function Ensure-Pwsh {
  $pw = Find-Pwsh
  if ($pw) { return $pw }

  Write-Host "PowerShell 7 (pwsh) not found." -ForegroundColor Yellow
  if ($IsWindows -and (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "You can install it via Winget:" -ForegroundColor Cyan
    Write-Host "  winget install --id Microsoft.PowerShell --source winget" -ForegroundColor Cyan
    $r = Read-Host "Install now? (y/N)"
    if ($r -match '^(y|yes)$') {
      & winget install --id Microsoft.PowerShell --source winget
      Start-Sleep -Seconds 2
      $pw = Find-Pwsh
      if ($pw) { return $pw }
    }
  }

  throw "pwsh is required. Install PowerShell 7+ and retry."
}

$root = Resolve-Root

# Location guard: avoid running from temp/zip/explorer preview paths
try {
  $p = (Resolve-Path -LiteralPath $root).Path
  if ($p -match '\.zip' -or $p -match '\\Temp\\' -or $p -match '\\AppData\\Local\\Temp\\') {
    Write-Host "Extracted folder recommended: do not run from zip/temp paths." -ForegroundColor Yellow
  }
} catch { }

$pwsh = Ensure-Pwsh

$target = Join-Path $root 'Framework\47Project.Framework.ps1'
if (-not (Test-Path -LiteralPath $target)) {
  throw "GUI script not found: $target"
}

$argList = @('-NoLogo','-NoProfile','-ExecutionPolicy','Bypass','-File', $target)
if ($NoGui) {
  # If user wants CLI, try to call the framework shell directly.
  $cli = Join-Path $root 'Framework\47Project.Framework.ps1'
  if (Test-Path -LiteralPath $cli) {
    $argList = @('-NoLogo','-NoProfile','-ExecutionPolicy','Bypass','-File', $cli) + @($Args)
  }
} else {
  if ($Args) { $argList += $Args }
}

if ($Elevated -and $IsWindows) {
  Start-Process -FilePath $pwsh -ArgumentList $argList -Verb RunAs | Out-Null
} else {
  Start-Process -FilePath $pwsh -ArgumentList $argList | Out-Null
}
