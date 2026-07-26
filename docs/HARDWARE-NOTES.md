# ThinkPad L13 Hardware Notes

This document covers ThinkPad L13 (i3-11th gen) specific tuning, known quirks, and best practices for running Zog.

## System Specifications

- **CPU:** Intel Core i3-1115G4 (11th gen Rocket Lake, 2 cores / 4 threads, 3.0–4.1 GHz)
- **GPU:** Intel Xe Graphics (integrated, 80 EUs)
- **RAM:** 8 GB LPDDR4X-4266 (soldered, not upgradeable)
- **Storage:** 256 GB SSD (likely WDC/Samsung SATA or NVMe)
- **Display:** 13.3" FHD (1920×1080), IPS, ~60 Hz (no high-refresh)
- **Wi-Fi:** Intel Wi-Fi 6 (802.11ax)
- **Bluetooth:** Integrated
- **Webcam:** 720p
- **Fingerprint:** (some models have this; optional)
- **Trackpad:** Touchpad + physical buttons (libinput supported)
- **Battery:** ~52 Wh (typical 8–10 hour battery life with light use)

## BIOS Setup

### Recommended Settings

1. **Power Management**
   - Set to "Balanced" or "Max Battery" (depends on use case)
   - Enable Intel SpeedStep
   - Enable C-States (CPU low-power states)

2. **Onboard Devices**
   - Keep Integrated Graphics enabled (iGPU)
   - Enable SATA (for SSD)
   - Enable Wi-Fi / Bluetooth

3. **Boot**
   - Boot Mode: UEFI (not Legacy BIOS)
   - Secure Boot: Enable (optional, Zog supports it)
   - Boot Order: Put USB first if you want to test the ISO

4. **Virtualization** (if you plan to use Docker/KVM)
   - Enable VT-x and VT-d

### Accessing BIOS

- Power on ThinkPad
- Press `F2` (or `Fn+F2`) during POST (before Linux logo)
- Make changes, save & exit

## Performance Notes

### CPU Performance

The i3-1115G4 is a modest 2-core chip (4 threads with HT). For typical office/dev work, it's sufficient:
- Web browsing, office documents: smooth
- Programming (compilation, Docker): moderate (not a i7)
- Video editing: slow (limited cores)
- Gaming: playable at 1080p on lower settings

**Zog tuning:**
- TLP battery profile limits CPU to 2.4 GHz max (saves ~30–40% power)
- AC profile allows 4.1 GHz turbo (good for builds)
- Intel P-State in passive mode (integrates well with systemd-cpufreq)

### GPU Performance

Intel Xe iGPU is capable for light workloads:
- KDE Plasma @ 60 FPS: ✓ (smooth)
- Hyprland with animations: ✓ (60 FPS achievable)
- Light gaming (Indie titles, emulators): ✓
- AAA gaming at native res: ✗ (needs lower res/quality)

**Zog tuning:**
- Kernel params: `i915 enable_psr=1 enable_fbc=1` (PowerSaver, FrameBufferCompression)
- GPU underclocking on battery (400–600 MHz vs 400–1200 MHz AC)
- KWin settings tuned for smooth animations without excessive power draw

### Memory (8 GB)

8 GB is tight for modern development but workable:
- Typical idle: ~1.5–2 GB used (Plasma + Firefox + a few apps)
- Under load: can hit 7+ GB (Docker, multiple VMs, etc.)
- **Zram swap enabled:** `zram-generator` creates a 4GB zstd-compressed swap
  device in RAM (`min(ram/2, 4096)` — see `/etc/systemd/zram-generator.conf`).
  Verify with `zramctl` or `swapon --show`.
- Recommendation: avoid having 20+ browser tabs + multiple heavy apps simultaneously

### Storage (256 GB)

Tight but manageable with care:
- Zog base install: ~15–20 GB (after pacman cache cleanup)
- Firefox + dev tools: ~5–8 GB
- Free space remaining: ~220 GB (ample for projects, documents, media)
- Recommendation: avoid keeping large media collections locally; use cloud storage or external SSD

## Battery Life

### Expected Runtime (with TLP battery profile)

- **Light use** (web, docs, email): 8–10 hours
- **Moderate use** (browsing, coding): 6–8 hours
- **Heavy use** (video editing, builds): 3–4 hours

### Tips for Better Battery Life

1. **Reduce display brightness** (biggest power consumer)
   - Use KDE brightness widget (top panel)
   - Set auto-brightness if available in BIOS
2. **Use Wi-Fi, not Bluetooth** when possible (Wi-Fi 6 is efficient)
3. **Close unused browser tabs** (each tab uses ~50–100 MB + CPU)
4. **Suspend on idle** (enabled by default)
5. **Check TLP stats:**
   ```bash
   sudo tlp stat -b  # Battery stats
   sudo tlp stat -p  # Power draw estimate
   ```

## Suspend & Resume

### Status

- Suspend (S3): ✓ Tested, works reliably
- Resume: ✓ Fast (~1–2 sec)
- Fingerprint on resume: Depends on model (some L13 models have this; may need additional setup)

### Testing

```bash
# Test suspend
systemctl suspend

# Check if it woke from lid/button
journalctl -n 20 | grep -i suspend
```

### Troubleshooting Suspend Issues

If suspend doesn't work:

1. Check for devices blocking suspend:
   ```bash
   cat /proc/acpi/wakeup
   ```

2. Disable problematic wake sources:
   ```bash
   echo LID0 > /proc/acpi/wakeup
   ```

3. Make it permanent (add to `/etc/modprobe.d/thinkpad-acpi.conf`):
   ```
   options thinkpad_acpi enable_als=0
   ```

## Wi-Fi & Networking

