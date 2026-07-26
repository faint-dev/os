#!/usr/bin/env bash
set -euo pipefail

# Sync every theming/ subdirectory into its correct archiso/airootfs location.
# Unknown subdirectories produce a warning instead of being silently skipped,
# so new theme dirs can't quietly fail to ship in the ISO.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMING_SRC="$REPO_ROOT/theming"
AIROOTFS="$REPO_ROOT/archiso/airootfs"

[ -d "$THEMING_SRC" ] || { echo "No theming/ directory, nothing to sync"; exit 0; }

synced=0
for dir in "$THEMING_SRC"/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")

  # Skip empty directories (e.g. placeholders with only a README)
  if [ -z "$(find "$dir" -type f ! -name 'README*' -print -quit)" ]; then
    echo "Skipping theming/$name (no theme files)"
    continue
  fi

  case "$name" in
    plasma)
      mkdir -p "$AIROOTFS/usr/share/plasma"
      cp -r "$dir." "$AIROOTFS/usr/share/plasma/"
      ;;
    sddm)
      mkdir -p "$AIROOTFS/usr/share/sddm/themes"
      cp -r "$dir." "$AIROOTFS/usr/share/sddm/themes/"
      ;;
    grub)
      mkdir -p "$AIROOTFS/usr/share/grub/themes"
      cp -r "$dir." "$AIROOTFS/usr/share/grub/themes/"
      ;;
    plymouth)
      mkdir -p "$AIROOTFS/usr/share/plymouth/themes"
      cp -r "$dir." "$AIROOTFS/usr/share/plymouth/themes/"
      ;;
    wallpapers)
      mkdir -p "$AIROOTFS/usr/share/backgrounds/zog"
      cp -r "$dir." "$AIROOTFS/usr/share/backgrounds/zog/"
      ;;
    kvantum)
      mkdir -p "$AIROOTFS/etc/skel/.config/Kvantum"
      cp -r "$dir." "$AIROOTFS/etc/skel/.config/Kvantum/"
      ;;
    hyprland)
      mkdir -p "$AIROOTFS/etc/skel/.config/hypr"
      cp -r "$dir." "$AIROOTFS/etc/skel/.config/hypr/"
      ;;
    waybar|mako|wofi|hyprlock)
      mkdir -p "$AIROOTFS/etc/skel/.config/$name"
      cp -r "$dir." "$AIROOTFS/etc/skel/.config/$name/"
      ;;
    cursors)
      # Cursor theme ships as a package (bibata-cursor-theme-bin via
      # chaotic-aur), not vendored files — nothing to copy.
      ;;
    *)
      echo "Warning: no sync rule for theming/$name — add one to sync-theming.sh" >&2
      ;;
  esac
  synced=$((synced + 1))
done

echo "Theming synced ($synced directories processed)"
