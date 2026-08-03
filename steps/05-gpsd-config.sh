#!/usr/bin/env bash
# Point Kali's standard gpsd.service at the GPS dongle and enable it at boot.
set -euo pipefail

sudo sed -i 's|^DEVICES=.*|DEVICES="/dev/ttyACM0"|' /etc/default/gpsd
grep -q '^DEVICES=' /etc/default/gpsd || echo 'DEVICES="/dev/ttyACM0"' | sudo tee -a /etc/default/gpsd >/dev/null

sudo systemctl enable gpsd.service
