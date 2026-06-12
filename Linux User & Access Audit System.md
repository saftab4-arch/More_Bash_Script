# Linux User & Access Audit System



## Overview

A Linux administration and security auditing script that collects and reports user access information from a Linux server. This project simulates a common cloud operations task where administrators must review user accounts, group memberships, administrative privileges, and access controls during security audits, compliance reviews, or incident investigations.

The script generates a structured audit report containing:

- All system user accounts
- Linux group memberships
- Sudo (administrative) access information
- User privilege details (UID/GID)
- Login audit status
- System metadata (hostname, timestamp)

---

## Project Structure

```
user-access-audit/
├── user_access_audit.sh       # Main audit script
└── user_access_report.txt     # Generated audit report (auto-created on run)
```

---

## The Script

```bash
#!/bin/bash

REPORT="user_access_report.txt"

echo "==================================" > "$REPORT"
echo "User & Access Audit Report" >> "$REPORT"
echo "Generated: $(date)" >> "$REPORT"
echo "Hostname: $(hostname)" >> "$REPORT"
echo "==================================" >> "$REPORT"

echo "" >> "$REPORT"
echo "=== USERS ===" >> "$REPORT"
cut -d: -f1 /etc/passwd >> "$REPORT"

echo "" >> "$REPORT"
echo "=== GROUPS ===" >> "$REPORT"
cut -d: -f1 /etc/group >> "$REPORT"

echo "" >> "$REPORT"
echo "=== SUDO MEMBERS ===" >> "$REPORT"
grep sudo /etc/group >> "$REPORT"

echo "" >> "$REPORT"
echo "=== UBUNTU USER DETAILS ===" >> "$REPORT"
id ubuntu >> "$REPORT"

echo "" >> "$REPORT"
echo "=== LOGIN AUDIT ===" >> "$REPORT"

if command -v lastlog >/dev/null 2>&1
then
  lastlog >> "$REPORT"
else
  echo "lastlog utility not installed in container." >> "$REPORT"
fi

echo "" >> "$REPORT"
echo "=== AUDIT COMPLETE ===" >> "$REPORT"

echo "Report created: $REPORT"
```

---

## Usage

```bash
# Grant execute permissions
chmod +x user_access_audit.sh

# Run the audit
./user_access_audit.sh

# View the generated report
cat user_access_report.txt
```

---

## Commands Explained

### List All Users

```bash
cut -d: -f1 /etc/passwd
```

| Option | Meaning |
|--------|---------|
| `cut` | Extract specific fields from text |
| `-d:` | Use `:` as the field delimiter |
| `-f1` | Display only field 1 (the username) |
| `/etc/passwd` | Linux user database |

**Example — Input:**
```
ubuntu:x:1000:1000:Ubuntu User:/home/ubuntu:/bin/bash
```
**Output:**
```
ubuntu
```

---

### List All Groups

```bash
cut -d: -f1 /etc/group
```

Displays all configured Linux groups from `/etc/group`.

---

### Identify Sudo Users

```bash
grep sudo /etc/group
```

**Example output:**
```
sudo:x:27:ubuntu
```

| Field | Meaning |
|-------|---------|
| `sudo` | Group name |
| `x` | Password placeholder |
| `27` | Group ID (GID) |
| `ubuntu` | Group members |

Identifies which users have been granted administrative (root-level) privileges.

---

### Inspect User Permissions

```bash
id ubuntu
```

**Example output:**
```
uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),27(sudo)
```

Shows:
- **UID** — User ID (how Linux internally tracks users)
- **Primary GID** — The user's default group
- **Supplementary groups** — All additional groups the user belongs to (including `sudo`)

---

## Understanding UID and GID

Linux tracks users and groups by numeric identifiers, not names.

| Identifier | Example | Description |
|------------|---------|-------------|
| UID | `uid=1000(ubuntu)` | Unique user identifier |
| GID | `gid=1000(ubuntu)` | Primary group identifier |

Common system GIDs:

| Group | GID |
|-------|-----|
| root | 0 |
| adm | 4 |
| sudo | 27 |
| video | 44 |

---

## Troubleshooting: `lastlog` Not Found

During testing inside an Ubuntu Docker container, `lastlog` was not available:

```bash
$ lastlog
bash: lastlog: command not found

$ which lastlog
(no output)
```

**Root cause:** Minimal Docker images do not include all standard Linux auditing utilities.

**Note for production:** Full Linux servers and EC2 instances typically include:

| Tool | Purpose |
|------|---------|
| `lastlog` | Shows last login time per user |
| `last` | Lists recent login sessions |
| `w` | Shows who is currently logged in |
| `who` | Lists active sessions |

The script handles this gracefully with a `command -v` check and logs the missing tool rather than failing.

---

## Sample Audit Report Output

```
==================================
User & Access Audit Report
Generated: Fri Jun 12 14:32:01 UTC 2026
Hostname: container-host
==================================

=== USERS ===
root
daemon
ubuntu
...

=== GROUPS ===
root
sudo
ubuntu
...

=== SUDO MEMBERS ===
sudo:x:27:ubuntu

=== UBUNTU USER DETAILS ===
uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),27(sudo)

=== LOGIN AUDIT ===
lastlog utility not installed in container.

=== AUDIT COMPLETE ===
```

---

## Security Findings

| Check | Finding |
|-------|---------|
| Unexpected users | None found |
| Administrative access | `ubuntu` is a member of the `sudo` group — expected for this environment |
| Login history | Unable to verify; `lastlog` not available in this container image |

---

## Real-World Use Cases

This type of audit is commonly performed during:

- Security audits and compliance reviews (SOC 2, CIS Benchmarks)
- User access reviews (quarterly or post-incident)
- New administrator onboarding
- Incident response investigations
- Server ownership transitions
- Cloud environment assessments (AWS EC2, Azure VMs)

---

## Technologies Used

| Technology | Purpose |
|------------|---------|
| Bash | Script language |
| Linux / Ubuntu | Target OS |
| Docker | Containerized test environment |
| `/etc/passwd` | User account database |
| `/etc/group` | Group membership database |

---

## Key Takeaways

- Linux stores user data in `/etc/passwd` and group data in `/etc/group`
- Users inherit permissions through group memberships, not just individual assignments
- Administrative access is granted via the `sudo` group
- Linux uses numeric UID/GID values internally — names are just labels
- Minimal containers may lack standard OS auditing tools; scripts should handle this gracefully
- Access auditing is a core responsibility for Cloud and DevOps engineers

---

## Skills Demonstrated

`Linux Administration` · `User Management` · `Group Management` · `Sudo Access Verification` · `Security Auditing` · `Bash Scripting` · `Docker` · `Troubleshooting` · `Access Control Review` · `System Documentation`
