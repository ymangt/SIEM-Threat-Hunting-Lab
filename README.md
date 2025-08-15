# SIEM Threat Hunting Lab

Welcome to my **SIEM Threat Hunting Lab**, a hands-on project showcasing my cybersecurity skills using Splunk Free Edition. As a fourth-year Computer Science student at Queen’s University with a CompTIA Security+ certification, I’ve designed this lab to simulate and detect real-world threats, aligning with Security+ Domain 2 (Threat Detection and Monitoring). This repository highlights my ability to configure SIEM environments, perform threat hunting, and document findings—skills directly applicable to SOC analyst and detection engineering roles.

## Project Overview
- **Tools:** Splunk Free, VMware Workstation Pro, Ubuntu 24.04 LTS
- **Objective:** Build a SIEM environment to ingest logs, simulate threats (e.g., brute-force attacks, malware, network scans), and execute hunts with SPL queries.
- **Achievements:** Detected 100% of 15+ simulated threats across three categories, achieving a mean time to detection of under 1 minute.

## Setup and Execution
1. **Environment Setup:** Configured a virtual machine with 8 GB RAM, 50 GB disk, and NAT networking, installed Ubuntu, and deployed Splunk Enterprise.
2. **Data Ingestion:** Integrated system logs (`/var/log/auth.log`) and simulated logs (`/var/log/malware.log`, `/var/log/network-scan.log`) with custom sourcetypes.
3. **Threat Simulation:** Executed controlled attacks including failed SSH logins, malware bursts, and port scans, all documented with timestamps.
4. **Hunting and Alerts:** Developed SPL queries and alerts for real-time threat detection, validated with visual dashboards.

## Results
- **Threat Detection Statistics:**
  - **Authentication Failures:** 9+ failed logins, peak burst of 6+ per minute.
  - **Malware Activity:** 5 executions in a 5-second burst.
  - **Network Scanning:** 1 Nmap scan detecting 998 closed ports.
- **Visual Evidence:**
  - **[Setup Dashboard](screenshots/splunk-setup/splunk-setup-screenshot.png):** Initial Splunk interface.
  - **[Authentication Failures Hunt](screenshots/authentication-failures/excessive-failed-logins-hunt-screenshot.png):** SPL query results.
  - **[Malware Activity Hunt](screenshots/malware-activity/malware-hunt-screenshot.png):** Malware detection.
  - **[Network Scanning Hunt](screenshots/network-scanning/network-scan-hunt-screenshot.png):** Port scan analysis.
  - **[Authentication Failures Alert Config](screenshots/authentication-failures/excessive-failed-logins-alert-screenshot.png)**, **[Malware Activity Alert Config](screenshots/malware-activity/malware-alert-screenshot.png)**, **[Network Scanning Alert Config](screenshots/network-scanning/network-scan-alert-screenshot.png):** Proactive monitoring setups.
  - **[Authentication Failures Visualizations](screenshots/authentication-failures/excessive-failed-logins-visual-screenshot.png)**, **[Malware Activity Visualizations](screenshots/malware-activity/malware-visual-screenshot.png)**, **[Network Scanning Visualizations](screenshots/network-scanning/network-scan-visual-screenshot.png):** Line Graph.
- **Detailed Report:** [Threat Hunting Analysis](reports/threat-hunting-report.md) - Comprehensive findings, MITRE ATT&CK mappings, and mitigation strategies.
- **Raw Logs:** 
  - [Auth Log Sample](captures/auth-log-sample.txt)
  - [Malware Log Sample](captures/malware-log-sample.txt)
  - [Network Scan Log Sample](captures/network-scan-log-sample.txt)
- **Setup Guide:** [Installation Steps](docs/setup-guide.md)

## Skills Demonstrated
- **SIEM Configuration:** Splunk installation, data ingestion, and alert setup.
- **Threat Hunting:** SPL query development and anomaly detection.
- **Cybersecurity Analysis:** MITRE ATT&CK mapping and triage recommendations.
- **Documentation:** Organized repo with visuals, reports, and guides.

## Lessons Learned
- Mastered Splunk’s search language (SPL) and alert automation.
- Overcame permission challenges with log file configurations.
- Gained insight into scalable threat detection workflows.
- Future Goals: Expand to multi-VM environments and integrate EDR telemetry.

## Technologies Used
- **Splunk Free:** Core SIEM platform.
- **VMware Workstation Pro:** Virtualization for lab isolation.
- **Ubuntu 24.04 LTS:** Operating system for log generation.
- **GitHub:** Version control and portfolio hosting.

## Contact
- **LinkedIn:** [Youssef Elmanawy](https://www.linkedin.com/in/youssef-elmanawy/)
- **Email:** [yhmanawy@gmail.com](mailto:yhmanawy@gmail.com)

## Why This Project Is Relevant
This lab demonstrates my proficiency with industry-standard SIEM tools, particularly Splunk, which is widely adopted across leading enterprises. By simulating and investigating real-world threats, I’ve gained practical skills that align closely with day-one responsibilities in SOC analyst and detection engineering roles. My emphasis on clear documentation and reproducible workflows also reflects the collaborative, detail-oriented mindset needed to succeed in a modern cybersecurity team.
