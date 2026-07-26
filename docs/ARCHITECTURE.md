# Zog Architecture

## Overview

Zog is a custom Arch Linux distribution with a focus on visual polish, performance, and developer ergonomics for the Lenovo ThinkPad L13 (i3-11th gen, 8GB RAM, 256GB SSD).

## Key Design Decisions

### OS Foundation: Arch Linux

**Why Arch?**
- Rolling release (latest software, security patches)
- Minimal base (we control what's installed)
- AUR access (community packages)
- Excellent package management (pacman)

**Alternative considered:** Fedora (more stable, but heavier)

### Desktop Environment: KDE Plasma 6 (+ Hyprland alternative)

**Why Plasma 6?**
- Modern, beautiful UI with native glassmorphism + blur effects
- Excellent customization (theming, widgets, animations)
- Native screenshot, clipboard manager, search launcher, workspace overview
- Gesture support (libinput touchpad)
- Mature Wayland support

**Why also Hyprland?**
- Tiling window manager (efficient for power users)
- Minimal, fast, highly configurable
- Great for laptop workflows
- Available as secondary session at login

### Build Strategy: CI-First

**Why GitHub Actions (not local builds)?**

Local builds on Apple Silicon:
- x86_64 target requires emulation (QEMU/OrbStack)
- Very slow (multi-hour builds)
- Fragile (emulation bugs)

GitHub Actions:
- Native x86_64 runners (fast, ~15–20 min builds)
- Reliable, reproducible
- Automatic releases on git tags
- Free for public repos

**Local Docker path:** Available for quick iteration, documented but not primary.

### Hardware Optimization

**Intel i3-11th gen (Rocket Lake):**
- Intel iGPU (Xe Graphics): `xf86-video-intel`, `mesa`, `vulkan-intel`, `intel-media-driver`
- 8GB RAM: Zram (compressed in-memory swap), low-bloat packages
- 256GB SSD: EXT4 with `noatime`, periodic `fstrim`, avoid large bloat
- **Power tuning via TLP:**
  - Battery thresholds (20–80%), CPU throttling, GPU underclocking on battery
  - USB autosuspend, wireless power save, fast boot (Plymouth quiet splash)

### File System & Partitioning

**Installer (Calamares) creates:**
- EFI System Partition (ESP): 512 MB, FAT32
- Root (`/`): 30–50 GB, EXT4
- Home (`/home`): Remaining space, EXT4

**Bootloader:** systemd-boot only (EFI; simple, fast, Secure Boot-friendly). No GRUB.

### Security Posture

- **Firewall:** UFW enabled by default (deny all incoming, allow all outgoing)
- **Users:** No root password (sudo-only via wheel group)
- **Wayland:** Default session (more secure than X11)
- **Flatpak:** Sandboxing for third-party apps
- **Secure Boot:** Best-effort self-signed (Microsoft-cert not feasible for indie distro)
- **Auto-updates:** Notify-only timer (safer than silent `pacman -Syu` on rolling-release)

### Performance Targets (and Reality Check)

- **Boot time <12 seconds:** Achieved via Plymouth quiet boot, systemd optimizations, no bloat
  - Real outcome depends on SSD speed, BIOS settings, motherboard firmware
- **60 FPS desktop:** KWin animation settings, Intel GPU tuning, no bloat
  - Validated on i3-11th gen iGPU; may vary with other hardware
- **Low idle power:** TLP power profile, CPU/GPU throttling, USB autosuspend
  - ~1–3W idle with typical workload; actual numbers need hardware measurement

## Component Breakdown

### Live Environment (ISO Boot)

- `archiso/profiledef.sh` – mkarchiso profile (boot entries, kernel params, etc.)
- `archiso/airootfs/` – Files copied into the live filesystem
- Plymouth theme – Custom boot splash with Zog logo
- SDDM theme – Beautiful login screen (live & installed)
- Systemd presets – Auto-start essentials (NetworkManager, TLP, etc.)

### Installation (Calamares)

- `calamares/settings.conf` – Installer orchestration
- `calamares/modules/*.conf` – Partition, users, packages, summary steps
- `calamares/branding/` – Zog logo, installer wallpaper, colors
- Post-install script – Apply themes, security config, create default user files

### Theming

- **KDE Plasma:** Look-and-feel, color scheme, taskbar layout, window decorations
- **Hyprland:** `hyprland.conf`, waybar config, wofi launcher, mako notifications
- **SDDM:** Login screen theme (matches Plasma/Hyprland aesthetic)
- **Wallpapers:** Procedurally-generated images (dark/light variants), matching accent colors

#### Icons & Cursors

- **Icon theme:** Papirus-Dark (`papirus-icon-theme`, official Arch repo) — set as
  default in skel `kdeglobals`
- **Cursor theme:** Bibata Modern Classic (`bibata-cursor-theme-bin` via
  chaotic-aur, same build-time repo used for Calamares) — wired as the
  system-wide default (`/usr/share/icons/default/index.theme`), in KDE
  (`kdeglobals` `[Cursor]`), and in Hyprland (`XCURSOR_THEME`/`XCURSOR_SIZE`
  env vars)

### Package Lists (Modular)

- `packages/base.txt` – Kernel, bootloader, systemd, essential tools
- `packages/drivers.txt` – Intel GPU, audio, networking drivers
- `packages/desktop-plasma.txt` – KDE Plasma 6 + components
- `packages/desktop-hyprland.txt` – Hyprland + related tools
- `packages/terminal-tools.txt` – Modern CLI: starship, eza, fzf, ripgrep, fd, bat, etc.
- `packages/fonts.txt` – Inter, JetBrains Mono, Noto Fonts, Liberation, etc.
- `packages/apps.txt` – Firefox, VS Code, Git, Docker, GIMP, VLC, OBS, etc.
- `packages/calamares.txt` – Installer (via Chaotic AUR at build time only)

**Fallbacks for AUR-only packages:**
- `grimblast` → hand-written `grim`+`slurp`+`wl-copy` wrapper (Hyprland screenshot)
- `spotify` → `spotify-launcher` (Flatpak for full client)
- `spicetify-cli` → Not in base ISO (user can install post-install via AUR or pip)
- `code-bin` → `code` (official VSCode, auto-updates)

### System Configuration

- `/etc/tlp.conf` – Power management tuned for L13 (ThinkPad-specific)
- `/etc/NetworkManager/conf.d/` – Wi-Fi + iwd backend
- `/etc/modprobe.d/` – Kernel module tweaks (i915 PSR/FBC, watchdog disabled)
- `/etc/ufw/` – Firewall rules (default deny incoming)
- `/etc/systemd/system-preset/` – Services auto-enabled at boot
- `/boot/loader/` – systemd-boot entries (quiet, intel_pstate=passive)
- `/etc/systemd/zram-generator.conf` – Swap-on-zram (4GB zstd-compressed on 8GB RAM)

## Build Pipeline

```
User pushes to main/tags
         ↓
GitHub Actions (build-iso.yml)
         ↓
Container: archlinux:base-devel
         ↓
Install archiso, import Chaotic AUR key
         ↓
scripts/gen-packages.sh (packages/*.txt → packages.x86_64)
         ↓
scripts/sync-theming.sh (copy theming/ → archiso/airootfs/)
         ↓
mkarchiso (builds ISO)
         ↓
Generate SHA256SUMS
         ↓
Upload artifact to GitHub
         ↓
If git tag (v*): Create GitHub Release + publish
```

## Optimization Strategies

### CPU/Power
- TLP daemon (battery/AC profiles, CPU scaling, turbo control)
- intel_pstate in passive mode (better integration with systemd)
- CPU min/max frequencies tuned per profile (AC: 1.4–4.8 GHz, battery: 1.4–2.4 GHz)

### GPU
- Intel iGPU memory management (PSR, FBC enabled)
- GPU underclocking on battery (400–600 MHz vs 400–1200 MHz AC)
- KWin CPU/energy optimizations

### Disk
- EXT4 mount option `noatime` (avoid inode touch on read)
- Periodic `fstrim` via systemd timer (TRIM support for SSD)
- Zram swap (compressed in-memory, faster than disk)

### Memory
- No bloat: minimal base + conscious package selection
- Zram instead of swap file (8GB → 10–12GB effective with compression)

### Network
- iwd backend for faster Wi-Fi scanning + connection
- USB autosuspend (reduce USB device power draw)

## Security Notes

### Secure Boot

Zog ships with self-signed Secure Boot support (not Microsoft-certified):

1. During install, `sbctl` generates a self-signed Secure Boot key
2. User enters BIOS Setup Mode and enrolls the key
3. Kernel + bootloader are signed with this key
4. System boots in Secure Boot mode

**Limitation:** Not Microsoft-signed, so only works after key enrollment. Enterprise environments requiring Microsoft-certified Secure Boot are out of scope.

### User Permissions

- Root password: **Not set** (forcing sudo-only usage)
- Default user: Added to `wheel` group (full sudo access)
- Rationale: Laptop user == admin user; sudo audit trail better than root login

## Future Considerations

- **Wayland-only option:** Remove X11 entirely (once all apps support Wayland)
- **Atomic updates:** Consider `ostree`-based updates (future, lower priority)
- **Zephyr** (or similar): Tool for automatic distro updates + rollback
- **Custom kernel config:** Trim unused drivers (lower priority, only if boot time becomes critical)

## See Also

- [HARDWARE-NOTES.md](HARDWARE-NOTES.md) – ThinkPad L13 specific settings
- [BUILDING.md](BUILDING.md) – Build instructions
- [README.md](../README.md) – User-facing overview
