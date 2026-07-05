param(
  [string]$LogDir = (Get-Location),
  [string]$RunStamp = '',
  [string]$FpsLabel = ''
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogDir)) {
  throw "Log directory not found: $LogDir"
}

if (-not $RunStamp) {
  $latest = Get-ChildItem -LiteralPath $LogDir -Filter 'SADE.HighFpsRawMouseFix_*_rawinput.csv' |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if (-not $latest) {
    throw "No rawinput CSV found in $LogDir"
  }
  if ($latest.Name -notmatch '^SADE\.HighFpsRawMouseFix_(\d{8}_\d{6})_rawinput\.csv$') {
    throw "Unexpected rawinput CSV name: $($latest.Name)"
  }
  $RunStamp = $Matches[1]
}

$prefix = "SADE.HighFpsRawMouseFix_$RunStamp"
$logPath = Join-Path $LogDir "$prefix.log"
$rawPath = Join-Path $LogDir "$prefix`_rawinput.csv"
$timingPath = Join-Path $LogDir "$prefix`_timing.csv"

foreach ($path in @($logPath, $rawPath, $timingPath)) {
  if (-not (Test-Path -LiteralPath $path)) {
    throw "Missing run file: $path"
  }
}

function Format-HexRva {
  param([string]$Value)
  if ([string]::IsNullOrWhiteSpace($Value)) {
    return '0x00000000'
  }
  return '0x{0:X8}' -f [uint32]$Value
}

$rawRows = Import-Csv -LiteralPath $rawPath
$timingRows = Import-Csv -LiteralPath $timingPath
$lastTiming = $timingRows | Select-Object -Last 1

$summary = [ordered]@{
  run_stamp = $RunStamp
  fps_label = $FpsLabel
  log = $logPath
  rawinput_csv = $rawPath
  timing_csv = $timingPath
  rawinput_rows = @($rawRows).Count
  timing_rows = @($timingRows).Count
}

if ($lastTiming) {
  foreach ($name in @(
      'raw_observed',
      'raw_buffered_observed',
      'raw_duplicates',
      'raw_size_queries',
      'raw_non_mouse',
      'raw_errors',
      'raw_buffer_errors',
      'raw_registrations',
      'raw_overflow',
      'accumulated_x',
      'accumulated_y',
      'wm_input_messages',
      'hook_get_cursor_pos',
      'hook_set_cursor_pos',
      'hook_clip_cursor',
      'hook_get_clip_cursor')) {
    $summary[$name] = $lastTiming.$name
  }
}

Write-Output '# ObserveOnly Run Summary'
foreach ($entry in $summary.GetEnumerator()) {
  Write-Output ("{0}: {1}" -f $entry.Key, $entry.Value)
}

Write-Output ''
Write-Output '## Source Counts'
$rawRows |
  Group-Object source |
  Sort-Object Count -Descending |
  ForEach-Object { '{0}: {1}' -f $_.Name, $_.Count }

Write-Output ''
Write-Output '## GetCursorPos Parents'
$rawRows |
  Where-Object { $_.source -eq 'get_cursor_pos' } |
  Group-Object command |
  Sort-Object Count -Descending |
  ForEach-Object { '{0}: {1}' -f (Format-HexRva $_.Name), $_.Count }

Write-Output ''
Write-Output '## SetCursorPos Parents'
$rawRows |
  Where-Object { $_.source -eq 'set_cursor_pos' } |
  Group-Object command |
  Sort-Object Count -Descending |
  ForEach-Object { '{0}: {1}' -f (Format-HexRva $_.Name), $_.Count }

Write-Output ''
Write-Output '## SetCursorPos Targets'
$rawRows |
  Where-Object { $_.source -eq 'set_cursor_pos' } |
  Group-Object x, y |
  Sort-Object Count -Descending |
  Select-Object -First 20 |
  ForEach-Object { '{0}: {1}' -f $_.Name, $_.Count }

Write-Output ''
Write-Output '## Raw Input Rows'
$rawRows |
  Where-Object { $_.source -eq 'data' -or $_.source -eq 'buffer' -or $_.source -eq 'register' -or $_.source -eq 'getproc' } |
  Select-Object -First 40 sequence, source, reserved, result, command, flags, x, y, button_flags, button_data, deduplicated |
  Format-Table -AutoSize
