#!/bin/sh
# Idempotent: safe to run multiple times. Flushes existing SNAT rules before adding.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create Docker networks (bridge interfaces must exist before iptables rules reference them)
"$SCRIPT_DIR/brh-compose" prod up --no-start

# Remove all copies of a SNAT rule then add exactly one
add_snat_rule() {
    src="$1" iface="$2" to="$3"
    while iptables -t nat -D POSTROUTING -s "$src" ! -o "$iface" -j SNAT --to-source "$to" 2>/dev/null; do :; done
    iptables -t nat -A POSTROUTING -s "$src" ! -o "$iface" -j SNAT --to-source "$to"
}

add_snat_rule 10.1.0.0/16 bridge-tf2      69.162.82.210
add_snat_rule 10.2.0.0/16 bridge-css      69.162.82.211
add_snat_rule 10.3.0.0/16 bridge-pz       69.162.82.213
add_snat_rule 10.4.0.0/16 bridge-l4d2     69.162.82.212
add_snat_rule 10.5.0.0/16 bridge-palworld 69.162.82.213
