# User Login Audit Report

A Bash script that generates a simple login audit report by analyzing Linux login history.

## Project Overview

This script collects login information from the system and generates a report containing:

- Current logged-in user
- Timestamp of report generation
- Total login records found
- Unique login sources and their occurrence counts
- Audit report saved to a log file

The project demonstrates common Linux administration and Bash scripting techniques used in DevOps environments.

---

## Technologies Used

- Bash
- Linux Commands
- AWK
- GREP
- SORT
- UNIQ
- WC

---

## The Script

```bash
#!/bin/bash

LOG_FILE="audit_report.log"

show_header() {
    echo "===================================="
    echo "        USER LOGIN AUDIT REPORT"
    echo "===================================="
    echo "Generated: $(date)"
}

show_current_user() {
    echo
    echo "Current User:"
    whoami
}

show_login_count() {
    echo
    echo "Total Login Records:"
    last | grep -v "wtmp" | wc -l
}

show_login_sources() {
    echo
    echo "Login Record Counts:"
    last | awk '{print $1}' \
        | grep -v '^$' \
        | grep -v "wtmp" \
        | sort \
        | uniq -c
}

show_footer() {
    echo
    echo "===================================="
    echo "            END OF REPORT"
    echo "===================================="
}

# Write the full report to the log file
{
    echo "===================================="
    echo "USER LOGIN AUDIT REPORT"
    echo "Generated: $(date)"
    echo

    echo "Current User:"
    whoami

    echo
    echo "Total Login Records:"
    last | grep -v "wtmp" | wc -l

    echo
    echo "Login Record Counts:"
    last | awk '{print $1}' | grep -v '^$' | grep -v "wtmp" | sort | uniq -c

} >> "$LOG_FILE"

# Print the report to the terminal
show_header
show_current_user
show_login_count
show_login_sources
show_footer
```

---

## How to Run

```bash
chmod +x user_audit.sh
./user_audit.sh
```

The report prints to the terminal and is appended to `audit_report.log`.

---

## Features

### Current User Detection

Displays the user running the script.

```bash
whoami
```

---

### Timestamp Generation

Adds the date and time when the report was generated.

```bash
date
```

---

### Login Record Counting

Counts total login records found in system login history.

```bash
last | grep -v "wtmp" | wc -l
```

---

### Unique Login Source Analysis

Extracts the first column from login records and counts occurrences.

```bash
last | awk '{print $1}' | grep -v '^$' | grep -v "wtmp" | sort | uniq -c
```

---

### Audit Log File Creation

Stores report output inside:

```text
audit_report.log
```

using append redirection:

```bash
>>
```

---

## Commands Explained

### last

Displays login history.

```bash
last
```

---

### awk '{print $1}'

Extracts the first column.

Example:

```text
kc-inter pts/0 ...
```

becomes:

```text
kc-inter
```

---

### grep -v '^$'

Removes blank lines.

---

### grep -v "wtmp"

Removes the informational line:

```text
wtmp begins ...
```

---

### sort

Sorts results alphabetically.

---

### uniq -c

Counts duplicate entries.

Example:

```text
2 kc-inter
3 reboot
```

---

### wc -l

Counts total lines.

---

## Sample Output

```text
======================================
USER LOGIN AUDIT REPORT
Generated: Wed Jun 03 11:59:03 UTC 2026

Current User:
root

Total Login Records:
6

Login Record Counts:
2 kc-inter
3 reboot

======================================
END OF REPORT
======================================
```

---

## Learning Objectives

This project helped practice:

- Bash Functions
- Variables
- Command Substitution
- Linux Login Auditing
- Log File Generation
- Output Redirection
- Text Processing
- Shell Pipelines
- Linux Administration Basics

---

## Author

Syed Basit Aftab

Linux • DevOps • AWS Learning Journey
