#!/usr/bin/env bash
# Runs at boot via kismet-boot.service: makes sure gpsd is up before
# Kismet starts looking for its sources. Kismet puts wlan1 into monitor
# mode itself via its source config, so no airmon-ng call is needed here.
set -euo pipefail

systemctl start gpsd.service
