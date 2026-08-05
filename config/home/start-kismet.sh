#!/usr/bin/env bash
# Starts Kismet with the sources/config kali-pi-setup already set up
# (see steps/06-kismet-config.sh). No sudo needed - your user was
# added to the kismet group by steps/05-kismet-group.sh.
#
# Flags chosen for non-interactive/scripted use (per kismet_server.cc's
# own --help text):
#   --daemonize     spawn detached in the background (this also
#                    disables the console wrapper below internally)
#   --no-ncurses     disable the interactive console wrapper, which
#                    assumes a real terminal
#   --silent         turn off stdout output after the setup phase
#   --no-line-wrap   documented as "for grep, speed, etc" - plain
#                    output instead of terminal-width line wrapping
# Web UI stays reachable at http://localhost:2501 either way. To stop
# it again: pkill kismet
set -euo pipefail
exec kismet --daemonize --no-ncurses --silent --no-line-wrap "$@"
