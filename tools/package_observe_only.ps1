param(
  [string]$Configuration = 'Release',
  [string]$BuildDir = 'build-x64-ninja',
  [string]$OutputDir = 'out\ObserveOnly'
)

$ErrorActionPreference = 'Stop'

$asiCandidates = @(
  "$BuildDir\$Configuration\SADE.HighFpsRawMouseFix.asi",
  "$BuildDir\src\$Configuration\SADE.HighFpsRawMouseFix.asi",
  "$BuildDir\$Configuration\SADE.HighFpsRawMouseFix.dll",
  "$BuildDir\SADE.HighFpsRawMouseFix.asi",
  "build\$Configuration\SADE.HighFpsRawMouseFix.asi",
  "build\src\$Configuration\SADE.HighFpsRawMouseFix.asi",
  "build\$Configuration\SADE.HighFpsRawMouseFix.dll"
)

$asi = $asiCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $asi) {
  throw "Could not find SADE.HighFpsRawMouseFix.asi for configuration '$Configuration'. Build first."
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
Copy-Item -LiteralPath $asi -Destination (Join-Path $OutputDir 'SADE.HighFpsRawMouseFix.asi') -Force
Copy-Item -LiteralPath "$BuildDir\$Configuration\SADE.HighFpsRawMouseFix.RawInputCompanion.exe" -Destination (Join-Path $OutputDir 'SADE.HighFpsRawMouseFix.RawInputCompanion.exe') -Force
Copy-Item -LiteralPath 'config\SADE.HighFpsRawMouseFix.ini' -Destination (Join-Path $OutputDir 'SADE.HighFpsRawMouseFix.ini') -Force
Copy-Item -LiteralPath 'docs\MANUAL_TEST_OBSERVE_ONLY.md' -Destination (Join-Path $OutputDir 'MANUAL_TEST_OBSERVE_ONLY.md') -Force
Copy-Item -LiteralPath 'docs\OBSERVE_ONLY_RELEASE.md' -Destination (Join-Path $OutputDir 'OBSERVE_ONLY_RELEASE.md') -Force
Copy-Item -LiteralPath 'docs\OBSERVE_ONLY_AUDIT.md' -Destination (Join-Path $OutputDir 'OBSERVE_ONLY_AUDIT.md') -Force
Copy-Item -LiteralPath 'docs\NEXT_STATIC_RE.md' -Destination (Join-Path $OutputDir 'NEXT_STATIC_RE.md') -Force
Copy-Item -LiteralPath 'docs\CAMERA_PAIR_STATIC_MAP.md' -Destination (Join-Path $OutputDir 'CAMERA_PAIR_STATIC_MAP.md') -Force
Copy-Item -LiteralPath 'docs\EXPERIMENTAL_MOUSE_FIX.md' -Destination (Join-Path $OutputDir 'EXPERIMENTAL_MOUSE_FIX.md') -Force
Copy-Item -LiteralPath 'tools\summarize_observe_only.ps1' -Destination (Join-Path $OutputDir 'summarize_observe_only.ps1') -Force
Copy-Item -LiteralPath 'tools\analyze_internal_trace.ps1' -Destination (Join-Path $OutputDir 'analyze_internal_trace.ps1') -Force
Copy-Item -LiteralPath 'tools\set_observe_profile.ps1' -Destination (Join-Path $OutputDir 'set_observe_profile.ps1') -Force
Copy-Item -LiteralPath 'tools\latest_observe_run.ps1' -Destination (Join-Path $OutputDir 'latest_observe_run.ps1') -Force

Get-ChildItem -LiteralPath $OutputDir
