# =====================================================================
# Helium DRM Fixer (Universal)
# Repository: https://github.com/IceCubeSoda/Helium-DRM-Fixer
# Author: IceCubeSoda
# =====================================================================

[CmdletBinding()]
param (
    [string]$HeliumDataPath = "$env:LOCALAPPDATA\imput\Helium\User Data"
)

$ErrorActionPreference = "Stop"

# Try to automatically bypass execution policy for this process session
try {
    if ((Get-ExecutionPolicy -Scope Process) -ne "Bypass") {
        Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -ErrorAction SilentlyContinue
    }
} catch {
    # Ignore policy change restrictions
}

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "   Helium Browser Widevine CDM Fixer (Universal)    " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. Verify Helium User Data Path
if (-not (Test-Path $HeliumDataPath)) {
    Write-Host "`n[!] Helium User Data directory not found at:" -ForegroundColor Red
    Write-Host "    $HeliumDataPath" -ForegroundColor Yellow
    Write-Host "[!] Please launch Helium at least once before running this script." -ForegroundColor Red
    exit 1
}

Write-Host "`n[+] Helium installation verified at: $HeliumDataPath" -ForegroundColor Green

# 2. Kill all background browser processes to release file locks
Write-Host "[+] Ensuring no Helium or background processes are holding file locks..." -ForegroundColor Yellow

$TargetProcesses = Get-Process | Where-Object { 
    $_.Name -match "helium|imput" -or 
    ($_.Path -and $_.Path -like "*Helium*")
} -ErrorAction SilentlyContinue

if ($TargetProcesses) {
    foreach ($Proc in $TargetProcesses) {
        try {
            Stop-Process -Id $Proc.Id -Force -ErrorAction SilentlyContinue
        } catch {
            # Ignore process termination errors
        }
    }
    Start-Sleep -Seconds 2
}

# 3. Dynamic Search for Microsoft Edge Widevine Locations
$PossibleEdgeRoots = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application",
    "$env:ProgramFiles\Microsoft\Edge\Application",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\WidevineCdm"
)

$CandidateWidevineDirs = @()

foreach ($Root in $PossibleEdgeRoots) {
    if (Test-Path $Root) {
        # Search for any directory containing a Widevine manifest.json file
        $FoundManifests = Get-ChildItem -Path $Root -Recurse -Filter "manifest.json" -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -match "WidevineCdm" }
        
        foreach ($Manifest in $FoundManifests) {
            $CandidateWidevineDirs += $Manifest.DirectoryName
        }
    }
}

if ($CandidateWidevineDirs.Count -eq 0) {
    Write-Host "`n[!] Could not locate Microsoft Edge or its WidevineCDM component." -ForegroundColor Red
    Write-Host "[!] Please verify that Microsoft Edge is installed on this system." -ForegroundColor Red
    exit 1
}

# 4. Parse Candidates & Select the Highest Version
$ValidCandidates = @()

foreach ($Dir in $CandidateWidevineDirs) {
    $ManifestFile = Join-Path $Dir "manifest.json"
    try {
        $Json = Get-Content $ManifestFile -Raw | ConvertFrom-Json
        if ($Json.version) {
            $ValidCandidates += [PSCustomObject]@{
                Path    = $Dir
                Version = [version]$Json.version
                RawVer  = $Json.version
            }
        }
    } catch {
        # Skip unparseable manifests
    }
}

if ($ValidCandidates.Count -eq 0) {
    Write-Host "`n[!] Found Widevine directories, but failed to extract valid version metadata." -ForegroundColor Red
    exit 1
}

# Sort descending to grab the newest available version across all Edge installation paths
$SelectedSource = $ValidCandidates | Sort-Object Version -Descending | Select-Object -First 1

Write-Host "[+] Discovered latest Edge Widevine CDM Source:" -ForegroundColor Green
Write-Host "    Path:    $($SelectedSource.Path)" -ForegroundColor Gray
Write-Host "    Version: $($SelectedSource.RawVer)" -ForegroundColor Cyan

# 5. Build Versioned Destination Path in Helium
$HeliumWidevineBase = Join-Path $HeliumDataPath "WidevineCdm"
$TargetVersionDir   = Join-Path $HeliumWidevineBase $SelectedSource.RawVer

if (Test-Path $TargetVersionDir) {
    Write-Host "[+] Target version directory exists. Attempting clean copy..." -ForegroundColor Yellow
    try {
        Remove-Item $TargetVersionDir -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Host "[!] Could not perform full deletion (file locked). Falling back to direct file overwrite..." -ForegroundColor Yellow
    }
}

New-Item -ItemType Directory -Path $TargetVersionDir -Force | Out-Null

# 6. Copy Files
Write-Host "[+] Copying Widevine CDM binaries to Helium structure..." -ForegroundColor Cyan
try {
    Copy-Item -Path "$($SelectedSource.Path)\*" -Destination $TargetVersionDir -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host "`n[!] Copy failed due to active file lock: $_" -ForegroundColor Red
    Write-Host "[!] Please manually close Helium Browser completely and re-run this script." -ForegroundColor Red
    exit 1
}

# 7. Verification Phase
$RequiredFiles = @(
    (Join-Path $TargetVersionDir "manifest.json"),
    (Join-Path $TargetVersionDir "_platform_specific\win_x64\widevinecdm.dll"),
    (Join-Path $TargetVersionDir "_platform_specific\win_x64\widevinecdm.dll.sig")
)

$Missing = $RequiredFiles | Where-Object { -not (Test-Path $_) }

if ($Missing.Count -gt 0) {
    Write-Host "`n[!] Verification Failed! Missing required files:" -ForegroundColor Red
    foreach ($File in $Missing) {
        Write-Host "    - $File" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`n====================================================" -ForegroundColor Green
Write-Host " SUCCESS! Widevine CDM ($($SelectedSource.RawVer)) Installed" -ForegroundColor Green
Write-Host " Target: $TargetVersionDir" -ForegroundColor Yellow
Write-Host "====================================================" -ForegroundColor Green

Write-Host "`nMade with <3 by IceCubeSoda" -ForegroundColor Magenta
Write-Host "GitHub Repo: https://github.com/IceCubeSoda/Helium-DRM-Fixer" -ForegroundColor DarkCyan

Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host " 1. Launch Helium Browser." -ForegroundColor White
Write-Host " 2. Visit chrome://components to verify version $($SelectedSource.RawVer)." -ForegroundColor White
Write-Host " 3. Enjoy Spotify, Netflix, and DRM content!" -ForegroundColor White
