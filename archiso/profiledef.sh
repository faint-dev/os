#!/usr/bin/env bash

iso_name="zog"
iso_label="ZOG_$(date +%Y%m%d)"
iso_publisher="Zog Project"
iso_application="Zog Custom Arch Linux"
iso_version="1.0.0"
install_dir="arch"
bootmodes=('uefi-x64.efi' 'uefi-ia32.efi')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:700"
  ["/root/.ssh"]="0:0:700"
  ["/usr/bin/sudo"]="0:0:4755"
)
