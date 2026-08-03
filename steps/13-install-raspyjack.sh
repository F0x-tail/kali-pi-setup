#!/usr/bin/env bash
# Runs Raspyjack's own installer against the repo already cloned by
# step 11 into ~/tools/Raspyjack. install_raspyjack.sh hardcodes
# /root/Raspyjack throughout (systemd units, GPIO stubs, config paths,
# PYTHONPATH) rather than deriving it from cwd/$HOME, so a symlink
# points that path at our one clone instead of the official docs'
# separate root-owned clone (which would leave two copies on disk).
# /root is only traversable by root, hence the sudo bash -c below
# rather than a plain cd.
#
# The installer sets up its own boot-time autostart (raspyjack.service,
# raspyjack-device.service, raspyjack-webui.service, all enabled via
# systemctl enable --now) - nothing further is needed for that here.
#
# The official install ends with a reboot; that's skipped here since a
# mid-bootstrap reboot would kill the remaining steps. bootstrap.sh
# reboots once every step has finished instead.
set -euo pipefail

RASPYJACK_DIR="$HOME/tools/Raspyjack"

if [[ ! -d "$RASPYJACK_DIR" ]]; then
  echo "$RASPYJACK_DIR not found - skipping (declined at step 11, or that step hasn't run yet)."
  exit 0
fi

chmod +x "$RASPYJACK_DIR/install_raspyjack.sh"
sudo ln -sfn "$RASPYJACK_DIR" /root/Raspyjack
sudo bash -c 'cd /root/Raspyjack && ./install_raspyjack.sh'

# The installer pulls in the classic python3-rpi.gpio package, which
# cannot initialize GPIO on a Raspberry Pi 5 (different SoC/RP1
# peripheral layout - fails at runtime with "RuntimeError: Cannot
# determine SOC peripheral base address", not at import time, so the
# installer's own dependency check doesn't catch it). python3-rpi-lgpio
# is an API-compatible drop-in replacement that supports Pi 5.
if grep -qi "Raspberry Pi 5" /proc/device-tree/model 2>/dev/null; then
  echo "Raspberry Pi 5 detected - swapping python3-rpi.gpio for python3-rpi-lgpio."
  sudo apt-get remove -y python3-rpi.gpio
  sudo apt-get install -y python3-rpi-lgpio
  sudo systemctl reset-failed raspyjack.service
  sudo systemctl restart raspyjack.service
fi
