#!/usr/bin/env bash
set -euo pipefail

echo "=== Zog Build System ==="
echo ""

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

# Step 1: Generate package list
echo "[1/3] Generating package list..."
bash scripts/gen-packages.sh

# Step 2: Sync theming
echo "[2/3] Syncing theming assets..."
bash scripts/sync-theming.sh || echo "Warning: theming sync had issues, continuing..."

# Step 3: Build ISO
echo "[3/3] Building ISO..."
if command -v mkarchiso >/dev/null 2>&1; then
  mkdir -p dist
  mkarchiso -v -w work -o dist archiso
  echo ""
  echo "ISO built successfully!"
  ls -lh dist/*.iso
else
  echo "Error: mkarchiso not found"
  echo "Install with: pacman -S archiso (on Arch Linux)"
  echo "Or use Docker: make iso-docker"
  exit 1
fi
