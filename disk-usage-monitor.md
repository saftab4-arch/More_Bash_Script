# 💾 Disk Usage Monitor

A Bash script that monitors Linux disk usage, compares it against a configurable threshold, displays the result in the terminal, and logs all activity to a log file.

---

## 📁 Project Structure

```
disk-usage-monitor/
├── disk-usage-monitor.sh
├── disk-usage-monitor.log
└── README.md
```

---

## 📜 Full Script

```bash
#!/bin/bash

DATE=$(date)
HOSTNAME=$(hostname)

LOGFILE="disk-usage-monitor.log"
THRESHOLD=80

check_disk_usage() {

    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Current Disk Usage: $DISK_USAGE%"

    echo "$(date) - Disk Usage: $DISK_USAGE%" >> "$LOGFILE"

    if [ "$DISK_USAGE" -gt "$THRESHOLD" ]
    then
        echo "WARNING: Disk usage exceeded threshold!" | tee -a "$LOGFILE"
    else
        echo "INFO: Disk usage is normal."
    fi
}

echo "==========================="
echo "DISK USAGE MONITOR"
echo "==========================="
echo ""

echo "Date: $DATE"
echo "Hostname: $HOSTNAME"
echo ""

check_disk_usage
```

---

## ⚙️ How The Script Works

### Step 1 — Store Current Date

```bash
DATE=$(date)
```

Runs the `date` command and stores the current date and time in the `DATE` variable.

**Example output:**
```
Mon Jun 1 12:28:22 EDT 2026
```

---

### Step 2 — Store Hostname

```bash
HOSTNAME=$(hostname)
```

Runs the `hostname` command and stores the machine hostname.

**Example output:**
```
64b1a6a6a041
```

---

### Step 3 — Define Variables

```bash
LOGFILE="disk-usage-monitor.log"
THRESHOLD=80
```

| Variable    | Purpose                                              |
|-------------|------------------------------------------------------|
| `LOGFILE`   | Stores the name of the log file                      |
| `THRESHOLD` | Maximum acceptable disk usage percentage (default: 80%) |

---

### Step 4 — Create Function

```bash
check_disk_usage() {

}
```

Creates a reusable Bash function containing all disk-monitoring logic. Functions help organize code and reduce repetition.

---

### Step 5 — Check Disk Usage

```bash
df -h /
```

**Example output:**
```
Filesystem      Size  Used Avail Use% Mounted on
overlay        1007G  3.5G  953G   1% /
```

| Flag | Description                              |
|------|------------------------------------------|
| `df` | Display filesystem disk space usage       |
| `-h` | Human-readable sizes (G, M, K)           |
| `/`  | Target the Linux root filesystem          |

---

### Step 6 — Extract Disk Usage Percentage

```bash
awk 'NR==2 {print $5}'
```

**Input:**
```
Filesystem  Size  Used  Avail  Use%  Mounted on
overlay     1007G  3.5G  953G   1%   /
```

**Output:**
```
1%
```

| Component   | Description                               |
|-------------|-------------------------------------------|
| `awk`       | Text-processing tool for column extraction |
| `NR==2`     | Select only line 2 (skip the header)       |
| `print $5`  | Print the 5th column (the `Use%` value)    |

---

### Step 7 — Remove the Percent Sign

```bash
tr -d '%'
```

| Before | After |
|--------|-------|
| `1%`   | `1`   |

| Flag  | Description                        |
|-------|------------------------------------|
| `tr`  | Translate/remove characters        |
| `-d`  | Delete the specified character      |
| `'%'` | The character to remove             |

This converts the value to a plain integer so Bash can perform numeric comparisons.

---

### Step 8 — Store Disk Usage

```bash
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
```

Combines all three commands using pipes to store a clean integer value:

```
1
```

---

### Step 9 — Display Current Usage

```bash
echo "Current Disk Usage: $DISK_USAGE%"
```

**Output:**
```
Current Disk Usage: 1%
```

---

