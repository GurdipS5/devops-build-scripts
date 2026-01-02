param (
    [ValidateSet("code", "open-source", "container", "iac")]
    [string]$ScanType = "open-source",

    [string]$SeverityThreshold = "high",

    [string]$OutputDir = "snyk-results",

    [switch]$Json,

    [switch]$FailOnIssues
)

Write-Host "🔐 Running Snyk scan ($ScanType)"

# Ensure Snyk CLI is installed
if (-not (Get-Command snyk -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Snyk CLI..."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install snyk.snyk -e --silent
    } else {
        throw "Snyk CLI not found and winget is unavailable"
    }
}

# Auth check
if (-not $env:SNYK_TOKEN) {
    throw "SNYK_TOKEN environment variable is not set"
}

snyk auth $env:SNYK_TOKEN | Out-Null

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$cmd = @("snyk")

switch ($ScanType) {
    "code" {
        $cmd += "code test"
    }
    "open-source" {
        $cmd += "test"
    }
    "container" {
        $cmd += "container test"
    }
    "iac" {
        $cmd += "iac test"
    }
}

$cmd += "--severity-threshold=$SeverityThreshold"

if ($Json) {
    $outputFile = Join-Path $OutputDir "$ScanType.json"
    $cmd += "--json"
    $cmd += "> `"$outputFile`""
}

Write-Host "Running:"
Write-Host ($cmd -join " ")

Invoke-Expression ($cmd -join " ")

if ($LASTEXITCODE -ne 0 -and $FailOnIssues) {
    Write-Error "❌ Snyk issues detected"
    exit 1
}

Write-Host "✅ Snyk scan completed"
