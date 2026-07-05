param(
  [string]$LogDir = (Get-Location),
  [string]$RunStamp = '',
  [int]$MaxLookaheadRows = 12,
  [double]$Tolerance = 0.001
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogDir)) {
  throw "Log directory not found: $LogDir"
}

if (-not $RunStamp) {
  $latest = Get-ChildItem -LiteralPath $LogDir -Filter 'SADE.HighFpsRawMouseFix_*_internal_a.csv' |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if (-not $latest) {
    throw "No internal trace CSV found in $LogDir"
  }
  if ($latest.Name -notmatch '^SADE\.HighFpsRawMouseFix_(\d{8}_\d{6})_internal_a\.csv$') {
    throw "Unexpected internal trace CSV name: $($latest.Name)"
  }
  $RunStamp = $Matches[1]
}

$prefix = "SADE.HighFpsRawMouseFix_$RunStamp"
$internalPath = Join-Path $LogDir "$prefix`_internal_a.csv"
$logPath = Join-Path $LogDir "$prefix.log"
$markerPath = Join-Path $LogDir "$prefix`_markers.csv"

if (-not (Test-Path -LiteralPath $internalPath)) {
  throw "Missing internal trace CSV: $internalPath"
}

$rows = @(Import-Csv -LiteralPath $internalPath)

function To-Double([object]$value) {
  if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) { return 0.0 }
  return [double]::Parse([string]$value, [Globalization.CultureInfo]::InvariantCulture)
}

function NonZero($row) {
  return ((To-Double $row.delta_x) -ne 0.0) -or ((To-Double $row.delta_y) -ne 0.0)
}

function Row-Site($row) {
  return [int]$row.site
}

Write-Output '# Internal Trace Analysis'
Write-Output "run_stamp: $RunStamp"
Write-Output "internal_csv: $internalPath"
if (Test-Path -LiteralPath $logPath) { Write-Output "log: $logPath" }
if (Test-Path -LiteralPath $markerPath) { Write-Output "markers_csv: $markerPath" }
Write-Output "rows: $($rows.Count)"

if ($rows.Count -eq 0) {
  Write-Output ''
  Write-Output 'No internal trace rows found. If the CSV has only a header, check the run log for guard failure or startup Fatal Error.'
  exit 0
}

Write-Output ''
Write-Output '## Site Counts'
$rows |
  Group-Object site |
  Sort-Object {[int]$_.Name} |
  ForEach-Object {
    $group = @($_.Group)
    [pscustomobject]@{
      site = $_.Name
      count = $_.Count
      nonzero = @($group | Where-Object { NonZero $_ }).Count
      first_sequence = $group[0].sequence
      last_sequence = $group[-1].sequence
    }
  } |
  Format-Table -AutoSize

if ($rows[0].PSObject.Properties.Name -contains 'segment_id') {
  Write-Output ''
  Write-Output '## Site Counts By Segment'
  $rows |
    Group-Object segment_id, segment_label, site |
    Sort-Object Name |
    ForEach-Object {
      $parts = $_.Name -split ', '
      [pscustomobject]@{
        segment_id = $parts[0]
        segment_label = if ($parts.Count -gt 1) { $parts[1] } else { '' }
        site = if ($parts.Count -gt 2) { $parts[2] } else { '' }
        count = $_.Count
        nonzero = @($_.Group | Where-Object { NonZero $_ }).Count
      }
    } |
    Format-Table -AutoSize
}

Write-Output ''
Write-Output '## Call Target Groups'
$rows |
  Where-Object { $_.call_target -and $_.call_target -ne '0x0' } |
  Group-Object site, call_target |
  Sort-Object Count -Descending |
  Select-Object -First 30 |
  ForEach-Object {
    $parts = $_.Name -split ', '
    [pscustomobject]@{
      site = $parts[0]
      call_target = if ($parts.Count -gt 1) { $parts[1] } else { '' }
      count = $_.Count
      nonzero = @($_.Group | Where-Object { NonZero $_ }).Count
      stack_arg28 = (@($_.Group | Group-Object stack_arg28 | Sort-Object Count -Descending | Select-Object -First 4 | ForEach-Object { "$($_.Name):$($_.Count)" }) -join '; ')
    }
  } |
  Format-Table -AutoSize

