#!/usr/bin/env bash
# Runs at boot via kismet-boot.service: brings wlan1 into monitor mode and
# makes sure gpsd is up before Kismet starts looking for its sources.
set -euo pipefail

airmon-ng start wlan1
systemctl start gpsd.service
