# Building Zog

This document explains how to build the Zog ISO from source.

## Prerequisites

### For CI/CD (Recommended)

- Push to GitHub
- Let GitHub Actions (native x86_64 runners) build the ISO
- Download from Releases

### For Local Builds

**On Linux (Arch/Fedora):**
- `archiso` package
- `dosfstools`, `libisoburn`, `libisofs`
- ~30GB free disk space
- x86_64 CPU (native builds)

**On macOS (Apple Silicon):**
- Docker + OrbStack (for x86_64 emulation)
- QEMU (optional, for testing ISOs locally)
- ~50GB free disk space (emulation overhead)

## Quick Start

### Via GitHub Actions (Best)

```bash
git push origin main
# Check https://github.com/faint-dev/os/actions for build status
# Download ISO from Releases
```

### Local Build on Linux

```bash
# Install archiso
sudo pacman -S archiso

# Build
./build.sh

# Output: dist/zog-*.iso
```

### Local Build on macOS (Docker)

```bash
# Ensure OrbStack is running
orbctl start

# Build (will take 30-60 mins due to x86_64 emulation)
make iso-docker

# Output: dist/zog-*.iso
```

## Testing the ISO

### QEMU (requires qemu)

```bash
brew install qemu  # macOS
sudo pacman -S qemu  # Linux

make test  # Boots ISO in QEMU, exits on login screen
```

### Physical USB (ThinkPad L13)

```bash
# Flash with Balena Etcher or Ventoy
# Insert USB, boot from it
# Follow on-screen installer
```

## Troubleshooting

### Build fails: "chaotic-aur key not found" / "no secret key available to sign with"

The GitHub Actions workflow bootstraps the Chaotic AUR keyring automatically. For
local builds on Arch, run the full bootstrap (the keyring must be initialized
first — skipping `--init`/`--populate` causes "There is no secret key available
to sign with"):

```bash
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
  'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
```

`archiso/pacman.conf` references `/etc/pacman.d/chaotic-mirrorlist`, which the
`chaotic-mirrorlist` package installs on the build host.

### Package not found

Ensure all package list files are present:

```bash
ls -la archiso/packages/
```

Should show: `base.txt`, `drivers.txt`, `desktop-plasma.txt`, `terminal-tools.txt`, etc.

### mkarchiso not available

Install archiso:

```bash
# Arch
sudo pacman -S archiso

# Ubuntu/Debian
sudo apt install archiso

# macOS
Use Docker: make iso-docker
```

## Development Workflow

1. Make changes to package lists (`archiso/packages/*.txt`), theming, or configs
2. Test locally: `./build.sh` (Linux) or `make iso-docker` (macOS)
3. Boot in QEMU or physical hardware
4. Push to main → CI builds and uploads artifacts
5. Tag for release: `scripts/release.sh 1.0.1` → creates GitHub Release

## File Organization

- `archiso/` – ISO build root (mkarchiso profile)
  - `packages/` – Source package lists (split by category)
  - `packages.x86_64` – Generated package list (don't edit directly)
  - `airootfs/` – Files to be copied into live + installed system
  - `profiledef.sh` – mkarchiso configuration
  - `pacman.conf` – Pacman repos (includes Chaotic AUR for calamares)

- `scripts/` – Build automation
  - `gen-packages.sh` – Concatenate `packages/*.txt` → `packages.x86_64`
  - `sync-theming.sh` – Copy theme assets into airootfs
  - `build-local.sh` – Docker wrapper for macOS

- `theming/` – Visual assets (KDE themes, wallpapers, GRUB theme, etc.)
  - `plasma/` – KDE Plasma look-and-feel, color schemes
  - `sddm/` – Login screen theme
  - `grub/` – Bootloader theme
  - `wallpapers/` – Generated + bundled images
  - `hyprland/` – Hyprland config + theme

- `.github/workflows/` – CI/CD pipelines
  - `build-iso.yml` – Main build job (creates ISO artifact, publishes releases)
  - `lint.yml` – Basic checks (shellcheck, package validation)

## See Also

- [ARCHITECTURE.md](ARCHITECTURE.md) – Design decisions, component overview
- [HARDWARE-NOTES.md](HARDWARE-NOTES.md) – ThinkPad L13 specific tuning
- [README.md](../README.md) – Quick introduction
