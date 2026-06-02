# 🧹 Log Cleanup Utility

A Bash script that automatically identifies and removes old log files from a Linux system. The script scans a specified directory, lists available log files, identifies logs older than a configurable number of days, records cleanup activity in an audit log, and removes outdated files.

This project simulates a real-world DevOps and Linux Administration task where applications continuously generate log files that must be managed to prevent excessive disk usage.

---

## 📋 Project Objectives

- Learn Bash scripting fundamentals
- Work with variables and functions
- Use the Linux `find` command
- Filter files by age using `-mtime`
- Automate maintenance tasks
- Implement audit logging
- Schedule jobs using Cron
- Simulate a real-world log retention policy

---

## 🛠️ Technologies Used

- Linux
- Bash
- Cron
- Find Utility

---

## 📁 Project Structure

```
05-log-cleanup/
├── log_cleanup.sh
├── cleanup.log
└── README.md
```

---

## 📜 Full Script

```bash
#!/bin/bash

LOG_DIR="."
LOGFILE="cleanup.log"
DAYS=7

cleanup_logs() {
    echo "$(date) - Cleanup started" >> "$LOGFILE"
    find "$LOG_DIR" -name "*.log" ! -name "cleanup.log" -mtime +"$DAYS" >> "$LOGFILE"
    find "$LOG_DIR" -name "*.log" ! -name "cleanup.log" -mtime +"$DAYS" -delete
    echo "$(date) - Cleanup complete" >> "$LOGFILE"
}

echo "========================="
echo "LOG CLEANUP UTILITY"
echo "========================="
echo "Date: $(date)"
echo ""

LOG_COUNT=$(find "$LOG_DIR" -name "*.log" | wc -l)
echo "Log files found: $LOG_COUNT"
echo ""

echo "Log files:"
find "$LOG_DIR" -name "*.log"
echo ""

echo "Old log files:"
find "$LOG_DIR" -name "*.log" ! -name "cleanup.log" -mtime +"$DAYS"
echo ""

echo "Deleting old log files..."
cleanup_logs
echo "Cleanup complete."
```

---

## ⚙️ How The Script Works

---

### Variables Explained

#### `LOG_DIR`

```bash
LOG_DIR="."
```

Defines the directory that will be scanned for log files.

**Examples:**
```bash
LOG_DIR="/var/log/nginx"
LOG_DIR="/opt/app/logs"
LOG_DIR="/var/log/apache2"
```

---

#### `LOGFILE`

```bash
LOGFILE="cleanup.log"
```

Stores cleanup activity and provides an audit trail of script execution.

---

#### `DAYS`

```bash
DAYS=7
```

Defines the retention period. Files older than 7 days will be deleted.

---

### Function Explained

#### `cleanup_logs()`

A reusable function that:

1. Records cleanup start time
2. Records files identified for deletion
3. Deletes old log files
4. Records cleanup completion time

**Benefits:**
- Cleaner code
- Easier maintenance
- Reusable logic
- Better readability

---

## 🔧 Commands and Flags Explained

---

### Find Command

```bash
find "$LOG_DIR" -name "*.log"
```

Searches for log files.

| Component | Purpose |
|-----------|---------|
| `find` | Search utility |
| `-name` | Search by filename |
| `"*.log"` | Match all log files |

---

### Excluding `cleanup.log`

```bash
! -name "cleanup.log"
```

The `!` operator means **NOT**.

```bash
find "$LOG_DIR" -name "*.log" ! -name "cleanup.log"
```

Finds all log files **except** `cleanup.log` — this prevents the script from processing its own audit log.

---

### Modification Time

```bash
-mtime +"$DAYS"
```

Finds files older than the configured retention period.

| Flag | Meaning |
|------|---------|
| `-mtime +7` | Older than 7 days |
| `-mtime +30` | Older than 30 days |
| `-mtime -7` | Newer than 7 days |

---

### Delete Flag

```bash
-delete
```

Deletes files returned by the `find` command.

```bash
find "$LOG_DIR" -name "*.log" -mtime +7 -delete
```

---

### Command Substitution

```bash
$(date)
```

Executes the `date` command and inserts the output inline.

```bash
echo "Date: $(date)"
```

---

### Pipe Operator

```bash
|
```

Passes output from one command to another.

```bash
find "$LOG_DIR" -name "*.log" | wc -l
```

---

### Word Count

```bash
wc -l
```

Counts lines — used here to count discovered log files.

---

## 📋 Audit Logging

The script records all cleanup activity inside `cleanup.log`.

**Example output:**
```
Tue Jun 2 09:26:03 EDT 2026 - Cleanup started
./soda.log
Tue Jun 2 09:26:03 EDT 2026 - Cleanup complete
```

**Benefits:**
- Tracks cleanup operations
- Records files targeted for deletion
- Assists with troubleshooting
- Provides operational visibility
- Creates an audit trail

---

## ⏰ Cron Job Automation

To automate cleanup, add this to your crontab:

```bash
0 2 * * * /home/05-log-cleanup/log_cleanup.sh
```

**Schedule breakdown:**

| Field | Value | Meaning |
|-------|-------|---------|
| Minute | `0` | At minute 0 |
| Hour | `2` | At 2 AM |
| Day of Month | `*` | Every day |
| Month | `*` | Every month |
| Day of Week | `*` | Every day of the week |

The script runs **every day at 2:00 AM** automatically.

---

## 🌍 Real-World Use Cases

This type of automation is commonly used for:

- Nginx Access Logs
- Nginx Error Logs
- Apache Logs
- Java Application Logs
- Linux Server Maintenance
- DevOps Operations
- SRE Automation
- Application Log Retention Policies

**Example production path:**
```bash
LOG_DIR="/var/log/nginx"
```

The same script can automatically remove logs older than a specified retention period.

---

## 🔄 Example Workflow

```
1. Application generates log files
2. Log files accumulate over time
3. Cron executes the script daily at 2 AM
4. Script identifies logs older than retention period
5. Old logs are recorded in cleanup.log
6. Old logs are deleted automatically
7. Disk space remains under control ✅
```

---

## 🧠 Skills Practiced

- Bash Scripting
- Linux Administration
- Variables
- Functions
- File Management
- Log Retention Policies
- Cron Scheduling
- Audit Logging
- Automation
- DevOps Fundamentals

---

## 📸 Screenshots

> Add screenshots showing:
> 1. Creating test log files
> 2. Setting file age using `touch`
> 3. Script creation in Nano
> 4. Listing log files
> 5. Finding old logs with `-mtime`
> 6. Running the cleanup script
> 7. Verifying deleted logs
> 8. Viewing `cleanup.log`
> 9. Cron job configuration

---

## 📖 Learning Outcome

This project demonstrates how DevOps Engineers and Linux Administrators automate routine maintenance tasks. By combining Bash scripting, file discovery, retention policies, audit logging, and Cron scheduling, the solution helps prevent uncontrolled log growth and supports reliable server operations.

---

## 👤 Author

**Syed Aftab**

[![GitHub](https://img.shields.io/badge/GitHub-saftab4--arch-181717?style=flat&logo=github)](https://github.com/saftab4-arch)

---

*Part of the [#90DaysOfDevOps](https://github.com/saftab4-arch) challenge*

`#Linux` `#Bash` `#DevOps` `#Automation` `#Cron` `#90DaysOfDevOps`
