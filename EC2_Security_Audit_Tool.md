EC2 Security Audit Tool
Overview
The EC2 Security Audit Tool is a Bash script that performs a basic security audit of a Linux server or EC2 instance.

The script gathers information about:

Open listening ports

Running services

SSH security settings

Firewall status

Security findings

A timestamped report is automatically generated and saved for future review.

Skills Demonstrated
Linux Administration
Process monitoring

Service verification

Host information gathering

Networking
Port auditing using ss

Identifying exposed services

IPv4 and IPv6 listener analysis

Security
SSH configuration auditing

Firewall status validation

Security findings reporting

Bash Scripting
Variables

Conditional statements

Output redirection

Command substitution

Report generation

Project Structure
ec2-security-audit/
│
├── ec2_security_audit.sh
│
└── reports/
    └── security_report_<timestamp>.txt
Script
#!/bin/bash

REPORT_DIR="reports"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT_FILE="$REPORT_DIR/security_report_$TIMESTAMP.txt"

mkdir -p "$REPORT_DIR"

echo "======================================" > "$REPORT_FILE"
echo "EC2 SECURITY AUDIT REPORT" >> "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "Hostname: $(hostname)" >> "$REPORT_FILE"
echo "======================================" >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "[OPEN PORTS]" >> "$REPORT_FILE"

ss -tuln | awk 'NR>1 {print $5}' >> "$REPORT_FILE"

echo "" >> "$REPORT_FILE"
echo "[SERVICES]" >> "$REPORT_FILE"

if pgrep sshd >/dev/null
then
    echo "SSH : RUNNING" >> "$REPORT_FILE"
else
    echo "SSH : NOT RUNNING" >> "$REPORT_FILE"
fi

if pgrep nginx >/dev/null
then
    echo "NGINX : RUNNING" >> "$REPORT_FILE"
else
    echo "NGINX : NOT RUNNING" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "[SSH CONFIGURATION]" >> "$REPORT_FILE"

sshd -T | grep permitrootlogin >> "$REPORT_FILE" 2>/dev/null

echo "" >> "$REPORT_FILE"
echo "[FIREWALL STATUS]" >> "$REPORT_FILE"

ufw status >> "$REPORT_FILE" 2>&1

echo "" >> "$REPORT_FILE"
echo "[SECURITY FINDINGS]" >> "$REPORT_FILE"

if ufw status 2>/dev/null | grep -q "active"
then
    echo "Firewall Active" >> "$REPORT_FILE"
else
    echo "WARNING: Firewall Inactive" >> "$REPORT_FILE"
fi

if sshd -T 2>/dev/null | grep -q "permitrootlogin yes"
then
    echo "WARNING: Root SSH Login Enabled" >> "$REPORT_FILE"
else
    echo "Root SSH Login Restricted" >> "$REPORT_FILE"
fi

echo ""
echo "Audit Complete."
echo "Report saved to:"
echo "$REPORT_FILE"
Line-by-Line Explanation
Shebang
#!/bin/bash
Tells Linux to execute the script using the Bash shell.

Report Directory Variable
REPORT_DIR="reports"
Stores the directory where audit reports will be saved.

Timestamp Variable
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
Creates a unique timestamp.

Example:

2026-06-11_08-28-58
This prevents reports from overwriting each other.

Report Filename
REPORT_FILE="$REPORT_DIR/security_report_$TIMESTAMP.txt"
Builds the full report filename.

Example:

reports/security_report_2026-06-11_08-28-58.txt
Create Report Directory
mkdir -p "$REPORT_DIR"
Creates the reports directory if it does not already exist.

The -p flag prevents errors if the directory already exists.

Write Report Header
echo "======================================" > "$REPORT_FILE"
Creates the report file and writes the first line.

The > operator overwrites or creates a file.

echo "EC2 SECURITY AUDIT REPORT" >> "$REPORT_FILE"
Adds the report title.

The >> operator appends to the file.

echo "Generated: $(date)" >> "$REPORT_FILE"
Adds the current date and time.

