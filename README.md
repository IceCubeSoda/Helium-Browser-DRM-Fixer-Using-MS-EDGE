# 🦊 Helium DRM Fixer

[![GitHub license](https://img.shields.io/github/license/IceCubeSoda/Helium-DRM-Fixer)](https://github.com/IceCubeSoda/Helium-DRM-Fixer/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-blue.svg)](https://microsoft.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)

An automated, version-independent PowerShell script designed to resolve missing **Widevine Content Decryption Module (CDM)** issues in **Helium Browser**. It dynamically extracts signed Widevine binaries from Microsoft Edge and installs them into Helium's User Data environment.

---

## ❓ Why Is Widevine DRM Broken in Helium Browser?

Like many custom Chromium forks, **Helium Browser** cannot legally distribute proprietary Google Widevine binaries out of the box. 

Without Widevine installed:
* Navigating to `chrome://components` shows **Widevine Content Decryption Module** stuck at version `0.0.0.0`.
* Streaming services (Spotify Web, Netflix, Amazon Prime Video, Disney+, Hulu, HBO Max) fail with error messages like *"Enable DRM in your browser"* or *"Playback Error"*.

---

## 💡 How This Script Solves It

This script connects Helium with the officially signed Widevine CDM binaries already present in your **Microsoft Edge** installation:

1. **Dynamic Version Detection:** Reads `manifest.json` from Microsoft Edge—**works regardless of what version Edge or Widevine is on**.
2. **Automated Folder Construction:** Dynamically builds the proper versioned directory path in Helium's `User Data\WidevineCdm` directory.
3. **File Verification:** Transfers and verifies required files (`widevinecdm.dll`, `.sig`, `manifest.json`).
4. **Execution Policy Handshake:** Includes built-in bypass routines to eliminate `PSSecurityException` script blocking errors.

---

## ⚡ Installation & Execution

### Method 1: Direct PowerShell One-Liner (Recommended)

Open **PowerShell** (no Administrator rights required) and run:

    iwr -useb https://raw.githubusercontent.com/IceCubeSoda/Helium-DRM-Fixer/main/Fix-HeliumWidevine.ps1 | iex

---

### Method 2: Manual Clone / Download

1. Clone or download the repository:

    git clone https://github.com/IceCubeSoda/Helium-DRM-Fixer.git

2. Open PowerShell inside the folder:

    cd "Helium-DRM-Fixer"

3. Execute the script:

    .\Fix-HeliumWidevine.ps1

> 💡 **Execution Policy Note:** If Windows blocks the script execution, the script automatically attempts a process-level bypass. You can also manually unblock it using:
>
>     Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

---

## 🔍 Verifying the Fix

1. Close and reopen **Helium Browser**.
2. Type `chrome://components` in the address bar and press **Enter**.
3. Locate **Widevine Content Decryption Module**.
4. Check that the version has updated from `0.0.0.0` to an active version (e.g., `4.10.x.x`).
5. Open [Spotify Web Player](https://open.spotify.com) or [Netflix](https://netflix.com) to start streaming.

---

## ❓ Frequently Asked Questions (FAQ)

### Will this script work after Microsoft Edge or Helium updates?
**Yes.** The script does not rely on hardcoded version numbers. It dynamically checks for the newest Widevine release installed on your system every time it runs.

### Do I need Microsoft Edge installed?
**Yes.** The script uses Edge as a trusted local source for signed Widevine CDM binaries. Edge is pre-installed on Windows 10 and 11 by default.

### Is this safe to run?
**Yes.** The script is 100% open-source, local, and transparent. It only copies files between official directories on your local drive and requires no administrative privileges.

---

## 🛡️ Compatibility

* **Operating System:** Windows 10 / Windows 11 (64-bit)
* **Target Browser:** Helium Browser
* **Source Browser:** Microsoft Edge (Standard Installation)

---

## 🤝 Contributing

Bug reports, suggestions, and pull requests are welcome! If this script helped you, give the repository a ⭐️ to help others find it.

Crafted by [IceCubeSoda](https://github.com/IceCubeSoda)
