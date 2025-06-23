# ---------------------------
# LLMChatBridge Build Script
# ---------------------------

$PluginName = "LLMChatBridge"
$ProjectFile = "Jellyfin.Plugin.$PluginName\Jellyfin.Plugin.$PluginName.csproj"
$BuildOutputDir = "Jellyfin.Plugin.$PluginName\bin\Release\net8.0"

Write-Host "Building $PluginName Plugin..." -ForegroundColor Cyan

# Load environment variables
if (Test-Path ".env") {
    Write-Host "Loading .env..." -ForegroundColor DarkGray
    Get-Content ".env" |
        Where-Object { $_ -match "=" -and -not $_.Trim().StartsWith("#") } |
        ForEach-Object {
            $parts = $_ -split '=', 2
            if ($parts.Length -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                Set-Item -Path "Env:$key" -Value $value
            }
        }
} else {
    Write-Host "ERROR: .env file not found. Create a .env file with PLUGIN_MOUNT=\\your-nas\plugin-path" -ForegroundColor Red
    exit 1
}

# Validate PLUGIN_MOUNT
if (-not $env:PLUGIN_MOUNT) {
    Write-Host "ERROR: PLUGIN_MOUNT is not set in .env." -ForegroundColor Red
    exit 1
}

$MountPath = Resolve-Path $env:PLUGIN_MOUNT -ErrorAction SilentlyContinue

if (-not $MountPath) {
    Write-Host "ERROR: PLUGIN_MOUNT path '$($env:PLUGIN_MOUNT)' does not resolve or does not exist." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $MountPath -PathType Container)) {
    Write-Host "ERROR: PLUGIN_MOUNT '$MountPath' is not a valid directory." -ForegroundColor Red
    exit 1
}

$TargetDir = Join-Path $MountPath $PluginName
Write-Host "Resolved plugin root: $MountPath" -ForegroundColor DarkCyan
Write-Host "Resolved target plugin path: $TargetDir" -ForegroundColor DarkCyan

# Clean + build
Write-Host "Running dotnet build..." -ForegroundColor Cyan
dotnet clean $ProjectFile | Out-Null
dotnet build $ProjectFile -c Release --nologo

if (-not $?) {
    Write-Host "ERROR: Build failed. Check .csproj and plugin source." -ForegroundColor Red
    exit 1
}

Write-Host "Build succeeded." -ForegroundColor Green

# Validate build output
$ResolvedBuildDir = Resolve-Path $BuildOutputDir -ErrorAction SilentlyContinue

if (-not $ResolvedBuildDir) {
    Write-Host "ERROR: Build output directory '$BuildOutputDir' not found." -ForegroundColor Red
    exit 1
}

# Create plugin directory if it doesn't exist
if (-not (Test-Path $TargetDir)) {
    Write-Host "Creating plugin directory: $TargetDir" -ForegroundColor DarkGray
    try {
        New-Item -ItemType Directory -Path $TargetDir -Force -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "ERROR: Failed to create plugin directory at '$TargetDir': $_" -ForegroundColor Red
        exit 1
    }
}

# Deploy plugin files
Write-Host "Copying plugin files from: $ResolvedBuildDir" -ForegroundColor Yellow
Get-ChildItem $ResolvedBuildDir -Filter "Jellyfin.Plugin.$PluginName.*" | ForEach-Object {
    Copy-Item $_.FullName -Destination $TargetDir -Force
    Write-Host "Copied: $($_.Name) -> $TargetDir" -ForegroundColor Green
}

Write-Host "`nBuild and deployment complete." -ForegroundColor Green
