#!/bin/bash
# Cron-friendly scheduled restart for game servers.
# Brings all services down (cleans up logs), reapplies networking, starts core servers.
#
# Usage:
#   ./restart.sh               -- run the restart
#   ./restart.sh --install-cron -- install nightly cron job for this script
set -e

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:$PATH

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGFILE="$SCRIPT_DIR/restart.log"

if [ "${1:-}" = "--install-cron" ]; then
    CRON_LINE="0 4 * * * $SCRIPT_DIR/restart.sh"
    (crontab -l 2>/dev/null | grep -v "$SCRIPT_DIR/restart.sh" || true; echo "$CRON_LINE") | crontab -
    echo "Cron job installed: $CRON_LINE"
    exit 0
fi

# Prefix all output with timestamps, log to file and stdout
exec > >(while IFS= read -r line; do printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$line"; done | tee -a "$LOGFILE") 2>&1

echo "=== game-servers restart starting ==="

cd "$SCRIPT_DIR"

echo "Bringing all services down..."
./brh-compose prod down

echo "Applying networking (iptables + Docker networks)..."
sudo ./setup_networking.sh

echo "Starting core services..."
./brh-compose prod up -d tf2 css fastdownload

echo "=== restart complete ==="