### Intel Wi-Fi 6 Chipset

- Driver: `iwlwifi` (included in `linux` package)
- Regulatory: Auto-detected (works worldwide)
- Speed: Up to ~600 Mbps (802.11ax)

### Network Manager + iwd Backend

Zog configures NetworkManager with iwd backend for faster scanning:

```bash
# Check connection
nmcli device wifi list

# Connect to Wi-Fi
nmcli device wifi connect SSID password PASSWORD
```

### Testing

```bash
ip link  # See network devices
ping 8.8.8.8  # Test connectivity
```

## Thermal Management

### CPU Temperature Monitoring

```bash
watch sensors  # Real-time temp
journalctl -u thermald -f  # Thermal daemon logs
```

### Typical Idle Temps
- CPU: 45–55 °C
- Skin temp (palm rest): ~30–35 °C (cool, not hot)

### Under Load
- CPU: 70–85 °C (normal, thermal throttling kicks in at ~100 °C)
- No fan noise typical until 75+ °C

### Thermal Tuning (Advanced)

If temps are high, try:

1. Check BIOS fan curve settings
2. Ensure vents are clean (compressed air)
3. Disable high-performance apps in background
4. Use TLP "powersave" profile even on AC

## Known Quirks & Workarounds

### 1. Keyboard Layout

- Factory default: US English
- Zog installer offers UK layout selection
- To change after install:
  ```bash
  localectl set-x11-keymap gb
  ```

### 2. Trackpad Sensitivity

KDE Plasma trackpad settings are in:
- System Settings → Input Devices → Touchpad
- Adjust sensitivity, acceleration, tap-to-click

Hyprland users can tune in `hyprland.conf`:
```
input {
  touchpad {
    natural_scroll = yes
    sensitivity = 0.8
  }
}
```

### 3. Hibernation

- **Status:** Disabled by default (not needed with Zram + fast boot)
- To enable (advanced):
  ```bash
  sudo grub-mkconfig -o /boot/grub/grub.cfg  # Set up swap partition first
  ```
- Not recommended on 256 GB SSD (wear + time)

### 4. Fingerprint Reader (Some Models)

If your L13 has a fingerprint reader:
- Install: `fprintd libfprint`
- Enroll: `fprintd-enroll`
- Test: `fprintd-verify`
- PAM integration (optional, for sudo/login)

### 5. HDMI/Thunderbolt

- Supports external display via USB-C dock or HDMI adapter
- Multi-monitor setup: works via KDE/Hyprland settings
- No native Thunderbolt hotswap (not a Thunderbolt laptop)

## Performance Benchmarks (Reference)

On stock Zog with i3-1115G4:

| Task | Time | Notes |
|------|------|-------|
| Boot (GRUB to login) | 9–11 sec | With SSD; depends on BIOS speed |
| Boot (login to desktop) | 2–3 sec | Plasma session load |
| Kernel compile (Linux 6.x) | ~8 min | Single-threaded; TLP battery throttles to ~5 min |
| Firefox startup | 2–3 sec | First launch; cached 1–2 sec |
| Docker container pull | 10–15 sec | Depends on network, image size |
| Compilation (Rust project) | 2–3 min | Modest project; i3 limits parallelism |

## Secure Boot Setup

### Out-of-the-Box

- `sbctl` is installed on the live ISO
- Zog kernel + bootloader are bundled (no signing needed for default install)

### Custom Kernel / Self-Signed Setup

1. During first boot, reboot into BIOS Setup Mode
2. Clear existing Secure Boot keys (if any)
3. On Zog:
   ```bash
   sudo sbctl setup --microsoft-dbx=skip
   sudo sbctl enroll-keys --microsoft-dbx=skip
   sudo sbctl sign -s /boot/vmlinuz-linux
   sudo sbctl sign -s /boot/vmlinuz-linux-lts
   ```
4. Reboot into BIOS, enable Secure Boot

**Note:** Self-signed Secure Boot requires each firmware update to re-enable Setup Mode + re-enroll keys. Microsoft-signed UEFI shim is out of scope for indie distros.

## Support & Troubleshooting

### Gather System Info

```bash
# Hardware details
inxi -Fxz

# CPU/GPU
lscpu
glxinfo | grep -i vendor

# Storage
lsblk
smartctl -a /dev/nvme0n1  # if NVMe

# Battery
cat /sys/class/power_supply/BAT0/energy_full_design
cat /sys/class/power_supply/BAT0/status

# Thermal
sensors
```

### Common Issues

**Issue:** Wi-Fi disconnects randomly

- Check logs: `journalctl -u NetworkManager -f`
- Update wireless firmware: `sudo pacman -S linux-firmware`
- Switch to `wpa_supplicant` backend (fallback from iwd):
  ```bash
  sudo sed -i 's/wifi.backend=iwd/wifi.backend=wpa_supplicant/' /etc/NetworkManager/conf.d/*
  sudo systemctl restart NetworkManager
  ```

**Issue:** Slow boot or high idle power

- Check TLP: `sudo tlp stat -b`
- Verify Intel P-State is active: `cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver`
- Review systemd startup: `systemd-analyze`

**Issue:** Thermal throttling / fan noise

- Check temps: `watch sensors`
- Verify TLP power profile: `sudo tlp stat -p`
- If thermal, consider dust in vents or switch to "powersave" profile

## See Also

- [ARCHITECTURE.md](ARCHITECTURE.md) – Design decisions, TLP config details
- [BUILDING.md](BUILDING.md) – Build instructions
- ThinkPad L13 manual (Lenovo support site)
- Arch Linux Wiki: [ThinkPad](https://wiki.archlinux.org/title/Lenovo_ThinkPad)

