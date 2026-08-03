# kali-pi-setup

Bootstrap script for turning a fresh Kali Linux install (Raspberry Pi
wardriving rig) into a configured box: NetworkManager, Kismet + gpsd for
wifi/GPS logging, a boot-time gpsd service, an OUI alert watchlist, SSH
hardening, and a set of external security tools cloned (with
confirmation) and installed automatically.

## What it does

`bootstrap.sh` runs every script in `steps/`, in numeric order:

| Step | What it does |
|---|---|
| `00-system-upgrade.sh` | `apt update && apt full-upgrade -y && apt autoremove -y`. |
| `01-network-manager.sh` | Flips `managed=false` to `managed=true` under `[ifupdown]` in `NetworkManager.conf`, so NetworkManager controls interfaces. |
| `02-ssh-authorized-keys.sh` | Installs the public keys from `config/ssh/authorized_keys` into `~/.ssh/authorized_keys`. |
| `03-packages.sh` | Installs every package listed in `packages.txt` (ufw, gpsd, wordlists, seclists, bluez, kismet, etc), including `ufw` needed by the next step. |
| `04-ssh-hardening.sh` | Runs `dpkg-reconfigure openssh-server` to regenerate any missing SSH host keys (Kali Pi images ship with the same baked-in keys otherwise); disables root login, empty passwords, and X11 forwarding; opens ufw rules for SSH, the landing page (80), the Kismet web UI (2501), flock-back (8000), and Raspyjack (8080), then enables ufw; disables password authentication **only if** an authorized key is already present. |
| `05-kismet-group.sh` | Adds the current user to the `kismet` group. |
| `06-kismet-config.sh` | Appends the Alfa/ADS-B/Bluetooth/gpsd sources and logging settings to Kismet's config. |
| `07-gpsd-config.sh` | Points `gpsd` at `/dev/ttyACM0` and enables `gpsd.service`. |
| `08-kismet-boot-service.sh` | Installs `kismet-boot.service`, which makes sure gpsd is running before Kismet starts at boot. Kismet puts `wlan1` into monitor mode itself via its source config (step 06) - no separate `airmon-ng` call is needed. |
| `09-kismet-alerts.sh` | Adds the OUI devicefound watchlist (from `config/kismet/kismet_alerts_ouis.conf`) to Kismet's alerts config. |
| `10-kismet-mac-filter.sh` | Adds a MAC exclusion list (from `config/kismet/kismet_filter_macs.conf`) to `kismet_filter.conf` via `kis_log_device_filter=phy,mac,block` - those devices stay tracked live but aren't written to the log. |
| `11-clone-repos.sh` | Asks `Install <name>? [y/N]` for each tool in `repos.txt`, then clones (or pulls) the ones you confirm into `~/tools/<name>`. Requires a terminal (reads the prompt from `/dev/tty`). |
| `12-install-angryoxide.sh` | Downloads the latest AngryOxide release for the device's architecture (`aarch64-gnu` on a Pi, `x86_64` elsewhere - both glibc builds, matching Kali) and runs its installer. |
| `13-install-raspyjack.sh` | Symlinks `/root/Raspyjack` to the `~/tools/Raspyjack` clone from step 11 (the installer hardcodes that path) and runs Raspyjack's installer, which sets up its own boot-time autostart services. On a Raspberry Pi 5, also swaps the installer's `python3-rpi.gpio` for `python3-rpi-lgpio` (classic RPi.GPIO can't initialize the Pi 5's RP1 GPIO chip) and restarts the service. Skips the official docs' final `reboot` - `bootstrap.sh` reboots once at the very end instead. |
| `14-install-flock-back.sh` | Creates flock-back's Python virtualenv in `~/tools/flock-back/src/venv` and installs its requirements. |
| `15-install-chasing-your-tail.sh` | Installs Chasing-Your-Tail-NG's Python dependencies via pip, falling back to `--break-system-packages` if Kali's PEP 668 guard rejects a plain install. |
| `16-landing-page.sh` | Installs `config/www/index.html` as nginx's default site and enables nginx. The page links to Kismet, Raspyjack, and flock-back, resolving the host dynamically so the links work from whatever address you reach the page at. |

All steps are idempotent - re-running `bootstrap.sh` is safe and will not
duplicate config entries.

Steps 12-15 each check for their tool's clone under `~/tools/<name>` and
skip with a message (rather than failing) if it's missing - whether
because you declined it at the `11-clone-repos.sh` prompt or that step
hasn't run yet. Step `04-ssh-hardening.sh` depends on `03-packages.sh`
having already installed `ufw` and on `02-ssh-authorized-keys.sh` having
already installed any keys.

## Setup

1. Before running, add your SSH public key(s) to
   `config/ssh/authorized_keys` (one per line) if they aren't already
   there. This file is installed by step `02` before step `04` disables
   password authentication - without a key present, password auth is
   left alone instead of locking you out.
2. Review `packages.txt` and `repos.txt` and adjust as needed.

## Running

From a fresh Kali install, on the Pi itself (or over SSH):

```bash
git clone <this-repo-url> kali-pi-setup
cd kali-pi-setup
./bootstrap.sh
```

Requires `sudo` privileges (you'll be prompted for your password).
Once every step finishes, `bootstrap.sh` reboots the device itself so
NetworkManager, the `kismet` group membership, and the new systemd
services all take effect - if you're running this over SSH, that
connection will drop at that point.

## Running a single step

Each file under `steps/` is a standalone script and can be run on its
own, e.g. to re-apply just the Kismet alerts watchlist:

```bash
./steps/09-kismet-alerts.sh
```

## Layout

```
bootstrap.sh           entry point - runs steps/*.sh in order
lib/common.sh           shared helpers (ensure_line, ensure_block, log)
steps/                  numbered, idempotent setup scripts
config/kismet/          Kismet OUI alert watchlist, MAC log-exclusion list
config/scripts/         kismet-boot.sh, run at boot
config/systemd/          kismet-boot.service unit file
config/ssh/authorized_keys   SSH public keys installed onto the device
config/www/index.html   landing page installed by step 16
packages.txt            apt packages installed by step 03
repos.txt               external tool repos cloned by step 11, installed by steps 12-15
```
