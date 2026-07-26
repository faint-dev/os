#!/usr/bin/env python3
"""
Generate procedural Zog wallpapers.
Creates dark and light variants with glassmorphic gradients.
"""
import os
import subprocess

# Create output directory
os.makedirs('/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog', exist_ok=True)

# SVG templates for wallpapers (glassmorphic, minimal)

WALLPAPER_DARK = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="3840" height="2160" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1a1c26;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#2d2e3f;stop-opacity:1" />
    </linearGradient>
    <radialGradient id="glow1" cx="30%" cy="30%">
      <stop offset="0%" style="stop-color:#565ac8;stop-opacity:0.3" />
      <stop offset="100%" style="stop-color:#565ac8;stop-opacity:0" />
    </radialGradient>
    <filter id="blur1">
      <feGaussianBlur in="SourceGraphic" stdDeviation="60" />
    </filter>
  </defs>
  <rect width="3840" height="2160" fill="url(#grad1)"/>
  <circle cx="1920" cy="1080" r="800" fill="url(#glow1)" filter="url(#blur1)" opacity="0.6"/>
  <circle cx="500" cy="500" r="600" fill="url(#glow1)" filter="url(#blur1)" opacity="0.4"/>
  <circle cx="3500" cy="2000" r="700" fill="url(#glow1)" filter="url(#blur1)" opacity="0.5"/>
</svg>
'''

WALLPAPER_LIGHT = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="3840" height="2160" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad2" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#f5f5f7;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#e8eaef;stop-opacity:1" />
    </linearGradient>
    <radialGradient id="glow2" cx="30%" cy="30%">
      <stop offset="0%" style="stop-color:#7c8dd8;stop-opacity:0.25" />
      <stop offset="100%" style="stop-color:#7c8dd8;stop-opacity:0" />
    </radialGradient>
    <filter id="blur2">
      <feGaussianBlur in="SourceGraphic" stdDeviation="60" />
    </filter>
  </defs>
  <rect width="3840" height="2160" fill="url(#grad2)"/>
  <circle cx="1920" cy="1080" r="800" fill="url(#glow2)" filter="url(#blur2)" opacity="0.5"/>
  <circle cx="500" cy="500" r="600" fill="url(#glow2)" filter="url(#blur2)" opacity="0.3"/>
  <circle cx="3500" cy="2000" r="700" fill="url(#glow2)" filter="url(#blur2)" opacity="0.4"/>
</svg>
'''

# Write SVG files
with open('/Users/l/zog/theming/wallpapers/zog-dark.svg', 'w') as f:
    f.write(WALLPAPER_DARK)

with open('/Users/l/zog/theming/wallpapers/zog-light.svg', 'w') as f:
    f.write(WALLPAPER_LIGHT)

# Convert SVG to PNG (requires inkscape)
try:
    subprocess.run([
        'inkscape', '-w', '3840', '-h', '2160',
        '/Users/l/zog/theming/wallpapers/zog-dark.svg',
        '-o', '/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog/zog-dark.png'
    ], check=True)
    subprocess.run([
        'inkscape', '-w', '3840', '-h', '2160',
        '/Users/l/zog/theming/wallpapers/zog-light.svg',
        '-o', '/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog/zog-light.png'
    ], check=True)
    print("✓ Wallpapers generated (inkscape)")
except (FileNotFoundError, subprocess.CalledProcessError):
    # Fallback: convert or imagemagick
    try:
        subprocess.run([
            'convert', '-size', '3840x2160',
            'gradient:#1a1c26-#2d2e3f',
            '/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog/zog-dark.png'
        ], check=False)
        print("✓ Wallpaper dark generated (imagemagick)")
    except FileNotFoundError:
        print("⚠ Inkscape/ImageMagick not found; using placeholder SVG")
        # Copy SVG directly as fallback
        import shutil
        shutil.copy('/Users/l/zog/theming/wallpapers/zog-dark.svg',
                   '/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog/zog-dark.svg')
        shutil.copy('/Users/l/zog/theming/wallpapers/zog-light.svg',
                   '/Users/l/zog/archiso/airootfs/usr/share/backgrounds/zog/zog-light.svg')

print("Wallpapers ready in archiso/airootfs/usr/share/backgrounds/zog/")
