# Setup Guide for SIEM Threat Hunting Lab

## Introduction
This guide outlines the setup of a Splunk-based SIEM lab on Ubuntu 24.04 LTS for threat hunting exercises.

## VM Configuration
**Host:** Windows 11, VMware Workstation Pro  
**VM Specs:** 8 GB RAM, 50 GB disk, NAT network (192.168.71.131)

### Installation Steps:
1. Download Ubuntu 24.04 LTS ISO from ubuntu.com.  
2. Create VM in VMware: 2 CPUs, 8 GB RAM, 50 GB disk, NAT network.  
3. Install Ubuntu with minimal setup, set hostname to `siem-lab`, username `youssef`, password `securepass`.  
4. Update system: ```sudo apt update && sudo apt upgrade -y```


## Splunk Installation
1. Download Splunk Enterprise (.deb) from splunk.com (Free Trial).  
2. Install Splunk: ```sudo dpkg -i splunk-9.3.0.deb```
3. Start Splunk with license acceptance:```/opt/splunk/bin/splunk start --accept-license```
4. Set admin password (e.g., `SplunkPass123!`) and enable boot start:```/opt/splunk/bin/splunk enable boot-start```
5. Verify Splunk is running by accessing: [http://192.168.71.131:8000](http://192.168.71.131:8000)

## Data Inputs Configuration
1. Splunk > Settings > Data Inputs > Files & Directories > Add New  
    - Monitor the following logs with specified sourcetypes:  
    - `/var/log/auth.log` (sourcetype: `auth.log`)  
    - `/var/log/malware.log` (sourcetype: `malware-sim.sh`)  
    - `/var/log/network-scan.log` (sourcetype: `network_scan`)  
2. Save each input and verify them in Search & Reporting.

## Troubleshooting Tips
- **Permission Denied:**  
Adjust file permissions:  ```sudo chown -R youssef:youssef /var/log/*``` ```sudo chmod -R 664 /var/log/*```

- **Splunk Not Starting:**  
Check logs: `/opt/splunk/var/log/splunk/splunkd.log`  
Restart Splunk:```/opt/splunk/bin/splunk restart```
