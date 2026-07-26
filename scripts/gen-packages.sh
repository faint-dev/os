#!/usr/bin/env bash
set -euo pipefail

# Generate archiso/packages.x86_64 from individual package list files
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_DIR="$REPO_ROOT/archiso/packages"
OUTPUT_FILE="$REPO_ROOT/archiso/packages.x86_64"

if [ ! -d "$PACKAGES_DIR" ]; then
  echo "Error: $PACKAGES_DIR not found"
  exit 1
fi

# Concatenate all .txt files (except packages.x86_64) into the output
{
  for txt_file in "$PACKAGES_DIR"/*.txt; do
    if [ -f "$txt_file" ]; then
      echo "# From $(basename "$txt_file")"
      grep -v '^#' "$txt_file" | grep -v '^[[:space:]]*$' || true
      echo
    fi
  done
} > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE ($(wc -l < "$OUTPUT_FILE") lines)"
