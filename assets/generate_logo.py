#!/usr/bin/env python3
"""
Generate Zog logo (SVG + PNG raster set).
Geometric, modern wordmark.
"""
import os

os.makedirs('/Users/l/zog/archiso/airootfs/usr/share/pixmaps', exist_ok=True)

# Zog logo SVG (geometric wordmark)
LOGO_SVG = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="256" height="256" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256">
  <defs>
    <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#5a60c8;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#7c8dd8;stop-opacity:1" />
    </linearGradient>
  </defs>
  <!-- Background circle -->
  <circle cx="128" cy="128" r="120" fill="#1a1c26" opacity="0.3"/>
  
  <!-- Geometric Z shape -->
  <path d="M 80 60 L 176 60 L 100 140 L 176 196 L 80 196 Z" 
        fill="url(#logoGradient)" stroke="none"/>
  
  <!-- Accent line -->
  <line x1="80" y1="128" x2="176" y2="128" stroke="#5ac8d8" stroke-width="4" opacity="0.6"/>
</svg>
'''

# Write logo SVG
with open('/Users/l/zog/archiso/airootfs/usr/share/pixmaps/zog-logo.svg', 'w') as f:
    f.write(LOGO_SVG)

print("✓ Logo generated: archiso/airootfs/usr/share/pixmaps/zog-logo.svg")
