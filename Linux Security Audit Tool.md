# Linux Security Audit Tool

A Bash script that generates a Linux security audit report by collecting login history, login statistics, reboot history, IP address information, and authentication failure data.

This project was created as a practical Linux administration tool that can be scheduled using Cron and reviewed by system administrators.

---

## Project Overview

The script automatically generates a security report containing:

- Current user running the script
- Hostname
- Primary IP address
- Login history
- Login statistics
- Successful login records
- Reboot history
- Failed login count
- Failed login details
- Automatic cleanup of old report files

All results are saved to a log file for later review.

---

## Technologies Used

- Bash
- Linux Administration
- Cron Jobs
- AWK
- GREP
- WC
- HOSTNAME
- LAST
- FIND

---

## The Script

```bash
#!/bin/bash

REPORT_FILE="security_audit.log"

cleanup_old_reports() {
    find . -name "*.log" -mtime +20 -delete
}

show_system_info() {

    echo "Current User:"
    whoami

    echo

    echo "Primary IP Address:"
    hostname -I | awk '{print $1}'

    echo
}

generate_report() {

{
    echo "===================================="
    echo "        LINUX SECURITY AUDIT REPORT"
    echo "===================================="
    echo "Date: $(date)"
    echo "Hostname: $(hostname)"
    echo

    show_system_info

    echo "Recent Login History:"
    last
    echo

    echo "Login Record Counts:"
    last | awk '{print $1}' | grep -v '^$' | grep -v "wtmp" | sort | uniq -c
    echo

    echo "Successful Login Count:"
    last | grep -v "wtmp" | grep -v "reboot" | wc -l
    echo

    echo "Recent Successful Logins:"
    last | grep -v "wtmp" | grep -v "reboot"
    echo

    echo "Recent Reboots:"
    last reboot
    echo

    echo "Failed Login Count:"
    grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l
    echo

    echo "Recent Failed Login Attempts:"
    grep "Failed password" /var/log/auth.log 2>/dev/null | tail -10
    echo

    echo "===================================="
    echo "END OF REPORT"
    echo "===================================="
    echo
    echo

} >> "$REPORT_FILE"

}

cleanup_old_reports
generate_report
echo "Security audit report saved to: $REPORT_FILE"
```

---

## How to Run

```bash
chmod +x security_audit.sh
./security_audit.sh
```

The report is appended to `security_audit.log`. Run with `sudo` if reading `/var/log/auth.log` requires elevated permissions.

---

## Cron Automation

Run every day at 8 AM:

```text
0 8 * * * /path/to/security_audit.sh
```

Edit cron:

```bash
crontab -e
```

---

## Features

### System Information

Displays the current user, hostname, and primary IP address.

```bash
whoami
hostname
hostname -I | awk '{print $1}'
```

---

### Login History

Shows recent login activity.

```bash
last
```

---

### Login Statistics

Counts unique login sources.

```bash
last | awk '{print $1}' | grep -v '^$' | grep -v "wtmp" | sort | uniq -c
```

Example:

```text
2 kc-inter
3 reboot
```

---

### Successful Login Tracking

Displays total successful logins and recent successful login sessions.

```bash
last | grep -v "wtmp" | grep -v "reboot" | wc -l
last | grep -v "wtmp" | grep -v "reboot"
```

---

### Reboot Monitoring

Displays system reboot history. Useful for troubleshooting outages and maintenance windows.

```bash
last reboot
```

---

### Failed Login Detection

Counts failed login attempts and displays the most recent ones, including source IP addresses when available.

```bash
grep "Failed password" /var/log/auth.log | wc -l
grep "Failed password" /var/log/auth.log | tail -10
```

---

### Automatic Log Cleanup

Deletes report files older than 20 days to prevent excessive log growth.

```bash
find . -name "*.log" -mtime +20 -delete
```

---

## Sample Output

```text
====================================
        LINUX SECURITY AUDIT REPORT
====================================
Date: Wed Jun 03 2026
Hostname: ubuntu

Current User:
root

Primary IP Address:
172.30.1.2

Successful Login Count:
3

Failed Login Count:
0

====================================
END OF REPORT
====================================
```

---

## Skills Demonstrated

- Bash Scripting
- Linux Administration
- Security Monitoring
- Log Analysis
- Authentication Auditing
- Cron Scheduling
- Text Processing
- System Monitoring
- Troubleshooting

---

## Future Improvements

- Email Notifications
- DaloRADIUS Log Integration
- CSV Report Export
- Multiple Server Reporting
- SIEM Integration
- Alert Thresholds

---

## Author

Syed Basit Aftab

Linux • DevOps • AWS Learning Journey
