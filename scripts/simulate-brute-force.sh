#!/usr/bin/env bash
# =============================================================================
# Simulate SSH Brute-Force Attack
# =============================================================================
# Generates failed SSH login attempts against the local VM to trigger the
# "Excessive Failed Logins" detection rule in Splunk.
#
# MITRE ATT&CK: T1110 - Brute Force
# Log Source:    /var/log/auth.log
# Usage:         sudo bash simulate-brute-force.sh [target_ip] [attempts]
# =============================================================================

set -euo pipefail

TARGET_IP="${1:-127.0.0.1}"
ATTEMPTS="${2:-8}"
PORT=22

echo "[*] Starting SSH brute-force simulation against $TARGET_IP"
echo "[*] Attempts: $ATTEMPTS | Port: $PORT"
echo "[*] Timestamp: $(date)"
echo "---"

for i in $(seq 1 "$ATTEMPTS"); do
    echo "[>] Attempt $i/$ATTEMPTS - user: invalid"
    # sshpass is not required; the connection will fail and log to auth.log
    ssh -o StrictHostKeyChecking=no \
        -o BatchMode=yes \
        -o ConnectTimeout=3 \
        "invalid@${TARGET_IP}" -p "$PORT" 2>/dev/null || true
    sleep 0.5
done

echo "---"
echo "[*] Simulation complete. Check Splunk:"
echo "    index=main sourcetype=auth.log \"Failed password\""
