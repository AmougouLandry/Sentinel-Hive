$src = ".\exports\cowrie\cowrie.json"
$day = Get-Date -Format "yyyy-MM-dd"
$dst = ".\exports\cowrie\cowrie.json.$day"
$stateFile = ".\exports\cowrie\.cowrie_offset"

if (!(Test-Path $src)) { Write-Host "Missing $src"; exit 1 }

# offset (nombre de lignes déjà exportées)
$offset = 0
if (Test-Path $stateFile) {
  $offset = [int](Get-Content $stateFile -ErrorAction SilentlyContinue)
}

# lire toutes les lignes
$lines = Get-Content $src
$total = $lines.Count

if ($total -le $offset) {
  Write-Host "No new lines to export."
  exit 0
}

# nouvelles lignes uniquement
$newLines = $lines[$offset..($total-1)]
$newLines | Add-Content $dst

# mettre à jour l’offset
Set-Content $stateFile $total

Write-Host "Exported $($newLines.Count) new lines to $dst"
