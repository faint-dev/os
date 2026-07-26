#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: ./scripts/release.sh <version>"
  echo "Example: ./scripts/release.sh 1.0.0"
  exit 1
fi

VERSION="$1"
TAG="v$VERSION"

echo "Creating release: $TAG"
git tag -a "$TAG" -m "Release $TAG"
git push origin "$TAG"

echo "Release $TAG pushed! GitHub Actions will build and publish the ISO."
