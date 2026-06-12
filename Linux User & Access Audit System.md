Project 02 – User & Access Audit System
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




Overview
The User & Access Audit System is a Linux administration and security auditing project designed to collect and report user access information from a Linux server.

This project simulates a common cloud operations task where administrators must review user accounts, group memberships, administrative privileges, and access controls during security audits, compliance reviews, or incident investigations.

The script generates an audit report containing:

System users

Linux groups

Sudo access information

User privilege details

Login audit status

System metadata

Objectives
Learn Linux user management concepts

Understand Linux groups and permissions

Identify administrative users

Generate access audit reports

Practice Bash scripting

Simulate real-world cloud operations tasks

Technologies Used
Linux

Ubuntu Container

Docker

Bash

User Management Commands

Linux Permission Model

Project Structure
user-access-audit/
│
├── user_access_audit.sh
└── user_access_report.txt
Commands Used During Investigation
List All Users
cut -d: -f1 /etc/passwd
Command Breakdown
Option	Meaning
cut	Extract specific fields from text
-d:	Use ":" as delimiter
-f1	Display field 1
/etc/passwd	Linux user database
Example
Input:

ubuntu:x:1000:1000:Ubuntu User:/home/ubuntu:/bin/bash
Output:

ubuntu
Purpose
Displays all user accounts configured on the system.

List All Groups
cut -d: -f1 /etc/group
Purpose
Displays all configured Linux groups.

Identify Sudo Users
grep sudo /etc/group
Example Output
sudo:x:27:ubuntu
Breakdown
Field	Meaning
sudo	Group Name
x	Password Placeholder
27	Group ID (GID)
ubuntu	Group Members
Purpose
Identifies users with administrative privileges.

Inspect User Permissions
id ubuntu
Example Output
uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),27(sudo)
Purpose
Displays:

User ID (UID)

Primary Group (GID)

Additional Group Memberships

Used to verify effective permissions.

Understanding UID and GID
UID
User Identifier

Example:

uid=1000(ubuntu)
Linux internally tracks users by UID rather than username.

GID
Group Identifier

Example:

27(sudo)
Linux tracks groups using GIDs.

Examples:

Group	GID
root	0
adm	4
sudo	27
video	44
Login Audit Investigation
Attempted command:

lastlog
Result:

bash: lastlog: command not found
Additional verification:

which lastlog
command -v lastlog
Both commands returned no output.

Finding
The Ubuntu Docker container did not include the lastlog utility.

Real-World Note
Production Linux servers and EC2 instances typically contain login auditing utilities such as:

lastlog
last
w
who
Minimal Docker images may not include these tools.

Generated Audit Report
The script automatically collects:

Audit timestamp

Hostname

User accounts

Linux groups

Sudo group members

User permission details

Login audit status

Example:

==================================
User & Access Audit Report
Generated: Fri Jun 12
Hostname: container-host
==================================
Security Findings
User Review
User account discovered:

ubuntu
Administrative Access
Verified through:

grep sudo /etc/group
and

id ubuntu
Finding:

ubuntu is a member of the sudo group.
Login Audit
Unable to verify login history because the container image does not include the lastlog utility.

Risk Assessment
No unexpected privileged users identified.

Script Execution
Grant execute permissions:

chmod +x user_access_audit.sh
Run:

./user_access_audit.sh
View report:

cat user_access_report.txt
Real-World Cloud Operations Use Cases
This type of audit is commonly performed during:

Security audits

Compliance reviews

User access reviews

New administrator onboarding

Incident response investigations

Server ownership transitions

Cloud environment assessments

Skills Demonstrated
Linux Administration

User Management

Group Management

Sudo Access Verification

Security Auditing

Bash Scripting

Docker Administration

System Documentation

Troubleshooting

Access Control Review

Key Lessons Learned
Linux stores user information in /etc/passwd

Linux stores group information in /etc/group

Users inherit permissions through groups

Administrative access is typically granted through the sudo group

UID and GID values are used internally by Linux

Containers may not contain full operating system auditing utilities

Access auditing is a critical responsibility for Cloud and DevOps engineers

