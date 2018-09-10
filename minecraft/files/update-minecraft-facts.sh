#!/bin/bash

# This script is called from cron, so make sure to use full paths or some binaries might not be found.

[[ $EUID != 0 ]] && { echo 'Run as root' >&2; exit 1; }

[[ ! -d /etc/facter/facts.d ]] && mkdir -p /etc/facter/facts.d

cat > /etc/facter/facts.d/minecraft.txt << EOF
minecraft_latest_version=$(/bin/curl -m 2 -s https://launchermeta.mojang.com/mc/game/version_manifest.json | /usr/bin/jsawk -n 'out(this.latest.release)')
EOF
