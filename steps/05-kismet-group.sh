#!/usr/bin/env bash
set -euo pipefail

sudo usermod -aG kismet "$USER"
echo "Added $USER to the kismet group (log out/in or reboot for it to take effect)."
