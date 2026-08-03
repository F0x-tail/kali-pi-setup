#!/usr/bin/env bash
# Downloads and installs the latest AngryOxide release for this
# device's architecture (aarch64 on a Pi, x86_64 elsewhere) - the repo
# cloned by step 11 is source only, AngryOxide ships as a release
# tarball rather than being built from it.
set -euo pipefail

if [[ ! -d "$HOME/tools/AngryOxide" ]]; then
  echo "$HOME/tools/AngryOxide not found - skipping (declined at step 11, or that step hasn't run yet)."
  exit 0
fi

REPO="Ragnt/AngryOxide"

case "$(uname -m)" in
  aarch64|arm64) ARCH=aarch64 ;;
  x86_64|amd64) ARCH=x86_64 ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

ASSET_PATTERN="angryoxide-linux-${ARCH}.tar.gz"

DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep -o "\"browser_download_url\": *\"[^\"]*${ASSET_PATTERN}\"" \
  | sed -E 's/.*"(https[^"]+)"/\1/')

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "Could not find a release asset matching ${ASSET_PATTERN}" >&2
  exit 1
fi

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

echo "Downloading $DOWNLOAD_URL"
curl -fsSL -o "$WORKDIR/angryoxide.tar.gz" "$DOWNLOAD_URL"
tar -xf "$WORKDIR/angryoxide.tar.gz" -C "$WORKDIR"

chmod +x "$WORKDIR/install.sh"
sudo "$WORKDIR/install.sh"
