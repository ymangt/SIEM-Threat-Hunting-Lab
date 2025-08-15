# SIEM Threat Hunting Report

## Overview
**Analyst:** Youssef Elmanawy  
**Date:** August 14, 2025  
**Repository:** [ymangt/SIEM-Threat-Hunting-Lab](https://github.com/ymangt/SIEM-Threat-Hunting-Lab)  
**Environment:** Controlled VMware NAT Lab  

This report details a threat-hunting exercise conducted on a single-node Splunk Enterprise instance, focusing on detecting and analyzing three simulated threat behaviors: excessive failed SSH logins, rapid malware executions, and network scanning activity. All activities were performed within a lab environment on an Ubuntu VM (IP: 192.168.x.x ), with timestamped evidence and actionable recommendations. The findings align with MITRE ATT&CK frameworks, demonstrating SOC-ready detection and response capabilities.

---

## Lab Environment and Data Sources

### Infrastructure
- **Host System:** Windows 11 running VMware Workstation Pro
- **Virtual Machine:** Ubuntu 24.04 LTS, NAT network (192.168.x.x )
- **SIEM Platform:** Splunk Enterprise (Free Trial, single-node)
- **Time Zone:** Eastern Daylight Time (EDT)

### Ingested Data Sources
- **Index:** `main`
  - `/var/log/auth.log` → `sourcetype=auth.log` (SSH authentication events)
  - `/var/log/malware.log` → `sourcetype=malware-sim.sh` (simulated malware logs)
  - `/var/log/network-scan.log` → `sourcetype=network_scan` (simulated Nmap scan logs)

> **Note:** All simulations were conducted solely on lab assets. No external or production networks were involved, ensuring compliance with ethical guidelines.

---

## Threat Detections

### 1. Excessive Failed Logins (SSH Brute-Force)
#### Objective
Detect bursts of failed SSH authentication attempts indicative of brute-force attacks.

#### Search Query
```spl
index=main sourcetype=auth.log "Failed password"
```

#### Alert Configuration
- **Trigger Condition:** Count > 5 events
- **Saved Search:** Excessive Failed Logins  
- **Schedule:** Every week 

#### Findings
- **Event Count:** 6+ failed login attempts  
- **Time Window:** 12:42:55 AM – 12:43:28 AM EDT, August 14, 2025  
- **Source IPs:** `192.168.x.x ` (host via NAT)  
- **Pattern:** Rapid succession of invalid user attempts  

#### Visual Evidence
- [Alert](../screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png)  
- [Hunt Results](../screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png)  
- [Timechart](../screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png)

#### MITRE ATT&CK Mapping
- **Tactic:** Credential Access  
- **Technique:** T1110 - Brute Force  

#### Triage and Analysis
- Correlate with successful logins within the same timeframe.
- Review `/etc/ssh/sshd_config` for `PermitRootLogin`, `PasswordAuthentication`, and `MaxAuthTries`.

#### Mitigation Recommendations
- Use SSH keys instead of passwords (`PasswordAuthentication no`).
- Install Fail2ban to block abusive IPs.
- Limit SSH to trusted IP ranges.

---

### 2. Excessive Malware Executions

#### Objective
Detect rapid, repeated execution of a script or binary that could indicate automated malware.

#### Search Query
```spl
index=main sourcetype=malware-sim.sh "Malware executed"
```

#### Alert Configuration
- **Trigger Condition:** Count > 3 events
- **Saved Search:** Excessive Malware Executions  
- **Schedule:** Every week

#### Findings
- **Event Count:** 5 executions  
- **Time Window:** 8:06:11 PM – 8:06:15 PM EDT, August 13, 2025  

#### Visual Evidence
- [Alert](../screenshots/malware-activity/malware-alert-screenshot.png)  
- [Hunt Results](../screenshots/malware-activity/malware-hunt-screenshot.png)  
- [Timechart](../screenshots/malware-activity/malware-visual-screenshot.png)

#### MITRE ATT&CK Mapping
- **Tactic:** Execution  
- **Techniques:**
  - T1059 - Command and Scripting Interpreter
  - T1204 - User Execution

#### Triage and Analysis
- Investigate process parent, user, and command context.
- Check binary hash (VirusTotal).
- Review recent downloads and persistence entries.

#### Mitigation Recommendations
- Lock down execution with AppArmor/SELinux.
- Allow-list approved scripts only.
- Monitor via EDR process lineage.

---

### 3. Network Scanning (Reconnaissance)

#### Objective
Detect port scanning activities indicative of reconnaissance efforts.

#### Search Query
```spl
index=main sourcetype=network_scan
```

#### Alert Configuration
- **Trigger Condition:** Any hit (>0)
- **Saved Search:** Network Scan Detection
- **Schedule:** Every week

#### Findings
- **Event Count:** 1 Nmap scan
- **Timestamp:** 11:13:00 PM EDT, August 13, 2025
- **Host:** localhost (127.0.0.1)
- **Summary:** 998 closed TCP ports

#### Visual Evidence
- [Alert](../screenshots/network-scanning/network-scan-alert-screenshot.png)  
- [Hunt Results](../screenshots/network-scanning/network-scan-hunt-screenshot.png)  
- [Timechart](../screenshots/network-scanning/network-scan-visual-screenshot.png)

#### MITRE ATT&CK Mapping
- **Tactic:** Discovery
- **Technique:** T1046 - Network Service Discovery

#### Triage and Analysis
- Identify scan source and user.
- Investigate possible intrusion attempts.

#### Mitigation Recommendations
- Restrict ports with UFW.
- Add scan rate-limiting.
- Alert on unauthorized scans.

---

## Key Performance Indicators (KPIs)

- **Detections Implemented:** 3
- **True Positive Simulations:** 3/3
- **Mean Time to Detect:** < 1 minute
- **Peak Failed-Login Burst:** ≥ 6/minute
- **Malware Burst:** 5 in ~5 seconds
- **Recon Events:** 1

**Strategic Recommendations:**
- Harden SSH (key-only, ban abusive IPs, limit access)
- Enforce execution policies (AppArmor/SELinux, allow-lists)
- Reduce scan surface (restrict ports)
- Automate SOC workflows (scripted triage/alerts, baselines)

---

## MITRE ATT&CK Mapping Summary

| Detection                   | Tactic            | Technique                       |
|-----------------------------|-------------------|---------------------------------|
| Excessive Failed Logins     | Credential Access | T1110 (Brute Force)             |
| Excessive Malware Executions| Execution         | T1059, T1204 (Scripting/User)   |
| Network Scanning            | Discovery         | T1046 (Network Service Discovery)|

---

## Appendix A: Simulation Commands

### Failed SSH Logins
```bash
for i in {1..8}; do ssh invalid@192.168.x.x  -p 22; done
```

### Malware Execution Simulation
```bash
cat << 'EOF' | sudo tee /usr/local/bin/malware-sim.sh
#!/usr/bin/env bash
echo "Malware executed at $(date)" | sudo tee -a /var/log/malware.log
EOF
sudo chmod +x /usr/local/bin/malware-sim.sh
for i in {1..5}; do /usr/local/bin/malware-sim.sh; sleep 1; done
```

### Network Scan
```bash
# On the VM
sudo nmap -sS -p- localhost | sudo tee -a /var/log/network-scan.log
```

## Appendix B: Alert Metadata

#### Excessive Failed Logins
  - Schedule: Every 5 minutes
  - Condition: Count > 5 per minute
  - Action: Add to Triggered Alerts

#### Excessive Malware Executions
  - Schedule: Every 5 minutes
  - Condition: Count > 3 per minute
  - Action: Add to Triggered Alerts

#### Network Scan Detection
  - Schedule: Daily at 00:00 (demo)
  - Condition: Results > 0
  - Action: Add to Triggered Alerts


## Evidence Index
- [screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png](../screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png)
- [screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png](../screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png)
- [screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png](../screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png)
- [screenshots/malware-activity/malware-alert-screenshot.png](../screenshots/malware-activity/malware-alert-screenshot.png)
- [screenshots/malware-activity/malware-hunt-screenshot.png](../screenshots/malware-activity/malware-hunt-screenshot.png)
- [screenshots/malware-activity/malware-visual-screenshot.png](../screenshots/malware-activity/malware-visual-screenshot.png)
- [screenshots/network-scanning/network-scan-alert-screenshot.png](../screenshots/network-scanning/network-scan-alert-screenshot.png)
- [screenshots/network-scanning/network-scan-hunt-screenshot.png](../screenshots/network-scanning/network-scan-hunt-screenshot.png)
- [screenshots/network-scanning/network-scan-visual-screenshot.png](../screenshots/network-scanning/network-scan-visual-screenshot.png)
