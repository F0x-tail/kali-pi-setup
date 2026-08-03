#!/usr/bin/env bash
# Installs the static landing page (links to Kismet, Raspyjack, and
# flock-back) as nginx's default site and makes sure nginx is running.
# Depends on nginx (step 03) and the ufw port-80 rule (step 04).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

sudo install -m 644 config/www/index.html /var/www/html/index.html
sudo systemctl enable --now nginx
