#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/.build"
PLAN_FILE="${SCRIPT_DIR}/private-build-plans.toml"

# Clone Iosevka if needed
if [[ -d "${BUILD_DIR}/.git" ]]; then
    echo "Using existing Iosevka clone..."
    cd "${BUILD_DIR}"
else
    echo "Cloning Iosevka..."
    rm -rf "${BUILD_DIR}"
    git clone --depth 1 https://github.com/be5invis/Iosevka.git "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    echo "Installing dependencies..."
    npm install
fi

# Copy build plan
cp "${PLAN_FILE}" "${BUILD_DIR}/"
brew install ttfautohint

echo "Building font..."
npm run build -- contents::IosevkaBerkeley

# Install fonts
echo "Installing fonts..."
cp "${BUILD_DIR}"/dist/IosevkaBerkeley/TTF/*.ttf ~/Library/Fonts/

echo ""
echo "Done! Fonts installed to ~/Library/Fonts/"
