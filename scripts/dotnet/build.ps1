param (
    [string]$Solution = "*.sln",
    [string]$Configuration = "Release",
    [switch]$Restore = $true,
    [switch]$NoLogo = $true
)

Write-Host "🏗️ Running dotnet build"
Write-Host "Solution/Project: $Solution"
Write-Host "Configuration: $Configuration"

# Ensure dotnet CLI exists
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    throw "dotnet CLI not found"
}

# Optional restore
if ($Restore) {
    Write-Host "🔄 Restoring packages..."
    dotnet restore $Solution
    if ($LASTEXITCODE -ne 0) { throw "dotnet restore failed" }
}

# Build
$buildArgs = @("build", $Solution, "-c", $Configuration)
if ($NoLogo) { $buildArgs += "--nologo" }

Write-Host "Executing: dotnet $($buildArgs -join ' ')"
dotnet @buildArgs

if ($LASTEXITCODE -ne 0) {
    throw "❌ dotnet build failed"
}

Write-Host "✅ dotnet build completed successfully"
