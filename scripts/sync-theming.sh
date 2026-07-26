#!/usr/bin/env bash
set -euo pipefail

# Sync theming assets and generated wallpapers/logo into archiso/airootfs
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMING_SRC="$REPO_ROOT/theming"
AIROOTFS="$REPO_ROOT/archiso/airootfs"

mkdir -p "$AIROOTFS/usr/share"

# Stub: copy theme directories if they exist
if [ -d "$THEMING_SRC/plasma" ]; then
  mkdir -p "$AIROOTFS/usr/share/plasma"
  cp -r "$THEMING_SRC/plasma"/* "$AIROOTFS/usr/share/plasma/" || true
fi

if [ -d "$THEMING_SRC/sddm" ]; then
  mkdir -p "$AIROOTFS/usr/share/sddm/themes"
  cp -r "$THEMING_SRC/sddm" "$AIROOTFS/usr/share/sddm/themes/" || true
fi

if [ -d "$THEMING_SRC/grub" ]; then
  mkdir -p "$AIROOTFS/usr/share/grub/themes"
  cp -r "$THEMING_SRC/grub" "$AIROOTFS/usr/share/grub/themes/" || true
fi

if [ -d "$THEMING_SRC/wallpapers" ]; then
  mkdir -p "$AIROOTFS/usr/share/backgrounds/zog"
  cp -r "$THEMING_SRC/wallpapers"/* "$AIROOTFS/usr/share/backgrounds/zog/" || true
fi

echo "Theming synced to airootfs"
