# GTASADE Raw Mouse Fix

Experimental raw mouse input fix for **Grand Theft Auto: San Andreas - The Definitive Edition** on Windows.

This project is a public test build. It is not a final polished mod yet, but the current `v27` build is the first version that feels close to correct in gameplay testing: camera movement uses physical Raw Input mouse deltas through a companion process, and high polling rates such as 1000 Hz no longer make the original mouse issue worse.

## What It Does

- Replaces the game's problematic mouse camera path with raw physical mouse deltas.
- Keeps mouse movement usable at high polling rates, including 1000 Hz in the author's tests.
- Uses an ASI plugin plus a small Raw Input companion executable.
- Does not use `SendInput` or gameplay automation.
- Does not modify `SanAndreas.exe` on disk.

## Current Status

`v0.1.0-test` / `v27-rawinput-companion` is a test release. The main gameplay camera issue is fixed in the author's setup, but more hardware, Windows, FPS, and mod compatibility reports are needed.

Please use GitHub Issues or Discussions to report your results.

## Installation

1. Close the game.
2. Download the latest release archive from GitHub Releases.
3. Extract these files:
   - `SADE.HighFpsRawMouseFix.asi`
   - `SADE.HighFpsRawMouseFix.RawInputCompanion.exe`
   - `SADE.HighFpsRawMouseFix.ini`
4. Copy them to:

   ```text
   GTA San Andreas - The Definitive Edition\Gameface\Binaries\Win64\scripts
   ```

5. Start the game.

## Removal

Close the game and delete these files from `Gameface\Binaries\Win64\scripts`:

- `SADE.HighFpsRawMouseFix.asi`
- `SADE.HighFpsRawMouseFix.RawInputCompanion.exe`
- `SADE.HighFpsRawMouseFix.ini`

## Recommended Game Settings

The mod targets mouse input, not every high-FPS issue in the remaster.

Recommended in-game FPS cap:

- `60 FPS`, or
- `120 FPS`

Higher FPS can cause animation or gameplay glitches in the remaster itself. Those issues are separate from this mouse fix.

## Known Issues

- The game menu may highlight buttons in a slightly strange way. In testing, the menu remains usable and clickable.
- The current version requires the external companion executable.
- The mod does not currently force the in-game FPS limit setting reliably.
- This is tested mainly on the author's setup so far.

## Compatibility

The author has tested this mod together with Fusion Fix for GTA Trilogy Definitive Edition and did not notice compatibility problems. This is not a guarantee for every setup, so compatibility reports are welcome.

## Antivirus / Safety Notes

This mod is intended for single-player use.

It uses:

- an ASI plugin loaded by the game;
- a companion `.exe`;
- Raw Input;
- shared memory between the ASI and the companion.

That combination can trigger antivirus false positives even when the build is clean. Download only from the official GitHub release page, compare SHA256 hashes, and check the release archive on VirusTotal if you want extra confidence.

VirusTotal results for the current public test build:

- Release ZIP: `1/66`, MaxSecure detects `Trojan.Malware.300983.susgen`.
- ASI plugin: `1/70`, Microsoft detects `PUA:Win32/Puwaders.C!ml`.
- Raw Input companion EXE: `1/70`, MaxSecure detects `Trojan.Malware.300983.susgen`.

These detections appear to be generic/heuristic false positives caused by the modding technique: unsigned ASI plugin, game process hooks, companion executable, Raw Input, and shared memory. The source code is public so users can inspect and build it themselves.

If your antivirus blocks the mod, you may need to restore the blocked file and add an exclusion for the mod files or for the game `scripts` folder. Only do this if you downloaded the files from the official GitHub release and the SHA256 hashes match.

Do not use this mod in multiplayer or anti-cheat-protected environments.

## Building

Requirements:

- Windows x64
- Visual Studio 2022 Build Tools
- CMake 3.21+

Example:

```powershell
.\tools\build.ps1 -Configuration Release
.\tools\package_observe_only.ps1 -Configuration Release
```

The release package contains the `.asi`, the companion `.exe`, and the default `SADE.HighFpsRawMouseFix.ini`.

## Russian README

Русская версия: [README.ru.md](README.ru.md)
