#!/bin/bash

# ---------------------------
# LLMChatBridge Build Script
# ---------------------------

set -e

PluginName="LLMChatBridge"
ProjectFile="Jellyfin.Plugin.$PluginName/Jellyfin.Plugin.$PluginName.csproj"
BuildOutputDir="Jellyfin.Plugin.$PluginName/bin/Release/net8.0"

echo -e "\033[0;36mBuilding $PluginName Plugin...\033[0m"

# Load .env file
if [ -f ".env" ]; then
    echo -e "\033[0;90mLoading .env...\033[0m"
    export $(grep -v '^#' .env | grep '=' | xargs)
else
    echo -e "\033[0;31mERROR: .env file not found. Create a .env file with PLUGIN_MOUNT=\\\\your-nas\\plugin-path\033[0m"
    exit 1
fi

# Validate PLUGIN_MOUNT
if [ -z "$PLUGIN_MOUNT" ]; then
    echo -e "\033[0;31mERROR: PLUGIN_MOUNT is not set in .env.\033[0m"
    exit 1
fi

if [ ! -d "$PLUGIN_MOUNT" ]; then
    echo -e "\033[0;31mERROR: PLUGIN_MOUNT path '$PLUGIN_MOUNT' does not exist or is not a directory.\033[0m"
    exit 1
fi

TargetDir="$PLUGIN_MOUNT/$PluginName"
echo -e "\033[0;36mResolved plugin root: $PLUGIN_MOUNT\033[0m"
echo -e "\033[0;36mResolved target plugin path: $TargetDir\033[0m"

# Clean + build
echo -e "\033[0;36mRunning dotnet build...\033[0m"
dotnet clean "$ProjectFile" > /dev/null
if ! dotnet build "$ProjectFile" -c Release --nologo; then
    echo -e "\033[0;31mERROR: Build failed. Check .csproj and plugin source.\033[0m"
    exit 1
fi

echo -e "\033[0;32mBuild succeeded.\033[0m"

# Validate build output
if [ ! -d "$BuildOutputDir" ]; then
    echo -e "\033[0;31mERROR: Build output directory '$BuildOutputDir' not found.\033[0m"
    exit 1
fi

# Create plugin directory if it doesn't exist
if [ ! -d "$TargetDir" ]; then
    echo -e "\033[0;90mCreating plugin directory: $TargetDir\033[0m"
    mkdir -p "$TargetDir" || {
        echo -e "\033[0;31mERROR: Failed to create plugin directory at '$TargetDir'\033[0m"
        exit 1
    }
fi

# Deploy plugin files
echo -e "\033[1;33mCopying plugin files from: $BuildOutputDir\033[0m"
for file in "$BuildOutputDir"/Jellyfin.Plugin."$PluginName".*; do
    cp -f "$file" "$TargetDir"/
    echo -e "\033[0;32mCopied: $(basename "$file") -> $TargetDir\033[0m"
done

echo -e "\n\033[0;32mBuild and deployment complete.\033[0m"