echo "Hostname: $(hostname)" >> "$REPORT_FILE"
Adds the server hostname.

Open Port Audit
ss -tuln
Displays listening TCP and UDP ports.

Flags:

-t = TCP

-u = UDP

-l = Listening

-n = Numeric output

awk 'NR>1 {print $5}'
Processes command output.

NR = current line number

NR>1 = skip header row

$5 = Local Address:Port column

Example:

0.0.0.0:22
0.0.0.0:80
0.0.0.0:9999
Service Monitoring
pgrep sshd
Checks whether the SSH daemon is running.

pgrep nginx
Checks whether Nginx is running.

SSH Security Audit
sshd -T
Displays the effective SSH configuration after all configuration files are processed.

grep permitrootlogin
Extracts the active root login setting.

Example:

permitrootlogin prohibit-password
Firewall Audit
ufw status
Displays the current firewall status.

2>&1
Redirects error output into the report file.

This ensures firewall errors are captured instead of lost.

Security Findings
grep -q "active"
Checks silently whether the firewall is active.

The -q flag suppresses output and returns only success or failure.

grep -q "permitrootlogin yes"
Checks whether root SSH login is fully enabled.

If found, the script reports a warning.

Example Report Output
======================================
EC2 SECURITY AUDIT REPORT
Generated: Thu Jun 11 08:28:58 EDT 2026
Hostname: 3a92dbf13dca
======================================

[OPEN PORTS]
0.0.0.0:22
0.0.0.0:80
0.0.0.0:9999

[SERVICES]
SSH : RUNNING
NGINX : RUNNING

[SSH CONFIGURATION]
permitrootlogin prohibit-password

[FIREWALL STATUS]
ERROR: problem running iptables

[SECURITY FINDINGS]
WARNING: Firewall Inactive
Root SSH Login Restricted


# Docker Lab vs Real EC2 Environment

This project was developed and tested inside an Ubuntu Docker container running on a local workstation.

Because Docker containers typically do not run `systemd`, the standard Linux service management command:

```bash
systemctl
```

was not available.

For that reason, service checks were performed using:

```bash
pgrep sshd
pgrep nginx
```

which verifies whether the service processes are running.

Example used in the project:

```bash
if pgrep nginx >/dev/null
then
    echo "NGINX : RUNNING"
else
    echo "NGINX : NOT RUNNING"
fi
```

---

# Real EC2 Implementation

On a production EC2 instance, Linux virtual machine, or cloud server running `systemd`, a better approach would be:

```bash
systemctl is-active ssh
systemctl is-active nginx
systemctl is-active docker
```

Example:

```bash
if systemctl is-active --quiet nginx
then
    echo "NGINX : RUNNING"
else
    echo "NGINX : NOT RUNNING"
fi
```

Benefits of using `systemctl`:

* Reports actual service state
* Integrates with systemd service management
* Detects failed services
* Provides more accurate operational status
* Commonly used on production Linux servers and EC2 instances

---

# Production EC2 Service Check Example

Replace the service section with:

```bash
echo "" >> "$REPORT_FILE"
echo "[SERVICES]" >> "$REPORT_FILE"

if systemctl is-active --quiet ssh
then
    echo "SSH : RUNNING" >> "$REPORT_FILE"
else
    echo "SSH : NOT RUNNING" >> "$REPORT_FILE"
fi

if systemctl is-active --quiet nginx
then
    echo "NGINX : RUNNING" >> "$REPORT_FILE"
else
    echo "NGINX : NOT RUNNING" >> "$REPORT_FILE"
fi

if systemctl is-active --quiet docker
then
    echo "DOCKER : RUNNING" >> "$REPORT_FILE"
else
    echo "DOCKER : NOT RUNNING" >> "$REPORT_FILE"
fi
```

This would be the preferred implementation when running the script on a real AWS EC2 instance.
 
Key Takeaways
This project demonstrates how Linux administrators and Cloud Engineers perform basic server security reviews by auditing network exposure, service availability, SSH security settings, and firewall configuration using Bash automation.

