param (
    [Parameter(Mandatory = $true)]
    [string]$OctopusUrl,

    [Parameter(Mandatory = $true)]
    [string]$ApiKey,

    [Parameter(Mandatory = $true)]
    [string]$ProjectName,

    [Parameter(Mandatory = $true)]
    [string]$ReleaseVersion,

    [string]$Space = "Default",

    [string]$Channel,

    [switch]$DeployTo,
    
    [string]$Environment
)

Write-Host "Creating Octopus Deploy release..."
Write-Host "Project: $ProjectName"
Write-Host "Version: $ReleaseVersion"
Write-Host "Space: $Space"

$cmd = @(
    "octo",
    "create-release",
    "--server `"$OctopusUrl`"",
    "--apiKey `"$ApiKey`"",
    "--project `"$ProjectName`"",
    "--version `"$ReleaseVersion`"",
    "--space `"$Space`"",
    "--progress"
)

if ($Channel) {
    $cmd += "--channel `"$Channel`""
}

if ($DeployTo -and $Environment) {
    $cmd += "--deployTo `"$Environment`""
}

$commandLine = $cmd -join " "
Write-Host "Running:"
Write-Host $commandLine

Invoke-Expression $commandLine

if ($LASTEXITCODE -ne 0) {
    throw "Octopus release creation failed"
}

Write-Host "✅ Release created successfully"
