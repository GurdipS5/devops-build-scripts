param (
    [string]$Config = "p/ci",
    [string]$OutputDir = "semgrep-results"
)

Write-Host "🔍 Running Semgrep main branch scan"

# Ensure Semgrep is installed
if (-not (Get-Command semgrep -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Semgrep..."
    pip install --user semgrep
    $env:PATH += ";$env:APPDATA\Python\Python*\Scripts"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$resultsFile = Join-Path $OutputDir "results.json"

$semgrepArgs = @(
    "scan",
    "--config=$Config",
    "--json",
    "--output=$resultsFile",
    "--error",
    "--metrics=off"
)

Write-Host "Running:"
Write-Host "semgrep $($semgrepArgs -join ' ')"

semgrep @semgrepArgs

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Semgrep violations found on main"
    exit 1
}

Write-Host "✅ Semgrep main scan passed"
Write-Host "Results saved to $resultsFile"
