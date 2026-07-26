# Installing Zog

This guide walks you through installing Zog on your ThinkPad L13 from the bootable ISO.

## Prerequisites

- Bootable USB drive (8GB+ capacity)
- Balena Etcher or Ventoy for flashing the ISO
- ThinkPad L13 with UEFI firmware enabled
- ~40GB of free disk space

## Step 1: Download the ISO

Download the latest Zog ISO from:
https://github.com/faint-dev/os/releases

Example: `zog-x86_64-20240115.iso`

## Step 2: Flash to USB

### Using Balena Etcher (Recommended)

1. Download and install [Balena Etcher](https://www.balena.io/etcher)
2. Open Balena Etcher
3. Click "Select image" → choose the Zog ISO file
4. Click "Select drive" → choose your USB drive (⚠️ double-check to avoid data loss)
5. Click "Flash"
6. Wait for completion

### Using Ventoy

1. Download and install [Ventoy](https://www.ventoy.net/)
2. Run Ventoy to format your USB drive
3. Copy the Zog ISO to the USB drive's root (drag-and-drop)
4. Boot from USB; Ventoy will show the ISO in a menu

### Using Command Line (Linux/macOS)

```bash
# Find your USB device (DO NOT use the wrong one!)
lsblk           # Linux
diskutil list   # macOS

# Flash (replace sdX with your device, e.g., sda)
sudo dd if=zog-x86_64-YYYYMMDD.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

## Step 3: Boot from USB

1. Insert the USB drive into your ThinkPad L13
2. Power on or restart the laptop
3. Press **F12** (or **Fn+F12**) during startup to enter boot menu
4. Select the USB drive (labeled "UEFI: [USB Device]")
5. Press **Enter** to boot

## Step 4: Live Environment

You'll boot into the Zog live environment (KDE Plasma desktop).

- Desktop is fully functional for browsing, etc.
- To begin installation, double-click the **Calamares Installer** icon on the desktop

## Step 5: Run Calamares Installer

1. **Welcome** → Review system info, click "Next"

2. **Locale & Keyboard**
   - Language: Select English
   - Region: Select "United Kingdom"
   - Keyboard: Select "United Kingdom"
   - Click "Next"

3. **Partitioning** (⚠️ Careful here!)
   - Select "Erase disk and use all space" if this is a fresh L13
   - Or click "Manual" for custom partitioning
   - Default creates: EFI (512MB) + Root (30GB) + Home (rest)
   - Review the summary carefully
   - Click "Next"

4. **Installation Summary**
   - Review all settings (locale, keyboard, partitions, packages)
   - Click "Install" to begin writing to disk
   - Installation takes 5–10 minutes

5. **User Creation**
   - Username: Enter your preferred username (e.g., "myname")
   - Full Name: Enter your full name (optional)
   - Password: Set a strong password
   - Confirm password
   - Click "Next"

6. **Finish**
   - Click "Done"
   - Remove USB drive
   - Click "Restart" (or manually reboot)

## Step 6: First Boot

After restart, you'll see:

1. **GRUB Boot Menu** (3 seconds, auto-boots)
   - Shows "Zog" + other options
   - Default boots into Plasma

2. **Plymouth Boot Splash** (2–3 seconds)
   - Zog logo fades in
   - "Loading..." progress

3. **SDDM Login Screen** (after ~9–10 seconds total)
   - Enter your username and password
   - Click "Sign In"
   - KDE Plasma loads (another ~2–3 seconds)

## Step 7: Initial Setup

Welcome to Zog! Your desktop is ready. Here's what to do next:

### Update Your System

```bash
sudo pacman -Syu
```

### Install Optional Applications (Discord, Spotify, NordVPN)

Run the post-install helper:

```bash
zog-post-install
```

This interactive script lets you install:
- Discord (Flatpak)
- Spotify + Spicetify (Flatpak + AUR)
- NordVPN (AUR)

### Configure Wi-Fi (if not auto-connected)

- Right-click the network icon (top-right panel)
- Select "Connection Settings"
- Add your Wi-Fi network SSID and password
- Click "Connect"

### Check System Info

```bash
# CPU/GPU/RAM
neofetch

# Power profile
sudo tlp stat -b  # Battery info
sudo tlp stat -p  # Power stats

# Storage
lsblk
```

### Set Up Firefox

- Click **Firefox** on the desktop or taskbar
- Sign in with your account (optional)
- Install extensions if desired

### Configure VS Code

- Click **VS Code** on the desktop
- Sign in with GitHub (optional)
- Install extensions for your languages

## Troubleshooting

### "No bootable device found" or won't boot from USB

- Restart laptop, press **F1** during POST
- Go to BIOS → Security → Secure Boot → Disable (if issues persist)
- Go to BIOS → Boot → Boot Mode → UEFI
- Go to BIOS → Boot → Boot Priority → USB first
- Save & Exit

### Slow installation

- Normal for an SSD; be patient
- If it hangs for >15 min, there may be a hardware issue
- Check BIOS version on Lenovo's support site; update if available

### Wi-Fi not connecting

```bash
# Check network status
nmcli device wifi list

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Check logs
sudo journalctl -u NetworkManager -n 20
```

### Stuck on login screen

- Try pressing `Ctrl+Alt+F2` for a virtual terminal
- Log in with your username/password
- Run: `startplasma-wayland` (or `startplasma-x11` for fallback)
- If that fails: `sudo pacman -S sddm` (reinstall display manager)

### Low battery/power issues

- Check TLP profile: `sudo tlp stat -p`
- Switch to battery mode: `sudo tlp setcharge 20 80`
- Reduce brightness (press brightness down key)
- Close unnecessary apps

## Performance Expectations (ThinkPad L13)

- **Boot time**: 9–11 seconds (GRUB → login screen)
- **Desktop load**: 2–3 seconds (login → usable)
- **Idle RAM**: ~1.5–2 GB
- **Idle CPU**: <5%
- **Idle Power**: 3–5W (with display on, Wi-Fi active)
- **Battery life**: 6–8 hours typical use, 8–10 light use

## Need Help?

- Check [HARDWARE-NOTES.md](HARDWARE-NOTES.md) for L13-specific tips
- Visit [GitHub Issues](https://github.com/faint-dev/os/issues)
- Check [Arch Wiki](https://wiki.archlinux.org) for common issues

---

**Enjoy Zog!** 🎉
