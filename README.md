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
  - **[Setup Dashboard](screenshots/splunk-setup-screenshot.png):** Initial Splunk interface.
  - **[Authentication Failures Hunt](screenshots/authentication-failures/hunt.png):** SPL query results.
  - **[Malware Activity Hunt](screenshots/malware-activity/hunt.png):** Malware detection.
  - **[Network Scanning Hunt](screenshots/network-scanning/hunt.png):** Port scan analysis.
  - **[Alert Configurations](screenshots/authentication-failures/alert.png, screenshots/malware-activity/alert.png, screenshots/network-scanning/alert.png):** Proactive monitoring setups.
  - **[Visualizations](screenshots/authentication-failures/visual.png, screenshots/malware-activity/visual.png, screenshots/network-scanning/visual.png):** Timecharts and tables.
- **Detailed Report:** [Threat Hunting Analysis](reports/threat-hunting-report.md) - Comprehensive findings, MITRE ATT&CK mappings, and mitigation strategies.
- **Raw Logs:** 
  - [Auth Log Sample](captures/auth-log-sample.txt)
  - [Malware Log Sample](captures/malware-log-sample.txt)
  - [Network Scan Log Sample](captures/network-scan-log-sample.txt)
- **Setup Guide:** [Installation Steps](docs/setup-guide.txt) - Reproducible lab configuration.

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
- **LinkedIn:** [Youssef Mangt](https://www.linkedin.com/in/yourprofile)
- **Email:** [youssef.mangt@example.com](mailto:youssef.mangt@example.com)

## Why This Matters to Employers
This project reflects my hands-on experience with industry-standard tools like Splunk, a leader in SIEM solutions used by over 50% of Fortune 100 companies. The ability to simulate, detect, and mitigate threats in a controlled environment translates directly to real-world SOC operations. My focus on documentation and reproducibility ensures I can collaborate effectively and contribute immediately to your cybersecurity team.

## Acknowledgments
Inspired by practical learning at Queen’s University and guided by industry best practices from Splunk and MITRE ATT&CK frameworks.