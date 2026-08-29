# 🦊 Helium Browser Widevine DRM Fixer (Using MS Edge)

A dynamic, robust PowerShell utility that fixes broken or missing Widevine DRM (Digital Rights Management) components in **Helium Browser** by sourcing and linking signed Widevine CDM binaries from Microsoft Edge.

---

## ❓ The Problem

Third-party open-source Chromium forks like **Helium Browser** cannot legally bundle proprietary, Google-certified Widevine binaries. 

As a result:
- Visiting `chrome://components` shows **Widevine Content Decryption Module** stuck at version `0.0.0.0`.
- DRM-protected services like **Spotify Web, Netflix, Prime Video, Hulu, and Disney+** fail to play audio/video or trigger browser errors (e.g., *Spotify: "Enable DRM in your browser"*).

---

## 💡 The Solution

Microsoft Edge is pre-installed on modern Windows systems and maintains officially signed, up-to-date Widevine CDM binaries. 

This script:
1. Automatically scans your system for Microsoft Edge Widevine installations (handling 32-bit, 64-bit, and User Data component stores).
2. Parses version metadata to discover the **newest** available Widevine CDM release.
3. Automatically creates the required versioned directory structure inside Helium's `User Data` path.
4. Copies and verifies all required DLLs, signatures, and `manifest.json` files.

---

## ⚡ Quick Start / Installation

### Option 1: One-Liner (Fastest)
Open **PowerShell** and run the following command directly:

    iwr -useb https://raw.githubusercontent.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE/main/Fix-HeliumWidevine.ps1 | iex

---

### Option 2: Manual Execution

1. Clone or download this repository:
    
    git clone https://github.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE.git

2. Open PowerShell in the project directory:

    cd "Helium-Browser-DRM-Fixer-Using-MS-EDGE"

3. Run the script:

    .\Fix-HeliumWidevine.ps1

> 💡 **Note on Execution Policy:**  
> The script includes an automated process bypass. If Windows still restricts script execution on your machine, run this command prior to execution:
>
>     Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

---

## 🔍 Verification

Once the script outputs `SUCCESS!`:

1. Launch **Helium Browser**.
2. Navigate to `chrome://components` in the address bar.
3. Locate **Widevine Content Decryption Module**.
4. Verify that the version number is updated from `0.0.0.0` to an active version (e.g., `4.10.x.x`).
5. Open [Spotify Web Player](https://open.spotify.com) or [Netflix](https://www.netflix.com) to confirm playback works seamlessly.

---

## 🛡️ Requirements

- **OS:** Windows 10 / Windows 11 (x64)
- **Browser:** Helium Browser
- **Dependency:** Microsoft Edge (Pre-installed on Windows 10/11)

---

## 🤝 Contributing & Feedback

If you run into issues or have ideas to improve script detection across non-standard installs, feel free to open an **Issue** or submit a **Pull Request**.

Made with ❤️ by [IceCubeSoda](https://github.com/IceCubeSoda)
