#!/usr/bin/env bash
# =============================================================================
# Simulate Network Reconnaissance (Port Scan)
# =============================================================================
# Runs an Nmap SYN scan against the target and logs results to
# /var/log/network-scan.log to trigger the "Network Scan Detection" rule.
#
# MITRE ATT&CK: T1046 - Network Service Discovery
# Log Source:    /var/log/network-scan.log
# Usage:         sudo bash simulate-network-scan.sh [target]
# Prerequisites: nmap must be installed (sudo apt install nmap)
# =============================================================================

set -euo pipefail

TARGET="${1:-localhost}"
LOG_FILE="/var/log/network-scan.log"

# Ensure the log file exists
sudo touch "$LOG_FILE"
sudo chmod 664 "$LOG_FILE"

echo "[*] Starting network scan simulation against $TARGET"
echo "[*] Log: $LOG_FILE"
echo "[*] Timestamp: $(date)"
echo "---"

# Run a full TCP SYN scan and append to the log file
sudo nmap -sS -p- "$TARGET" | sudo tee -a "$LOG_FILE"

echo "---"
echo "[*] Simulation complete. Check Splunk:"
echo "    index=main sourcetype=network_scan"
