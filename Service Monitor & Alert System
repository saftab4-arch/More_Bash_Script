# Day 2 - Service Monitor & Alert System

## Project Overview

This project is a Bash-based monitoring tool that checks whether a user-specified process is currently running on a Linux system. The script records monitoring results, displays status information on the screen, and writes detailed logs to a file for future analysis.

The project was developed inside an Ubuntu Docker container as part of a Linux and DevOps learning journey.

---

## Objectives

* Accept user input dynamically
* Check if a process is running
* Display process status
* Record monitoring results in a log file
* Capture hostname information
* Capture date and time information
* Practice Bash scripting fundamentals
* Learn process monitoring concepts

---

## Environment

| Item             | Value            |
| ---------------- | ---------------- |
| Operating System | Ubuntu Linux     |
| Environment      | Docker Container |
| User             | root             |
| Shell            | Bash             |

---

## Features

* Dynamic process name input
* Process monitoring using `ps aux`
* Process filtering using `grep`
* Conditional logic using `if/else`
* Function-based design
* Date and time tracking
* Hostname detection
* Log file creation
* Status display on screen
* Monitoring history logging

---

## Script Workflow

```text
User Enters Process Name
            │
            ▼
     Process Check
            │
            ▼
   Process Running?
      │          │
      ▼          ▼
    YES          NO
      │          │
      ▼          ▼
 Display      Display
 RUNNING      NOT RUNNING
      │          │
      └────┬─────┘
           ▼
      Write Log
```

---

## Complete Script

```bash
#!/bin/bash

DATE=$(date)
HOSTNAME=$(hostname)
LOGFILE="service-monitor.log"

check_process() {

    if ps aux | grep "$SERVICE" | grep -v grep > /dev/null
    then
        echo "STATUS : RUNNING"
        echo "PROCESS: $SERVICE"

        {
            echo "===================="
            echo "Date: $DATE"
            echo "Hostname: $HOSTNAME"
            echo "Process: $SERVICE"
            echo "Status: RUNNING"
            echo "===================="
            echo ""
        } >> "$LOGFILE"

    else
        echo "STATUS : NOT RUNNING"
        echo "PROCESS: $SERVICE"

        {
            echo "===================="
            echo "Date: $DATE"
            echo "Hostname: $HOSTNAME"
            echo "Process: $SERVICE"
            echo "Status: NOT RUNNING"
            echo "===================="
            echo ""
        } >> "$LOGFILE"
    fi
}

echo "==============================="
echo "SERVICE MONITOR & ALERT SYSTEM"
echo "==============================="

echo "Date : $DATE"
echo ""

echo "Hostname: $HOSTNAME"

read -p "Enter service name: " SERVICE

echo ""
echo "You entered: $SERVICE"

echo ""
echo "Checking service..."

check_process
```

---

## Sample Output

### Running Process

```text
SERVICE MONITOR & ALERT SYSTEM

Date : Sat May 30 13:16:47 UTC 2026

Hostname: 9afeb7e9feb0

Enter service name: bash

Checking service...

STATUS : RUNNING
PROCESS: bash
```

### Process Not Running

```text
SERVICE MONITOR & ALERT SYSTEM

Date : Sat May 30 13:16:47 UTC 2026

Hostname: 9afeb7e9feb0

Enter service name: ssh

Checking service...

STATUS : NOT RUNNING
PROCESS: ssh
```

---

## Log File Example

```text
====================
Date: Sat May 30 13:16:47 UTC 2026
Hostname: 9afeb7e9feb0
Process: ssh
Status: NOT RUNNING
====================
```

---

## Commands Learned

### Process Monitoring

```bash
ps aux
```

| Option | Meaning                       |
| ------ | ----------------------------- |
| a      | Show processes from all users |
| u      | Display user-oriented format  |
| x      | Include background processes  |

---

### Process Searching

```bash
grep
```

Searches for matching text.

Example:

```bash
grep nginx
```

---

### Exclude Matches

```bash
grep -v grep
```

| Option | Meaning                               |
| ------ | ------------------------------------- |
| -v     | Invert match (exclude matching lines) |

Used to prevent the grep process from matching itself.

---

### Command Substitution

```bash
DATE=$(date)
```

Stores command output inside a variable.

---

### Output Redirection

```bash
>> logfile
```

Appends output to a file without overwriting existing data.

---

### Functions

```bash
check_process() {

}
```

Used to group related commands and improve script organization.

---

## Concepts Learned

* Variables
* User Input
* Command Substitution
* Process Monitoring
* grep Filtering
* grep -v
* Pipes
* if/else Statements
* Exit Codes
* Functions
* Logging
* Hostname Detection
* Bash Script Structure

---

## Troubleshooting

### Issue: nano command not found

Error:

```text
nano: command not found
```

Fix:

```bash
apt update
apt install nano -y
```

---

### Issue: sudo command not found

Inside the Docker container the user was already logged in as root.

```bash
whoami
```

Output:

```text
root
```

Therefore `sudo` was unnecessary.

---

### Issue: systemctl command not found

Error:

```text
systemctl: command not found
```

Reason:

Docker containers do not run a full init system such as `systemd`.

Commands like:

```bash
systemctl status ssh
systemctl status nginx
```

typically require a full Linux VM or physical server.

Because this project was developed inside a Docker container, process monitoring using:

```bash
ps aux
```

was used instead of service monitoring through `systemctl`.

---

## Real-World Use Cases

* Basic process monitoring
* Linux administration
* Docker container troubleshooting
* DevOps health checks
* Service verification
* Log generation and auditing

---

## Skills Demonstrated

* Linux Administration
* Bash Scripting
* Process Monitoring
* Troubleshooting
* Logging
* Automation Fundamentals
* DevOps Fundamentals

---

## Author

**Basit**

Linux & DevOps Learning Journey 🐧
