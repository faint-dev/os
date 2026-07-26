# Zog Quick Start Guide

Welcome to Zog! Here's how to get productive immediately after installation.

## Desktop Basics

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super` (Win key) | Open application launcher |
| `Super+D` | Show desktop |
| `Super+E` | Open file manager |
| `Super+T` | Open terminal |
| `Alt+Tab` | Switch windows |
| `Ctrl+Alt+T` | Open terminal (alternative) |
| `Print` | Screenshot (Hyprland: `grim`) |

### Opening Applications

1. Press **Super** (Win key) → search box appears
2. Type app name (e.g., "Firefox", "Code", "Kitty")
3. Press **Enter** to launch

Or click icons on the **taskbar** (bottom-left).

### Switching Sessions

At login screen, click the session selector (bottom-right, before password):
- **Plasmawayland** (default, recommended)
- **PlasmaX11** (fallback if Wayland has issues)
- **Hyprland** (tiling WM, advanced users)

## Essential Applications

### Browser: Firefox
```bash
firefox &
```
- Pre-installed, pre-configured for UK
- Sync with Firefox account (optional)

### Terminal: Kitty
```bash
kitty &
```
- Modern terminal emulator
- Configured with Zsh + Starship prompt
- Copy: `Ctrl+Shift+C`, Paste: `Ctrl+Shift+V`

### Code Editor: VS Code
```bash
code &
```
- Language support via extensions
- Git integration built-in

### Text Editor: Neovim
```bash
nvim <file>
```
- Powerful, keyboard-driven
- Config: `~/.config/nvim/init.lua`

## System Administration

### Update Your System

```bash
sudo pacman -Syu
```

- Runs every day at midnight (notify-only timer)
- Run manually to apply immediately

### Install a Package

```bash
sudo pacman -S <package-name>

# Examples
sudo pacman -S gimp          # Image editor
sudo pacman -S blender       # 3D modeling
sudo pacman -S audacity      # Audio editor
```

### Check System Status

```bash
# Full system info
fastfetch                    # Quick version
inxi -Fxz                    # Detailed version

# Power & battery
sudo tlp stat -b

# Disk usage
df -h

# RAM usage
free -h

# CPU temperature
watch sensors
```

### Check Battery Life

```bash
sudo tlp stat -b

# Example output:
# --- Battery 0 ---
# Status          = Charging
# Charge now      = 4500 [mAh]
# Charge full     = 5000 [mAh]
# Charge full design = 5000 [mAh]
# Energy now      = 50 [Wh]
# Energy full     = 55 [Wh]
# Energy full design = 55 [Wh]
# Power now       = 10 [W]
# ...
```

### Wi-Fi Management

```bash
# List available networks
nmcli device wifi list

# Connect to network
nmcli device wifi connect "SSID" password "PASSWORD"

# Disconnect
nmcli connection down "SSID"

# Show active connection
nmcli device status
```

### Install Applications from AUR

AUR = Arch User Repository (community-maintained packages)

```bash
# Install yay (AUR helper)
sudo pacman -S yay

# Install a package from AUR
yay -S spicetify-cli       # Spotify customizer
yay -S visual-studio-code-bin  # VS Code binary (faster)
```

## Productivity Tools

### File Manager
- Press **Super+E** or click folder icon
- Drag-and-drop files
- Right-click for context menu

### Screenshot
- Press **Print** key
- Image copied to clipboard
- Paste in any app

### Clipboard Manager
- Press **Ctrl+Alt+V**
- View/paste recent clipboard history

### Search Launcher
- Press **Super** (or **Ctrl+Alt+Space**)
- Type to search apps, files, documents

## System Customization

### Change Wallpaper

1. Right-click desktop
2. Select "Desktop Settings"
3. Click "Wallpaper" tab
4. Choose from `~/.local/share/backgrounds/zog/` or upload your own

### Adjust Display Settings

1. System Settings → Display and Monitor
2. Resolution, refresh rate, scaling

### Configure Keyboard

1. System Settings → Input Devices → Keyboard
2. Layout: "United Kingdom" (UK)
3. Shortcuts: Customize hotkeys

### Adjust Trackpad

1. System Settings → Input Devices → Touchpad
2. Sensitivity, acceleration, tap-to-click

### Change Theme / Colors

1. System Settings → Appearance
2. Global Theme: Choose from available themes
3. Colors: Select dark/light variants

## Performance Tips

### Free Up RAM

```bash
# See memory usage
free -h

# Close unused apps
# Stop background services
sudo systemctl stop service-name
```

### Check Disk Usage

```bash
# Overall usage
df -h

# Per-directory
ncdu /home

# Find large files
find ~ -size +100M -type f | sort -rh
```

### Monitor System Activity

```bash
# Real-time CPU/memory/disk
htop

# Or the prettier version
btop
```

### Power Saving on Battery

```bash
# Check current power profile
sudo tlp stat -p

# Reduce brightness
Press brightness-down key (F5 or Fn+Down)

# Enable airplane mode
Click network icon → Airplane mode

# Close unnecessary apps
Alt+Tab to see what's running
```

## Common Tasks

### Take a Screenshot

```bash
# Full screen
import -window root ~/screenshot.png

# Or use Print key
```

### Record Your Screen

```bash
# Using OBS (GUI)
obs &

# Or command-line (FFmpeg)
ffmpeg -f x11grab -i :0 -c:v libx264 output.mp4
```

### Install Spotify

```bash
zog-post-install
# Select "Install Spotify"

# Or manually
flatpak install flathub com.spotify.Client
```

### Install Discord

```bash
zog-post-install
# Select "Install Discord"

# Or manually
flatpak install flathub com.discordapp.Discord
```

### Connect to VPN (NordVPN)

```bash
zog-post-install
# Select "Install NordVPN"

# After install
nordvpn login
nordvpn connect
nordvpn status
```

### Test Internet Speed

```bash
speedtest-cli
```

## Useful Commands

```bash
# Search for files
fd pattern /path/to/search

# Search file contents
rg "text to find" /path/

# Beautiful command output
ls -la | bat  # Colored file listing

# Quick navigation
cd -          # Go to previous directory
pwd           # Print current directory

# Check package info
pacman -Si package-name      # Info from repos
yay -Si aur-package-name     # Info from AUR

# View system logs
journalctl -n 20             # Last 20 lines
journalctl -u service-name   # Logs for specific service
journalctl -f                # Follow logs in real-time
```

## Getting Help

- **Desktop Help:** Right-click → "Get Help"
- **Terminal Help:** `command --help` or `man command`
- **Web Search:** Firefox → "Arch Linux [your question]"
- **GitHub Issues:** https://github.com/faint-dev/os/issues

## Next Steps

1. ✅ Complete first boot setup (you're reading this!)
2. Install optional apps: `zog-post-install`
3. Customize wallpaper & theme
4. Install development tools for your language
5. Sync cloud services (Google Drive, OneDrive, etc.)
6. Set up SSH keys for GitHub/GitLab

---

**Questions?** Check [HARDWARE-NOTES.md](HARDWARE-NOTES.md) (ThinkPad-specific) or [docs/](../docs/).

**Enjoy Zog!** 🚀
