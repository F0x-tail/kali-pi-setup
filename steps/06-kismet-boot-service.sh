#!/usr/bin/env bash
# Installs the combined "start monitor mode + start gpsd" boot service.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

sudo install -m 755 config/scripts/kismet-boot.sh /usr/local/bin/kismet-boot.sh
sudo install -m 644 config/systemd/kismet-boot.service /etc/systemd/system/kismet-boot.service

sudo systemctl daemon-reload
sudo systemctl enable kismet-boot.service
