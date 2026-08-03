#!/usr/bin/env bash
# Adds the MAC exclusion list to kismet_filter.conf (idempotent -
# re-running replaces the block in case
# config/kismet/kismet_filter_macs.conf gets updated later).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
source lib/common.sh

ensure_block /etc/kismet/kismet_filter.conf "LOG-MAC-EXCLUDE" config/kismet/kismet_filter_macs.conf
