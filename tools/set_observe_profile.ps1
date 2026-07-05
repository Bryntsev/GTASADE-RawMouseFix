param(
  [ValidateSet('stable', 'safeoff', 'capture_probe', 'gameplay_state_probe', 'experimental_v2', 'experimental_v3', 'experimental_v4', 'experimental_v5', 'experimental_v6', 'experimental_v7', 'experimental_v8', 'experimental_v9', 'experimental_v10', 'experimental_v11', 'experimental_v12', 'experimental_v13', 'experimental_v14', 'experimental_v15', 'experimental_v16', 'experimental_v17', 'experimental_v18', 'experimental_v19', 'experimental_v20', 'experimental_v21', 'experimental_v22', 'experimental_v23', 'experimental_v24', 'experimental_v25', 'experimental_v26', 'experimental_v27', 'experimental', 'site13')]
  [string]$Profile = 'stable',
  [string]$IniPath = (Join-Path (Get-Location) 'SADE.HighFpsRawMouseFix.ini')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $IniPath)) {
  throw "INI not found: $IniPath"
}

$settings = switch ($Profile) {
  'stable' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '0'
      ForceUnlimitedFps = '1'
    }
  }
  'capture_probe' {
    throw "Profile 'capture_probe' is disabled: run 20260619_045906 caused startup Fatal Error before logs. Use 'stable' or an experimental_v* profile."
  }
  'safeoff' {
    @{
      ObserveRawInput = '0'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '0'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '0'
      ForceUnlimitedFps = '0'
    }
  }
  'gameplay_state_probe' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '1'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '1'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '0'
      ForceUnlimitedFps = '1'
    }
  }
  'experimental_v2' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '1'
      ExperimentalMouseFixGainX = '0.5'
      ExperimentalMouseFixGainY = '0.5'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v3' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '3'
      ExperimentalMouseFixGainX = '0.5'
      ExperimentalMouseFixGainY = '0.5'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v4' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '4'
      ExperimentalMouseFixGainX = '0.0'
      ExperimentalMouseFixGainY = '0.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v5' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '5'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v6' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '6'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v7' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '7'
      ExperimentalMouseFixGainX = '4.0'
      ExperimentalMouseFixGainY = '4.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v8' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '8'
      ExperimentalMouseFixGainX = '4.0'
      ExperimentalMouseFixGainY = '4.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v9' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '9'
      ExperimentalMouseFixGainX = '4.0'
      ExperimentalMouseFixGainY = '4.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v10' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '10'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v11' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '11'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v12' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '12'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v13' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '11'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '2.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v14' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '14'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '2.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v15' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '15'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '2.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v16' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '16'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v17' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '17'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v18' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '18'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v19' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '19'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v20' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '20'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v21' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '20000'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '21'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v22' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '1'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '22'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v23' {
    @{
      ObserveRawInput = '1'
      ObserveGetProcAddress = '0'
      ObserveCursorApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      InternalTraceDelayMs = '15000'
      InternalTraceMaxRows = '1'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '23'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v24' {
    @{
      ObserveRawInput = '1'
      ObserveCursorApis = '0'
      ObserveGetProcAddress = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '24'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v25' {
    @{
      ObserveRawInput = '1'
      ObserveCursorApis = '0'
      ObserveGetProcAddress = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '25'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v26' {
    @{
      ObserveRawInput = '1'
      ObserveCursorApis = '0'
      ObserveGetProcAddress = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '26'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental_v27' {
    @{
      ObserveRawInput = '1'
      ObserveCursorApis = '0'
      ObserveGetProcAddress = '0'
      ObserveCaptureApis = '0'
      ObserveTiming = '1'
      ObserveInternalCandidateA = '0'
      ObserveInternalSite12 = '0'
      ObserveInternalSite13 = '0'
      ObserveMarkers = '0'
      ObserveGameplayState = '0'
      ExperimentalMouseFix = '0'
      ExperimentalMouseFixV2 = '1'
      ForceUnlimitedFps = '1'
      ExperimentalMouseFixMode = '27'
      ExperimentalMouseFixGainX = '1.0'
      ExperimentalMouseFixGainY = '1.0'
      ExperimentalMouseFixMaxAgeMs = '50'
      ExperimentalMouseFixCenterX = '1920'
      ExperimentalMouseFixCenterY = '1080'
    }
  }
  'experimental' {
    throw "Profile 'experimental' is disabled: run 20260615_230203 caused startup Fatal Error before runtime rows were captured. Use 'stable' while a safer v2 patch is designed."
  }
  'site13' {
    throw "Profile 'site13' is disabled: run 20260615_174346 caused startup Fatal Error before internal rows were captured. Use 'stable' or 'safeoff' and continue static ObserveOnly RE instead."
  }
}

if (-not $settings.ContainsKey('ObserveCaptureApis')) {
  $settings['ObserveCaptureApis'] = '0'
}
if (-not $settings.ContainsKey('ObserveGameplayState')) {
  $settings['ObserveGameplayState'] = '0'
}

$experimentalKeys = @(
  'ExperimentalMouseFix',
  'ExperimentalMouseFixV2',
  'ForceUnlimitedFps',
  'ExperimentalMouseFixMode',
  'ExperimentalMouseFixGainX',
  'ExperimentalMouseFixGainY',
  'ExperimentalMouseFixMaxAgeMs',
  'ExperimentalMouseFixCenterX',
  'ExperimentalMouseFixCenterY'
)

function Get-SectionName([string]$key) {
  if ($experimentalKeys -contains $key) {
    return 'Experimental'
  }
  return 'Diagnostics'
}

$lines = [System.Collections.Generic.List[string]]::new()
$existing = Get-Content -LiteralPath $IniPath
foreach ($line in $existing) {
  $updated = $false
  foreach ($key in $settings.Keys) {
    if ($line -match "^\s*$([Regex]::Escape($key))\s*=") {
      $lines.Add("$key=$($settings[$key])")
      $updated = $true
      break
    }
  }
  if (-not $updated) {
    $lines.Add($line)
  }
}

$hasDiagnostics = $lines | Where-Object { $_ -match '^\s*\[Diagnostics\]\s*$' } | Select-Object -First 1
if (-not $hasDiagnostics) {
  $lines.Insert(0, '[Diagnostics]')
}

foreach ($key in $settings.Keys) {
  $hasKey = $lines | Where-Object { $_ -match "^\s*$([Regex]::Escape($key))\s*=" } | Select-Object -First 1
  if (-not $hasKey) {
    $sectionName = Get-SectionName $key
    $hasSection = $lines | Where-Object { $_ -match "^\s*\[$([Regex]::Escape($sectionName))\]\s*$" } | Select-Object -First 1
    if (-not $hasSection) {
      if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -ne '') {
        $lines.Add('')
      }
      $lines.Add("[$sectionName]")
    }
    $insertAt = $lines.Count
    for ($i = 0; $i -lt $lines.Count; $i++) {
      if ($lines[$i] -match "^\s*\[$([Regex]::Escape($sectionName))\]\s*$") {
        $insertAt = $i + 1
        for ($j = $insertAt; $j -lt $lines.Count; $j++) {
          if ($lines[$j] -match '^\s*\[.+\]\s*$') {
            $insertAt = $j
            break
          }
          $insertAt = $j + 1
        }
        break
      }
    }
    $lines.Insert($insertAt, "$key=$($settings[$key])")
  }
}

Set-Content -LiteralPath $IniPath -Encoding ASCII -Value $lines

Write-Output "Applied ObserveOnly profile '$Profile' to $IniPath"
foreach ($key in ($settings.Keys | Sort-Object)) {
  Write-Output "$key=$($settings[$key])"
}