### Step 10 — Write to Log File

```bash
echo "$(date) - Disk Usage: $DISK_USAGE%" >> "$LOGFILE"
```

**Log entry example:**
```
Mon Jun 1 12:28:22 EDT 2026 - Disk Usage: 1%
```

#### `>` vs `>>`

| Operator | Behavior                                |
|----------|-----------------------------------------|
| `>`      | **Overwrites** the file (old data lost) |
| `>>`     | **Appends** to the file (old data kept) |

---

### Step 11 — Compare Against Threshold

```bash
if [ "$DISK_USAGE" -gt "$THRESHOLD" ]
```

| Operator | Meaning      | Example          | Result |
|----------|--------------|------------------|--------|
| `-gt`    | Greater than | `5 -gt 3`        | True   |
| `-gt`    | Greater than | `1 -gt 80`       | False  |

---

### Step 12 — Generate Alert

```bash
echo "WARNING: Disk usage exceeded threshold!" | tee -a "$LOGFILE"
```

The `tee -a` command writes output to **both the screen and the log file** simultaneously.

| Flag | Description                         |
|------|-------------------------------------|
| `tee`| Write to screen and file at once     |
| `-a` | Append to file (don't overwrite)     |

---

### Step 13 — Normal Status Message

```bash
echo "INFO: Disk usage is normal."
```

Displays a healthy status message when disk usage is below the threshold.

---

## 🔧 Commands Reference

| Command                       | Description                                    |
|-------------------------------|------------------------------------------------|
| `date`                        | Print current date and time                    |
| `hostname`                    | Print machine hostname                          |
| `df -h /`                     | Show disk usage for the root filesystem        |
| `awk 'NR==2 {print $5}'`      | Extract the 5th column from the 2nd line       |
| `tr -d '%'`                   | Remove the percent sign                         |
| `echo`                        | Print text to the terminal                      |
| `tee -a`                      | Write to screen and append to file             |
| `chmod u+x disk-usage-monitor.sh` | Make the script executable                |
| `cat disk-usage-monitor.log`  | View the log file                              |

---

## 🚀 Setup & Usage

**Make the script executable:**

```bash
chmod u+x disk-usage-monitor.sh
```

**Run the script:**

```bash
./disk-usage-monitor.sh
```

> The `./` tells Linux to execute the script from the current directory.

---

## 📤 Sample Output

```
===========================
DISK USAGE MONITOR
===========================

Date: Mon Jun 1 12:28:22 EDT 2026
Hostname: 64b1a6a6a041

Current Disk Usage: 1%

INFO: Disk usage is normal.
```

---

## 📋 Sample Log File

```
Mon Jun 1 12:09:38 EDT 2026 - Disk Usage: 1%
Mon Jun 1 12:10:28 EDT 2026 - Disk Usage: 1%
Mon Jun 1 12:11:43 EDT 2026 - Disk Usage: 1%
Mon Jun 1 12:28:22 EDT 2026 - Disk Usage: 1%
```

---

## 📸 Screenshots

> Add screenshots showing:
> 1. Script execution
> 2. Log file output
> 3. Script source code
> 4. Threshold comparison logic

---

## 🧠 What I Learned

- Creating Bash variables
- Command substitution using `$()`
- Writing and calling functions
- Monitoring disk usage with `df`
- Extracting data using `awk`
- Removing characters using `tr`
- Using conditional statements (`if`/`else`)
- Numeric comparisons using `-gt`
- Logging output to files using `>>`
- Using `tee` for simultaneous screen and file output
- Managing executable permissions with `chmod`

---

## 👤 Author

**Syed Aftab**

[![GitHub](https://img.shields.io/badge/GitHub-saftab4--arch-181717?style=flat&logo=github)](https://github.com/saftab4-arch)

---

*Part of the [#90DaysOfDevOps](https://github.com/saftab4-arch) challenge*

`#Linux` `#Bash` `#DevOps` `#Monitoring` `#90DaysOfDevOps`
