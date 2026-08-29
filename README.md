# Helium Browser DRM Fixer (Using MS Edge)

Automated PowerShell utility to fix Widevine DRM playback issues (Spotify, Netflix, Prime Video) in **Helium Browser** by sourcing verified Widevine CDM binaries from Microsoft Edge.

---

## 🧐 The Problem

Third-party, open-source Chromium builds like Helium cannot legally bundle proprietary Widevine binaries due to licensing constraints. As a result, Helium displays `Version: 0.0.0.0` for Widevine under `chrome://components`, causing all protected media streams to fail.

## 💡 The Solution

Since Microsoft Edge is pre-installed on most Windows systems (or easily available), this script automatically locates Edge's latest signed Widevine CDM binaries, constructs the appropriate versioned directory structure, and deploys it directly to Helium's `User Data` directory.

---

## ⚡ Quick Start (One-Liner)

Open **PowerShell** and paste this single command:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; iex (iwr -useb "[https://raw.githubusercontent.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE/main/Fix-HeliumWidevine.ps1](https://raw.githubusercontent.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE/main/Fix-HeliumWidevine.ps1)")