Write-Output ''
Write-Output '## Sequence Pattern 7 -> 8 -> 10 -> 9 -> 12'
$chainHits = 0
$missing = @{}
for ($i = 0; $i -lt $rows.Count; $i++) {
  if ((Row-Site $rows[$i]) -ne 7) { continue }
  $need = @(8, 10, 9, 12)
  $needIndex = 0
  $limit = [Math]::Min($rows.Count - 1, $i + $MaxLookaheadRows)
  for ($j = $i + 1; $j -le $limit -and $needIndex -lt $need.Count; $j++) {
    if ((Row-Site $rows[$j]) -eq $need[$needIndex]) {
      $needIndex++
    }
  }
  if ($needIndex -eq $need.Count) {
    $chainHits++
  } else {
    $key = if ($needIndex -lt $need.Count) { "missing_$($need[$needIndex])" } else { 'unknown' }
    $missing[$key] = 1 + [int]($missing[$key])
  }
}
Write-Output "chains_found: $chainHits"
foreach ($entry in $missing.GetEnumerator() | Sort-Object Name) {
  Write-Output "$($entry.Key): $($entry.Value)"
}

Write-Output ''
Write-Output '## Sequence Pattern 7 -> 8 -> 10 -> 9 -> 13'
$chainHits = 0
$missing = @{}
for ($i = 0; $i -lt $rows.Count; $i++) {
  if ((Row-Site $rows[$i]) -ne 7) { continue }
  $need = @(8, 10, 9, 13)
  $needIndex = 0
  $limit = [Math]::Min($rows.Count - 1, $i + $MaxLookaheadRows)
  for ($j = $i + 1; $j -le $limit -and $needIndex -lt $need.Count; $j++) {
    if ((Row-Site $rows[$j]) -eq $need[$needIndex]) {
      $needIndex++
    }
  }
  if ($needIndex -eq $need.Count) {
    $chainHits++
  } else {
    $key = if ($needIndex -lt $need.Count) { "missing_$($need[$needIndex])" } else { 'unknown' }
    $missing[$key] = 1 + [int]($missing[$key])
  }
}
Write-Output "chains_found: $chainHits"
foreach ($entry in $missing.GetEnumerator() | Sort-Object Name) {
  Write-Output "$($entry.Key): $($entry.Value)"
}

Write-Output ''
Write-Output '## B Delta To Site12 Nearest Correlation'
$site8 = @($rows | Where-Object { $_.site -eq '8' })
$site12 = @($rows | Where-Object { $_.site -eq '12' })
Write-Output "site8_rows: $($site8.Count)"
Write-Output "site12_rows: $($site12.Count)"
if ($site8.Count -gt 0 -and $site12.Count -gt 0) {
  $matches = 0
  $mismatches = New-Object System.Collections.Generic.List[object]
  $site12Index = 0
  foreach ($b in $site8) {
    while ($site12Index -lt $site12.Count -and [int64]$site12[$site12Index].sequence -lt [int64]$b.sequence) {
      $site12Index++
    }
    if ($site12Index -ge $site12.Count) { break }
    $s = $site12[$site12Index]
    $dx = [Math]::Abs((To-Double $b.delta_x) - (To-Double $s.delta_x))
    $dy = [Math]::Abs((To-Double $b.delta_y) - (To-Double $s.delta_y))
    if ($dx -le $Tolerance -and $dy -le $Tolerance) {
      $matches++
    } elseif ($mismatches.Count -lt 20) {
      $mismatches.Add([pscustomobject]@{
        b_sequence = $b.sequence
        site12_sequence = $s.sequence
        b_dx = $b.delta_x
        b_dy = $b.delta_y
        site12_dx = $s.delta_x
        site12_dy = $s.delta_y
        abs_dx = $dx
        abs_dy = $dy
      })
    }
  }
  Write-Output "nearest_matches: $matches"
  Write-Output "nearest_mismatches_sample_count: $($mismatches.Count)"
  if ($mismatches.Count -gt 0) {
    $mismatches | Format-Table -AutoSize
  }
}

