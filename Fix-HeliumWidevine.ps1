<#
  =====================================================================
   HELIUM BROWSER DRM FIXER (UNIVERSAL)
  =====================================================================
   Repository: https://github.com/IceCubeSoda/Helium-DRM-Fixer
   Discord:    https://discord.gg/gG4HY9ZkMW
   Author:     IceCubeSoda
  =====================================================================
#>

[CmdletBinding()]
param (
    [string]$HeliumDataPath = "$env:LOCALAPPDATA\imput\Helium\User Data"
)

$ErrorActionPreference = "Stop"

try {
    if ((Get-ExecutionPolicy -Scope Process) -ne "Bypass") {
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
    }
} catch {
}

Clear-Host

$esc = [char]27

Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "                HELIUM DRM REPAIR UTILITY" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------`n" -ForegroundColor DarkGray

# 1. Verify Helium Directory
Write-Host "[1/5] Checking Helium Installation Path..." -ForegroundColor White
if (-not (Test-Path -Path $HeliumDataPath)) {
    Write-Host "      [!] FAIL: Helium User Data directory not found." -ForegroundColor Red
    Write-Host "          Path searched: $HeliumDataPath" -ForegroundColor DarkGray
    Write-Host "      [!] Please launch Helium at least once before running this script." -ForegroundColor Yellow
    exit 1
}
Write-Host "      [OK] Found: $HeliumDataPath" -ForegroundColor Green

# 2. Kill Active Background Processes
Write-Host "`n[2/5] Releasing Process and File Locks..." -ForegroundColor White
$TargetProcesses = Get-Process | Where-Object { 
    $_.Name -match "^helium$" -or ($_.Path -and $_.Path -like "*Helium*")
} -ErrorAction SilentlyContinue

if ($TargetProcesses) {
    foreach ($Proc in $TargetProcesses) {
        try {
            Stop-Process -Id $Proc.Id -Force -ErrorAction SilentlyContinue
            Write-Host "      [OK] Terminated running Helium instance (PID: $($Proc.Id))" -ForegroundColor Yellow
        } catch {
        }
    }
    Start-Sleep -Seconds 2
} else {
    Write-Host "      [OK] No active Helium processes detected." -ForegroundColor DarkGray
}

# 3. Dynamic MS Edge Widevine Discovery
Write-Host "`n[3/5] Locating Latest Microsoft Edge Widevine Binaries..." -ForegroundColor White
$PossibleEdgeRoots = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application",
    "$env:ProgramFiles\Microsoft\Edge\Application",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\WidevineCdm"
)

$CandidateWidevineDirs = @()

foreach ($Root in $PossibleEdgeRoots) {
    if (Test-Path -Path $Root) {
        $FoundManifests = Get-ChildItem -Path $Root -Recurse -Filter "manifest.json" -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -match "WidevineCdm" }
        foreach ($Manifest in $FoundManifests) {
            $CandidateWidevineDirs += $Manifest.DirectoryName
        }
    }
}

if ($CandidateWidevineDirs.Count -eq 0) {
    Write-Host "      [!] FAIL: Microsoft Edge WidevineCDM component missing." -ForegroundColor Red
    Write-Host "          Make sure Microsoft Edge is installed on this PC." -ForegroundColor Yellow
    exit 1
}

# Parse & Select Newest Version
$ValidCandidates = @()
foreach ($Dir in $CandidateWidevineDirs) {
    $ManifestFile = Join-Path -Path $Dir -ChildPath "manifest.json"
    try {
        $Json = Get-Content -Path $ManifestFile -Raw | ConvertFrom-Json
        if ($Json.version) {
            $ValidCandidates += [PSCustomObject]@{
                Path    = $Dir
                Version = [version]$Json.version
                RawVer  = [string]$Json.version
            }
        }
    } catch {
    }
}

if ($ValidCandidates.Count -eq 0) {
    Write-Host "      [!] FAIL: Widevine folders found, but unable to extract version metadata." -ForegroundColor Red
    exit 1
}

$SelectedSource = $ValidCandidates | Sort-Object -Property Version -Descending | Select-Object -First 1

Write-Host "      [OK] Source Discovered!" -ForegroundColor Green
Write-Host "          - Version : $($SelectedSource.RawVer)" -ForegroundColor Cyan
Write-Host "          - Path    : $($SelectedSource.Path)" -ForegroundColor DarkGray

# 4. Construct Destination & Transfer Files
Write-Host "`n[4/5] Deploying Widevine CDM to Helium..." -ForegroundColor White
$HeliumWidevineBase = Join-Path -Path $HeliumDataPath -ChildPath "WidevineCdm"
$TargetVersionDir   = Join-Path -Path $HeliumWidevineBase -ChildPath $SelectedSource.RawVer

if (Test-Path -Path $TargetVersionDir) {
    try {
        Remove-Item -Path $TargetVersionDir -Recurse -Force -ErrorAction Stop
    } catch {
    }
}

$null = New-Item -ItemType Directory -Path $TargetVersionDir -Force

try {
    Copy-Item -Path "$($SelectedSource.Path)\*" -Destination $TargetVersionDir -Recurse -Force -ErrorAction Stop
    Write-Host "      [OK] Files successfully deployed." -ForegroundColor Green
} catch {
    Write-Host "      [!] FAIL: File copy blocked: $_" -ForegroundColor Red
    Write-Host "          Ensure Helium is completely closed and try running again." -ForegroundColor Yellow
    exit 1
}

# 5. Integrity Verification
Write-Host "`n[5/5] Verifying Deployment Integrity..." -ForegroundColor White
$File1 = Join-Path -Path $TargetVersionDir -ChildPath "manifest.json"
$File2 = Join-Path -Path $TargetVersionDir -ChildPath "_platform_specific\win_x64\widevinecdm.dll"
$File3 = Join-Path -Path $TargetVersionDir -ChildPath "_platform_specific\win_x64\widevinecdm.dll.sig"

$RequiredFiles = @($File1, $File2, $File3)
$Missing = @()

foreach ($File in $RequiredFiles) {
    if (-not (Test-Path -Path $File)) {
        $Missing += $File
    }
}

if ($Missing.Count -gt 0) {
    Write-Host "      [!] Verification Failed! Missing components:" -ForegroundColor Red
    foreach ($Item in $Missing) {
        Write-Host "          - $Item" -ForegroundColor Red
    }
    exit 1
}

# Success Screen
Write-Host "`n==================================================================" -ForegroundColor DarkGreen
Write-Host "   WIDEVINE CDM v$($SelectedSource.RawVer) INSTALLED SUCCESSFULLY! " -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor DarkGreen

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "   1. Open Helium Browser." -ForegroundColor Gray
Write-Host "   2. Navigate to " -NoNewline -ForegroundColor Gray
Write-Host "$esc]8;;helium://components$esc\helium://components$esc]8;;$esc\" -NoNewline -ForegroundColor Cyan
Write-Host " to confirm active status." -ForegroundColor Gray
Write-Host "   3. Enjoy streaming on Spotify, Netflix, Disney+, and more!" -ForegroundColor Gray

Write-Host "`n------------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "  Created by IceCubeSoda" -ForegroundColor Magenta
Write-Host "  GitHub:  https://github.com/IceCubeSoda/Helium-DRM-Fixer" -ForegroundColor DarkCyan
Write-Host "  Discord: https://discord.gg/gG4HY9ZkMW" -ForegroundColor DarkCyan
Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
