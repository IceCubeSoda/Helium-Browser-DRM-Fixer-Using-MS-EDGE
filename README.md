<div align="center">

# 🦊 Helium DRM Fixer

**A dynamic, version-independent utility to restore Widevine DRM playback in Helium Browser.**

[![GitHub license](https://img.shields.io/github/license/IceCubeSoda/Helium-DRM-Fixer?style=for-the-badge&color=ff7b00)](https://github.com/IceCubeSoda/Helium-DRM-Fixer/blob/main/LICENSE)
[![Discord](https://img.shields.io/badge/Discord-Join%20Community-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/gG4HY9ZkMW)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078d4?style=for-the-badge&logo=windows)](https://microsoft.com)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell)](https://github.com/PowerShell/PowerShell)

---

</div>

## ❓ The Problem

Third-party Chromium forks like **Helium Browser** cannot legally bundle proprietary Google Widevine DRM binaries out of the box. 

Without Widevine:
* `helium://components` displays **Widevine Content Decryption Module** stuck at version `0.0.0.0`.
* Major web services like **Spotify Web, Netflix, Disney+, Amazon Prime Video, and Hulu** fail with errors like *"Enable DRM in your browser"* or *"Playback Error"*.

---

## 💡 The Solution

This utility bridges Helium with the official, signed Widevine binaries pre-installed on your system via **Microsoft Edge**:

* ⚡ **100% Dynamic:** Reads manifest parameters automatically—**works regardless of future Edge or Widevine updates**.
* 🧹 **Process Manager:** Automatically terminates locked background tasks to ensure clean installations.
* 🛡️ **Zero Administrative Rights Required:** Operates strictly within user-level directories without system-wide file modifications.
* 🔓 **Bypass Integration:** Handles PowerShell `ExecutionPolicy` routines automatically.

---

## ⚡ Quick Start / Installation

### Method 1: One-Liner Execution (Fastest)

Open **PowerShell** and run the following command directly:

```powershell
iwr -useb https://raw.githubusercontent.com/IceCubeSoda/Helium-DRM-Fixer/main/Fix-HeliumWidevine.ps1 | iex
```

---

### Method 2: Manual Installation

1. Clone or download this repository:
   ```bash
   git clone https://github.com/IceCubeSoda/Helium-DRM-Fixer.git
   ```

2. Navigate into the repository folder:
   ```powershell
   cd Helium-DRM-Fixer
   ```

3. Execute the script:
   ```powershell
   .\Fix-HeliumWidevine.ps1
   ```

> [!NOTE]  
> If Windows blocks script execution, the script automatically attempts a process-level policy override. You can also manually grant execution rights for your current window:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
> ```

---

## 🔍 Verification Step

| Step | Action |
| :--- | :--- |
| **1. Launch** | Open **Helium Browser**. |
| **2. Navigate** | Type `helium://components` into the address bar and hit **Enter**. |
| **3. Confirm** | Locate **Widevine Content Decryption Module**. Verify version has updated from `0.0.0.0` to an active string (e.g., `4.10.x.x`). |
| **4. Stream** | Visit [Spotify Web Player](https://open.spotify.com) or [Netflix](https://netflix.com) to enjoy uninterrupted audio & video. |

---

## ❓ Frequently Asked Questions (FAQ)

<details>
<summary><b>Will this script work after Microsoft Edge or Helium updates?</b></summary>
<br>
<b>Yes.</b> The script avoids hardcoded version strings. It dynamically detects and extracts whichever Widevine release is currently installed on your PC every time it is run.
</details>

<details>
<summary><b>Do I need Microsoft Edge installed?</b></summary>
<br>
<b>Yes.</b> The script uses Edge as a secure local source for signed Widevine binaries. Edge comes pre-installed by default on Windows 10 and Windows 11.
</details>

<details>
<summary><b>Is this safe to run?</b></summary>
<br>
<b>100% Yes.</b> The entire script is open-source, local, and fully transparent. It strictly copies binaries between official local directories and requires no elevation or external downloads outside of your local drive.
</details>

---

## 💬 Community & Support

Got questions, ran into a bug, or want to hang out with fellow developers?

[![Join Discord](https://img.shields.io/badge/Join%20Our%20Discord%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)]([https://discord.gg/gG4HY9ZkMW](https://discord.gg/gG4HY9ZkMW))

Feel free to open an **Issue** or submit a **Pull Request** right here on GitHub!

---

<div align="center">
Crafted with ❤️ by <b><a href="[https://github.com/IceCubeSoda](https://github.com/IceCubeSoda)">IceCubeSoda</a></b>
</div>
