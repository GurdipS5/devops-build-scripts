param (
    [Parameter(Mandatory = $true)]
    [string]$NDependConsoleExe,

    [Parameter(Mandatory = $true)]
    [string]$ProjectFile,

    [string]$OutDir = "ndepend-results",

    [string]$BaselineDir = "ndepend-baseline",

    [switch]$FailOnCriticalRules
)

Write-Host "🔍 Running NDepend analysis"
Write-Host "Project: $ProjectFile"

if (-not (Test-Path $NDependConsoleExe)) {
    throw "NDepend.Console.exe not found at $NDependConsoleExe"
}

if (-not (Test-Path $ProjectFile)) {
    throw "NDepend project file not found: $ProjectFile"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$ndependArgs = @(
    "`"$ProjectFile`"",
    "/OutDir `"$OutDir`"",
    "/Silent"
)

if (Test-Path $BaselineDir) {
    Write-Host "Using baseline: $BaselineDir"
    $ndependArgs += "/BaselineDir `"$BaselineDir`""
}

Write-Host "Running:"
Write-Host "$NDependConsoleExe $($ndependArgs -join ' ')"

& $NDependConsoleExe $ndependArgs

if ($LASTEXITCODE -ne 0) {
    throw "❌ NDepend execution failed"
}

# Optional: Fail build on critical rules
if ($FailOnCriticalRules) {
    $reportPath = Join-Path $OutDir "Report.xml"

    if (-not (Test-Path $reportPath)) {
        throw "NDepend report not found"
    }

    [xml]$report = Get-Content $reportPath
    $criticalIssues = $report.SelectNodes("//Rule[@Critical='True']/Violation")

    if ($criticalIssues.Count -gt 0) {
        Write-Error "❌ Critical NDepend rule violations detected"
        exit 1
    }
}

Write-Host "✅ NDepend analysis completed successfully"
