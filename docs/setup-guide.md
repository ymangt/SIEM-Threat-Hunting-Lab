# Setup Guide

Step-by-step instructions to build the SIEM Threat Hunting Lab from scratch.

---

## 1. VM Configuration

**Host:** Windows 11 with VMware Workstation Pro

| Setting | Value |
|---------|-------|
| OS | Ubuntu 24.04 LTS |
| CPUs | 2 |
| RAM | 8 GB |
| Disk | 50 GB |
| Network | NAT (192.168.x.x) |
| Hostname | `siem-lab` |

### Steps

1. Download the [Ubuntu 24.04 LTS ISO](https://ubuntu.com/download/desktop).
2. In VMware, create a new VM with the specs above.
3. Install Ubuntu with minimal setup and set the hostname to `siem-lab`.
4. Update the system:

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Splunk Installation

1. Download Splunk Enterprise (`.deb` package) from [splunk.com](https://www.splunk.com/en_us/download.html) (Free Trial).

2. Install the package:

```bash
sudo dpkg -i splunk-9.3.0-*.deb
```

3. Start Splunk and accept the license:

```bash
sudo /opt/splunk/bin/splunk start --accept-license
```

4. Set the admin password when prompted and enable Splunk to start on boot:

```bash
sudo /opt/splunk/bin/splunk enable boot-start
```

5. Verify Splunk is running by opening `http://192.168.x.x:8000` in your browser.

---

## 3. Data Input Configuration

Navigate to **Splunk > Settings > Data Inputs > Files & Directories > Add New** and configure the following monitored inputs:

| Log File | Sourcetype | Description |
|----------|-----------|-------------|
| `/var/log/auth.log` | `auth.log` | SSH authentication events |
| `/var/log/malware.log` | `malware-sim.sh` | Simulated malware execution log |
| `/var/log/network-scan.log` | `network_scan` | Nmap scan output |

After adding each input, verify data is flowing by searching:

```spl
index=main | stats count BY sourcetype
```

---

## 4. Log File Setup

The malware and network scan logs don't exist by default. Create them before running simulations:

```bash
sudo touch /var/log/malware.log /var/log/network-scan.log
sudo chmod 664 /var/log/malware.log /var/log/network-scan.log
```

Install Nmap for the network scan simulation:

```bash
sudo apt install nmap -y
```

---

## 5. Running Simulations

Once Splunk is ingesting data, run the threat simulation scripts from the repo:

```bash
# SSH brute-force (generates failed login events in auth.log)
sudo bash scripts/simulate-brute-force.sh

# Malware execution burst (writes to /var/log/malware.log)
sudo bash scripts/simulate-malware.sh

# Network port scan (writes Nmap output to /var/log/network-scan.log)
sudo bash scripts/simulate-network-scan.sh
```

Then open the detection queries from `detections/*.spl` in the Splunk Search & Reporting app.

---

## Troubleshooting

### Permission Denied on Log Files

If Splunk cannot read the log files, adjust ownership and permissions:

```bash
sudo chown -R splunk:splunk /var/log/malware.log /var/log/network-scan.log
sudo chmod 644 /var/log/malware.log /var/log/network-scan.log
```

For `auth.log`, add the Splunk user to the `adm` group:

```bash
sudo usermod -aG adm splunk
```

### Splunk Not Starting

Check the Splunk log for errors:

```bash
cat /opt/splunk/var/log/splunk/splunkd.log | tail -50
```

Restart Splunk:

```bash
sudo /opt/splunk/bin/splunk restart
```

### No Data Appearing in Search

- Confirm the data inputs are enabled under **Settings > Data Inputs**
- Check that log files have recent content: `tail -5 /var/log/auth.log`
- Verify the index is set to `main` (default)
