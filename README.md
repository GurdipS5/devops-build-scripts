# Build Tools

[![Build Status](https://dev.azure.com/yourorg/yourproject/_apis/build/status/build-tools?branchName=main)](https://dev.azure.com/yourorg/yourproject/_build/latest?definitionId=1&branchName=main)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg?logo=powershell&logoColor=white)](https://docs.microsoft.com/en-us/powershell/)
[![.NET](https://img.shields.io/badge/.NET-6.0%20|%207.0%20|%208.0-purple.svg?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com/)
[![Python](https://img.shields.io/badge/Python-3.9%2B-yellow.svg?logo=python&logoColor=white)](https://www.python.org/)
[![Go](https://img.shields.io/badge/Go-1.21%2B-00ADD8.svg?logo=go&logoColor=white)](https://golang.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

A collection of build scripts and utilities for multi-language projects.

## Supported Languages

| Language | Version | Build Script | Status |
|----------|---------|--------------|--------|
| .NET Core | 6.0, 7.0, 8.0 | `dotnet-build.ps1` | ✅ |
| PowerShell | 5.1+ / 7.x | `ps-build.ps1` | ✅ |
| Python | 3.9+ | `python-build.ps1` | ✅ |
| Go | 1.21+ | `go-build.ps1` | ✅ |

## Quick Start

```powershell
# Clone the repository
git clone https://github.com/yourorg/build-tools.git
cd build-tools

# Run a build
.\scripts\dotnet-build.ps1 -ProjectPath "C:\src\MyApp"
```

## Installation

### Prerequisites

Ensure the following are installed on your system:

- **PowerShell** 5.1+ or PowerShell Core 7.x
- **.NET SDK** 6.0+ ([Download](https://dotnet.microsoft.com/download))
- **Python** 3.9+ ([Download](https://www.python.org/downloads/))
- **Go** 1.21+ ([Download](https://golang.org/dl/))

### Setup

```powershell
# Add to PATH (optional)
$env:PATH += ";C:\path\to\build-tools\scripts"

# Or import as module
Import-Module .\BuildTools.psd1
```

## Usage

### .NET Build

```powershell
# Basic build
.\dotnet-build.ps1

# Full pipeline: clean, build, test, publish
.\dotnet-build.ps1 -Clean -Test -Publish -Configuration Release

# Self-contained executable
.\dotnet-build.ps1 -Publish -Runtime win-x64 -SelfContained -SingleFile

# Target specific framework
.\dotnet-build.ps1 -Framework net8.0
```

**Parameters:**

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ProjectPath` | Path to .sln or .csproj | `.` |
| `-Configuration` | Debug or Release | `Release` |
| `-Runtime` | Target RID (win-x64, linux-x64, etc.) | - |
| `-Framework` | Target framework | - |
| `-Clean` | Clean before build | `false` |
| `-Test` | Run unit tests | `false` |
| `-Publish` | Publish artifacts | `false` |
| `-SelfContained` | Include .NET runtime | `false` |
| `-SingleFile` | Single file output | `false` |

### PowerShell Build

```powershell
# Analyze and test module
.\ps-build.ps1 -ModulePath .\src\MyModule

# Build with Pester tests
.\ps-build.ps1 -Test -CodeCoverage

# Package as .nupkg
.\ps-build.ps1 -Package -OutputDir .\artifacts
```

**Parameters:**

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ModulePath` | Path to module | `.` |
| `-Test` | Run Pester tests | `false` |
| `-CodeCoverage` | Generate coverage report | `false` |
| `-Analyze` | Run PSScriptAnalyzer | `false` |
| `-Package` | Create NuGet package | `false` |

### Python Build

```powershell
# Build with pip
.\python-build.ps1 -ProjectPath .\myapp

# Create virtual environment and install deps
.\python-build.ps1 -CreateVenv -Install

# Run tests with pytest
.\python-build.ps1 -Test -Coverage

# Build wheel package
.\python-build.ps1 -Package -OutputDir .\dist
```

**Parameters:**

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ProjectPath` | Path to project | `.` |
| `-CreateVenv` | Create virtual environment | `false` |
| `-Install` | Install dependencies | `false` |
| `-Test` | Run pytest | `false` |
| `-Coverage` | Generate coverage report | `false` |
| `-Lint` | Run flake8/pylint | `false` |
| `-Package` | Build wheel/sdist | `false` |

### Go Build

```powershell
# Build binary
.\go-build.ps1 -ProjectPath .\myapp

# Build with race detection
.\go-build.ps1 -Race

# Cross-compile for Linux
.\go-build.ps1 -GOOS linux -GOARCH amd64

# Run tests with coverage
.\go-build.ps1 -Test -Coverage
```

**Parameters:**

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ProjectPath` | Path to Go module | `.` |
| `-OutputName` | Binary name | project name |
| `-GOOS` | Target OS | current |
| `-GOARCH` | Target architecture | current |
| `-Race` | Enable race detector | `false` |
| `-Test` | Run tests | `false` |
| `-Coverage` | Generate coverage | `false` |
| `-Lint` | Run golangci-lint | `false` |

## CI/CD Integration

### Azure DevOps

```yaml
trigger:
  - main

pool:
  vmImage: 'windows-latest'

steps:
  - checkout: self

  - task: PowerShell@2
    displayName: 'Build .NET'
    inputs:
      filePath: '$(Build.SourcesDirectory)/scripts/dotnet-build.ps1'
      arguments: '-Clean -Test -Publish -Configuration Release'

  - task: PublishBuildArtifacts@1
    inputs:
      PathtoPublish: '$(Build.SourcesDirectory)/publish'
      ArtifactName: 'drop'
```

### GitHub Actions

```yaml
name: Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'

      - name: Build
        shell: pwsh
        run: .\scripts\dotnet-build.ps1 -Clean -Test -Publish

      - name: Upload Artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: publish/
```

## Project Structure

```
build-tools/
├── scripts/
│   ├── dotnet-build.ps1    # .NET Core build script
│   ├── ps-build.ps1        # PowerShell module build
│   ├── python-build.ps1    # Python build script
│   └── go-build.ps1        # Go build script
├── templates/
│   ├── azure-pipelines.yml
│   └── github-actions.yml
├── tests/
│   └── *.Tests.ps1
├── docs/
│   └── *.md
├── BuildTools.psd1
├── BuildTools.psm1
├── LICENSE
└── README.md
```

## Configuration

Create a `build-config.json` in your project root:

```json
{
  "dotnet": {
    "configuration": "Release",
    "framework": "net8.0",
    "runtime": "win-x64",
    "selfContained": true
  },
  "python": {
    "version": "3.11",
    "venvPath": ".venv"
  },
  "go": {
    "version": "1.21",
    "ldflags": "-s -w"
  }
}
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and contribution guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for release history.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📫 **Issues**: [GitHub Issues](https://github.com/yourorg/build-tools/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourorg/build-tools/discussions)
- 📖 **Docs**: [Wiki](https://github.com/yourorg/build-tools/wiki)
