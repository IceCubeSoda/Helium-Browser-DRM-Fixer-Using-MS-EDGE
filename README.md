# 🎵 Helium Browser DRM Fixer (Using MS Edge)

A fast, lightweight, zero-download PowerShell script designed to enable Widevine DRM playback on Helium Browser by dynamically linking Widevine CDM binaries already installed via Microsoft Edge.

Created by IceCubeSoda.

---

## ❓ The Problem

Helium is an open-source Chromium fork focused on privacy and performance. Because of licensing restrictions, open-source browser builds cannot legally package or ship Google's proprietary widevinecdm.dll binaries out of the box.

If you navigate to chrome://components in Helium, you will see:

Widevine Content Decryption Module
- Version: 0.0.0.0
- Status: Update error

As a result, media services requiring Digital Rights Management (DRM) — such as Spotify Web Player, Netflix, Amazon Prime Video, and Crunchyroll — will refuse to play any content.

---

## 💡 The Solution

Since Microsoft Edge is built into Windows 11 and Windows 10, it already contains officially signed, up-to-date Widevine CDM binaries on your machine.

This script bridges Edge's Widevine binaries into Helium without requiring you to download third-party tools, download Google Chrome, or manually construct deep directory structures.

### What the script does:
1. Zero External Downloads: Reuses local Microsoft Edge files.
2. Version Agnostic: Automatically scans Edge directories (Program Files, Program Files (x86), and AppData) to find the newest installed Widevine version.
3. Auto-Process Handler: Safely closes active Helium tasks so file copies aren't locked by Windows.
4. Helium Scaffolding: Creates the versioned folder hierarchy required by Chromium (WidevineCdm\<Version>\...).
5. Integrity Check: Verifies that widevinecdm.dll, widevinecdm.dll.sig, and manifest.json are present and intact.

---

## ⚡ Quick Start (One-Liner)

Open PowerShell (no Administrator privileges required) and paste the following command:

irm https://raw.githubusercontent.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE/main/Fix-HeliumWidevine.ps1 | iex

---

## 🛠️ Manual Installation

If you prefer to review or run the script manually:

1. Clone or download this repository:
   git clone https://github.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE.git

2. Open PowerShell in the project folder.

3. Execute the script:
   .\Fix-HeliumWidevine.ps1

---

## 🧪 How to Verify It Worked

1. Launch Helium Browser.
2. Open chrome://components in the address bar.
3. Find Widevine Content Decryption Module. It should now display a valid version number (e.g., 4.10.3050.1 or newer) instead of 0.0.0.0.
4. Navigate to chrome://settings/content/protectedContent and verify that "Sites can play protected content" is enabled.
5. Head over to Spotify Web Player (https://open.spotify.com), log in, and start listening!

---

## 🔗 Repository & Credits

* Author: IceCubeSoda (https://github.com/IceCubeSoda)
* GitHub Repository: Helium-Browser-DRM-Fixer-Using-MS-EDGE (https://github.com/IceCubeSoda/Helium-Browser-DRM-Fixer-Using-MS-EDGE)
* License: MIT License — free to share, modify, and distribute.
