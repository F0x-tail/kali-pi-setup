# kali-pi-setup

Bootstrap script for turning a fresh Kali Linux install (Raspberry Pi
wardriving rig) into a configured box: NetworkManager, Kismet + gpsd for
wifi/GPS logging, a boot-time monitor-mode service, an OUI alert
watchlist, SSH hardening, and a set of external security tools cloned
for manual setup.

## What it does

`bootstrap.sh` runs every script in `steps/`, in numeric order:

| Step | What it does |
|---|---|
| `00-network-manager.sh` | Flips `managed=false` to `managed=true` under `[ifupdown]` in `NetworkManager.conf`, so NetworkManager controls interfaces. |
| `01-system-upgrade.sh` | `apt update && apt full-upgrade -y && apt autoremove -y`. |
| `02-packages.sh` | Installs every package listed in `packages.txt` (ufw, gpsd, wordlists, seclists, bluez, kismet, etc). |
| `03-kismet-group.sh` | Adds the current user to the `kismet` group. |
| `04-kismet-config.sh` | Appends the Alfa/ADS-B/gpsd sources and logging settings to Kismet's config. |
| `05-gpsd-config.sh` | Points `gpsd` at `/dev/ttyACM0` and enables `gpsd.service`. |
| `06-kismet-boot-service.sh` | Installs `kismet-boot.service`, which brings `wlan1` into monitor mode and starts gpsd at boot. |
| `07-clone-repos.sh` | Clones (or pulls) every tool in `repos.txt` into `~/tools/<name>`. |
| `08-kismet-alerts.sh` | Adds the OUI devicefound watchlist (from `config/kismet/kismet_alerts_ouis.conf`) to Kismet's alerts config. |
| `09-ssh-authorized-keys.sh` | Installs the public keys from `config/ssh/authorized_keys` into `~/.ssh/authorized_keys`. |
| `10-ssh-hardening.sh` | Disables root login, empty passwords, and X11 forwarding; opens the ufw SSH rule and enables ufw; disables password authentication **only if** an authorized key is already present. |

All steps are idempotent - re-running `bootstrap.sh` is safe and will not
duplicate config entries.

Tools cloned by `07-clone-repos.sh` (currently `flock-back`,
`Chasing-Your-Tail-NG`, `AngryOxide`, `Raspyjack`) are **not** built or
installed automatically - each has its own install steps documented in
its own README.

## Setup

1. Before running, add your SSH public key(s) to
   `config/ssh/authorized_keys` (one per line) if they aren't already
   there. This file is installed by step `09` before step `10` disables
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
Reboot afterwards so NetworkManager, the `kismet` group membership, and
the new systemd services all take effect:

```bash
sudo reboot
```

## Running a single step

Each file under `steps/` is a standalone script and can be run on its
own, e.g. to re-apply just the Kismet alerts watchlist:

```bash
./steps/08-kismet-alerts.sh
```

## Layout

```
bootstrap.sh           entry point - runs steps/*.sh in order
lib/common.sh           shared helpers (ensure_line, ensure_block, log)
steps/                  numbered, idempotent setup scripts
config/kismet/          Kismet OUI alert watchlist
config/scripts/         kismet-boot.sh, run at boot
config/systemd/          kismet-boot.service unit file
config/ssh/authorized_keys   SSH public keys installed onto the device
packages.txt            apt packages installed by step 02
repos.txt               external tool repos cloned by step 07
```
