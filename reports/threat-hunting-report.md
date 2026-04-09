# SIEM Threat Hunting Report

**Analyst:** Youssef Elmanawy
**Date:** August 14, 2025
**Repository:** [ymangt/SIEM-Threat-Hunting-Lab](https://github.com/ymangt/SIEM-Threat-Hunting-Lab)
**Environment:** Controlled VMware NAT Lab

---

## Executive Summary

This report details a threat-hunting exercise conducted on a single-node Splunk Enterprise instance targeting three simulated threat behaviors: excessive failed SSH logins, rapid malware executions, and network scanning activity. All simulations were performed within an isolated Ubuntu VM (NAT network), with timestamped evidence and actionable recommendations. Findings are mapped to the MITRE ATT&CK framework.

**Key Results:**
- 3/3 threat categories detected with 100% true positive rate
- Mean time to detect: < 1 minute
- 15+ total simulated events across all categories

---

## Lab Environment

### Infrastructure

| Component | Detail |
|-----------|--------|
| Host System | Windows 11, VMware Workstation Pro |
| Virtual Machine | Ubuntu 24.04 LTS, NAT network (192.168.x.x) |
| SIEM Platform | Splunk Enterprise (Free Trial, single-node) |
| Time Zone | Eastern Daylight Time (EDT) |

### Ingested Data Sources

| Log File | Sourcetype | Description |
|----------|-----------|-------------|
| `/var/log/auth.log` | `auth.log` | SSH authentication events |
| `/var/log/malware.log` | `malware-sim.sh` | Simulated malware execution logs |
| `/var/log/network-scan.log` | `network_scan` | Nmap scan output |

> **Note:** All simulations were conducted solely on lab assets. No external or production networks were involved.

---

## Threat Detections

### 1. Excessive Failed Logins (SSH Brute-Force)

**Objective:** Detect bursts of failed SSH authentication attempts indicative of brute-force attacks.

**Detection Rule:** [`detections/excessive-failed-logins.spl`](../detections/excessive-failed-logins.spl)

```spl
index=main sourcetype=auth.log "Failed password"
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| rex field=_raw "invalid user (?<username>\S+)"
| bin _time span=1m
| stats count AS failed_attempts dc(username) AS unique_users values(username) AS attempted_users BY src_ip _time
| where failed_attempts > 5
```

**Alert Configuration:**

| Setting | Value |
|---------|-------|
| Trigger Condition | Count > 5 events per minute |
| Saved Search | Excessive Failed Logins |
| Schedule | Every 5 minutes |
| Action | Add to Triggered Alerts |

**Findings:**

| Detail | Value |
|--------|-------|
| Event Count | 13+ failed login attempts |
| Time Window | 00:42:55 - 00:43:28 EDT, Aug 14 2025 |
| Source IP | 192.168.71.1 (host via NAT) |
| Pattern | Rapid succession with multiple invalid usernames |

**Evidence:**
[Hunt Results](../screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png) | [Alert Config](../screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png) | [Timechart](../screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png)

**MITRE ATT&CK:** T1110 - Brute Force (Credential Access)

**Triage Steps:**
1. Correlate with successful logins within the same timeframe
2. Review `/etc/ssh/sshd_config` for `PermitRootLogin`, `PasswordAuthentication`, and `MaxAuthTries`
3. Check if the source IP appears in threat intelligence feeds

**Mitigation:**
- Enforce SSH key-based authentication (`PasswordAuthentication no`)
- Deploy Fail2ban to automatically block abusive IPs
- Restrict SSH access to trusted IP ranges via firewall rules

---

### 2. Excessive Malware Executions

**Objective:** Detect rapid, repeated execution of a script or binary that could indicate automated malware.

**Detection Rule:** [`detections/excessive-malware-executions.spl`](../detections/excessive-malware-executions.spl)

```spl
index=main sourcetype=malware-sim.sh "Malware executed"
| bin _time span=1m
| stats count AS execution_count earliest(_time) AS first_seen latest(_time) AS last_seen BY host
| where execution_count > 3
```

**Alert Configuration:**

| Setting | Value |
|---------|-------|
| Trigger Condition | Count > 3 events per minute |
| Saved Search | Excessive Malware Executions |
| Schedule | Every 5 minutes |
| Action | Add to Triggered Alerts |

**Findings:**

| Detail | Value |
|--------|-------|
| Event Count | 5 executions |
| Time Window | 20:06:11 - 20:06:15 EDT, Aug 13 2025 |
| Burst Duration | ~5 seconds |

**Evidence:**
[Hunt Results](../screenshots/malware-activity/malware-hunt-screenshot.png) | [Alert Config](../screenshots/malware-activity/malware-alert-screenshot.png) | [Timechart](../screenshots/malware-activity/malware-visual-screenshot.png)

**MITRE ATT&CK:** T1059 - Command and Scripting Interpreter, T1204 - User Execution (Execution)

**Triage Steps:**
1. Investigate the parent process, user context, and full command line
2. Check binary hash against VirusTotal or internal threat intel
3. Review recent downloads and persistence mechanisms (cron, systemd)

**Mitigation:**
- Enforce execution policies with AppArmor or SELinux
- Maintain an allow-list of approved scripts and binaries
- Deploy EDR with process lineage monitoring

---

### 3. Network Scanning (Reconnaissance)

**Objective:** Detect port scanning activities indicative of reconnaissance efforts.

**Detection Rule:** [`detections/network-scan-detection.spl`](../detections/network-scan-detection.spl)

```spl
index=main sourcetype=network_scan
| rex field=_raw "Nmap scan report for (?<target_host>\S+)"
| rex field=_raw "(?<closed_ports>\d+) closed"
| stats count AS scan_events values(target_host) AS targets BY host
```

**Alert Configuration:**

| Setting | Value |
|---------|-------|
| Trigger Condition | Any match (results > 0) |
| Saved Search | Network Scan Detection |
| Schedule | Daily |
| Action | Add to Triggered Alerts |

**Findings:**

| Detail | Value |
|--------|-------|
| Event Count | 1 Nmap scan |
| Timestamp | 23:13:00 EDT, Aug 13 2025 |
| Target | localhost (127.0.0.1) |
| Result | 998 closed TCP ports, 2 open (ssh, ipp) |

**Evidence:**
[Hunt Results](../screenshots/network-scanning/network-scan-hunt-screenshot.png) | [Alert Config](../screenshots/network-scanning/network-scan-alert-screenshot.png) | [Timechart](../screenshots/network-scanning/network-scan-visual-screenshot.png)

**MITRE ATT&CK:** T1046 - Network Service Discovery (Discovery)

**Triage Steps:**
1. Identify the scan source user and process
2. Determine if the scan was authorized (maintenance, security team)
3. Investigate possible follow-up intrusion attempts on discovered open ports

**Mitigation:**
- Restrict unnecessary open ports with UFW or iptables
- Implement scan rate-limiting at the network level
- Alert on any unauthorized scanning tools (nmap, masscan, zmap)

---

## MITRE ATT&CK Coverage Matrix

| Detection | Tactic | Technique ID | Technique Name |
|-----------|--------|-------------|----------------|
| Excessive Failed Logins | Credential Access | T1110 | Brute Force |
| Excessive Malware Executions | Execution | T1059 | Command and Scripting Interpreter |
| Excessive Malware Executions | Execution | T1204 | User Execution |
| Network Scanning | Discovery | T1046 | Network Service Discovery |

---

## Key Performance Indicators

| KPI | Value |
|-----|-------|
| Detection rules implemented | 3 |
| True positive rate | 100% (3/3) |
| False positives | 0 |
| Mean time to detect | < 1 minute |
| Peak failed-login burst | 6+/minute |
| Malware execution burst | 5 in ~5 seconds |
| Reconnaissance events | 1 |

---

## Strategic Recommendations

1. **Harden SSH** - Enforce key-only authentication, deploy Fail2ban, restrict access by IP
2. **Enforce execution policies** - Use AppArmor/SELinux, maintain script allow-lists
3. **Reduce attack surface** - Close unnecessary ports, implement network segmentation
4. **Automate SOC workflows** - Script triage procedures, build response playbooks, establish baselines

---

## Appendix A: Simulation Commands

### Failed SSH Logins
```bash
sudo bash scripts/simulate-brute-force.sh 127.0.0.1 8
```

### Malware Execution Simulation
```bash
sudo bash scripts/simulate-malware.sh 5
```

### Network Scan
```bash
sudo bash scripts/simulate-network-scan.sh localhost
```

---

## Appendix B: Evidence Index

- [`screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png`](../screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png)
- [`screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png`](../screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png)
- [`screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png`](../screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png)
- [`screenshots/malware-activity/malware-alert-screenshot.png`](../screenshots/malware-activity/malware-alert-screenshot.png)
- [`screenshots/malware-activity/malware-hunt-screenshot.png`](../screenshots/malware-activity/malware-hunt-screenshot.png)
- [`screenshots/malware-activity/malware-visual-screenshot.png`](../screenshots/malware-activity/malware-visual-screenshot.png)
- [`screenshots/network-scanning/network-scan-alert-screenshot.png`](../screenshots/network-scanning/network-scan-alert-screenshot.png)
- [`screenshots/network-scanning/network-scan-hunt-screenshot.png`](../screenshots/network-scanning/network-scan-hunt-screenshot.png)
- [`screenshots/network-scanning/network-scan-visual-screenshot.png`](../screenshots/network-scanning/network-scan-visual-screenshot.png)
- [`captures/auth-log-sample.txt`](../captures/auth-log-sample.txt)
- [`captures/malware-log-sample.txt`](../captures/malware-log-sample.txt)
- [`captures/network-scan-log-sample.txt`](../captures/network-scan-log-sample.txt)
