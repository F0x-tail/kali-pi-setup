#!/usr/bin/env bash
# Adds the OUI devicefound watchlist to kismet_alerts.conf (idempotent -
# re-running replaces the block in case config/kismet/kismet_alerts_ouis.conf
# gets updated later).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source lib/common.sh

ensure_block /etc/kismet/kismet_alerts.conf "OUI-WATCHLIST" config/kismet/kismet_alerts_ouis.conf
