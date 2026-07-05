param(
  [string]$LogDir = (Get-Location)
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogDir)) {
  throw "Log directory not found: $LogDir"
}

$latest = Get-ChildItem -LiteralPath $LogDir -Filter 'SADE.HighFpsRawMouseFix_*.log' |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First 1

if (-not $latest) {
  throw "No SADE.HighFpsRawMouseFix run logs found in $LogDir"
}

if ($latest.Name -notmatch '^SADE\.HighFpsRawMouseFix_(\d{8}_\d{6})\.log$') {
  throw "Unexpected log filename: $($latest.Name)"
}

$runStamp = $Matches[1]
$prefix = "SADE.HighFpsRawMouseFix_$runStamp"
$suffixes = @('.log', '_rawinput.csv', '_timing.csv', '_internal_a.csv', '_markers.csv')

Write-Output "latest_run_stamp: $runStamp"
Write-Output "log_dir: $LogDir"

$items = [System.Collections.Generic.List[object]]::new()
foreach ($suffix in $suffixes) {
  $path = Join-Path $LogDir "$prefix$suffix"
  if (Test-Path -LiteralPath $path) {
    $item = Get-Item -LiteralPath $path
    $items.Add([pscustomobject]@{
      kind = $suffix
      exists = $true
      length = $item.Length
      last_write_time = $item.LastWriteTime
      path = $item.FullName
    })
  } else {
    $items.Add([pscustomobject]@{
      kind = $suffix
      exists = $false
      length = 0
      last_write_time = ''
      path = $path
    })
  }
}

$items | Format-Table -AutoSize
