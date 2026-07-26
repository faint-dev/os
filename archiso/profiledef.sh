#!/usr/bin/env bash
# Zog archiso profile - optimized for fast boot

iso_name="zog"
iso_label="ZOG_$(date +%Y%m%d)"
iso_publisher="Zog Project"
iso_application="Zog Custom Arch Linux"
iso_version="1.0.0"
install_dir="arch"
bootmodes=('uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
# squashfs + zstd: multithreaded compression (scales with CI cores), fast
# boot-time decompression. NOTE: "airootfs_image_compression" is NOT a real
# mkarchiso variable — compression must go via airootfs_image_tool_options,
# otherwise the image ships uncompressed (14GB ISO instead of ~5GB).
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/00-live"]="0:0:440"
)
