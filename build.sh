#!/usr/bin/env bash

# ---------------------------
# LLMChatBridge Build Script
# ---------------------------

set -euo pipefail

PLUGIN_NAME="LLMChatBridge"
PROJECT_FILE="Jellyfin.Plugin.${PLUGIN_NAME}/Jellyfin.Plugin.${PLUGIN_NAME}.csproj"
BUILD_OUTPUT_DIR="Jellyfin.Plugin.${PLUGIN_NAME}/bin/Release/net8.0"

# Ensure dotnet is installed and matches SDK requirement
if ! command -v dotnet &>/dev/null; then
    echo "ERROR: .NET SDK is not installed or not on PATH." >&2
    exit 1
fi

DOTNET_VERSION=$(dotnet --version)
if [[ ! "$DOTNET_VERSION" =~ ^8\. ]] && [[ ! "$DOTNET_VERSION" =~ ^9\. ]]; then
    echo "WARNING: Expected .NET SDK 8.x or compatible, but found $DOTNET_VERSION" >&2
fi

echo "Building ${PLUGIN_NAME} Plugin..."

# Load environment variables from .env
if [[ -f ".env" ]]; then
    echo "Loading .env..."
    while IFS='=' read -r key value; do
        if [[ "$key" =~ ^# ]] || [[ -z "$key" ]]; then continue; fi
        export "$key"="$(echo "$value" | sed -e 's/^ *//' -e 's/ *$//')"
    done < <(grep '=' .env)
else
    echo "ERROR: .env file not found. Create a .env file with PLUGIN_MOUNT=//your-nas/plugin-path" >&2
    exit 1
fi

# Validate PLUGIN_MOUNT
if [[ -z "${PLUGIN_MOUNT:-}" ]]; then
    echo "ERROR: PLUGIN_MOUNT is not set in .env." >&2
    exit 1
fi

if [[ ! -d "$PLUGIN_MOUNT" ]]; then
    echo "ERROR: PLUGIN_MOUNT path '$PLUGIN_MOUNT' does not exist or is not a directory." >&2
    exit 1
fi

TARGET_DIR="${PLUGIN_MOUNT}/${PLUGIN_NAME}"
echo "Resolved plugin root: $PLUGIN_MOUNT"
echo "Resolved target plugin path: $TARGET_DIR"

# Clean + build
echo "Running dotnet build..."
dotnet clean "$PROJECT_FILE" >/dev/null
dotnet build "$PROJECT_FILE" -c Release --nologo

if [[ $? -ne 0 ]]; then
    echo "ERROR: Build failed. Check .csproj and plugin source." >&2
    exit 1
fi

echo "Build succeeded."

# Validate build output
if [[ ! -d "$BUILD_OUTPUT_DIR" ]]; then
    echo "ERROR: Build output directory '$BUILD_OUTPUT_DIR' not found." >&2
    exit 1
fi

# Create plugin directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Deploy plugin files
echo "Copying plugin files from: $BUILD_OUTPUT_DIR"
for file in "$BUILD_OUTPUT_DIR"/Jellyfin.Plugin."$PLUGIN_NAME".*; do
    cp "$file" "$TARGET_DIR/"
    echo "Copied: $(basename "$file") -> $TARGET_DIR"
done

echo ""
echo "Build and deployment complete."