Write-Output ''
Write-Output '## Site12 Ranges'
if ($site12.Count -gt 0) {
  $dxs = @($site12 | ForEach-Object { To-Double $_.delta_x })
  $dys = @($site12 | ForEach-Object { To-Double $_.delta_y })
  [pscustomobject]@{
    count = $site12.Count
    nonzero = @($site12 | Where-Object { NonZero $_ }).Count
    min_dx = ($dxs | Measure-Object -Minimum).Minimum
    max_dx = ($dxs | Measure-Object -Maximum).Maximum
    min_dy = ($dys | Measure-Object -Minimum).Minimum
    max_dy = ($dys | Measure-Object -Maximum).Maximum
  } | Format-List
}

Write-Output ''
Write-Output '## Site13 Camera Pair Write'
$site13 = @($rows | Where-Object { $_.site -eq '13' })
Write-Output "site13_rows: $($site13.Count)"
if ($site13.Count -gt 0) {
  $dxs = @($site13 | ForEach-Object { To-Double $_.delta_x })
  $dys = @($site13 | ForEach-Object { To-Double $_.delta_y })
  [pscustomobject]@{
    count = $site13.Count
    nonzero = @($site13 | Where-Object { NonZero $_ }).Count
    min_dx = ($dxs | Measure-Object -Minimum).Minimum
    max_dx = ($dxs | Measure-Object -Maximum).Maximum
    min_dy = ($dys | Measure-Object -Minimum).Minimum
    max_dy = ($dys | Measure-Object -Maximum).Maximum
    rcx_objects = @($site13 | Group-Object rcx).Count
  } | Format-List
}

Write-Output ''
Write-Output '## B Delta To Site13 Nearest Correlation'
Write-Output "site8_rows: $($site8.Count)"
Write-Output "site13_rows: $($site13.Count)"
if ($site8.Count -gt 0 -and $site13.Count -gt 0) {
  $matches = 0
  $mismatches = New-Object System.Collections.Generic.List[object]
  $site13Index = 0
  foreach ($b in $site8) {
    while ($site13Index -lt $site13.Count -and [int64]$site13[$site13Index].sequence -lt [int64]$b.sequence) {
      $site13Index++
    }
    if ($site13Index -ge $site13.Count) { break }
    $s = $site13[$site13Index]
    $dx = [Math]::Abs((To-Double $b.delta_x) - (To-Double $s.delta_x))
    $dy = [Math]::Abs((To-Double $b.delta_y) - (To-Double $s.delta_y))
    if ($dx -le $Tolerance -and $dy -le $Tolerance) {
      $matches++
    } elseif ($mismatches.Count -lt 20) {
      $mismatches.Add([pscustomobject]@{
        b_sequence = $b.sequence
        site13_sequence = $s.sequence
        b_dx = $b.delta_x
        b_dy = $b.delta_y
        site13_dx = $s.delta_x
        site13_dy = $s.delta_y
        abs_dx = $dx
        abs_dy = $dy
      })
    }
  }
  Write-Output "nearest_matches: $matches"
  Write-Output "nearest_mismatches_sample_count: $($mismatches.Count)"
  if ($mismatches.Count -gt 0) {
    $mismatches | Format-Table -AutoSize
  }
}

Write-Output ''
Write-Output '## Site9 Stack Arg28 Split'
$rows |
  Where-Object { $_.site -eq '9' } |
  Group-Object stack_arg28 |
  Sort-Object Count -Descending |
  ForEach-Object {
    [pscustomobject]@{
      stack_arg28 = $_.Name
      count = $_.Count
      nonzero = @($_.Group | Where-Object { NonZero $_ }).Count
    }
  } |
  Format-Table -AutoSize
