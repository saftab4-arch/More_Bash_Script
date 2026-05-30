# Linux & DevOps Hands-On Projects Portfolio

## About This Repository

This repository contains hands-on Linux and DevOps projects completed as part of my learning journey. Each project focuses on practical system administration, automation, monitoring, storage management, and Bash scripting concepts commonly used in real-world environments.

---

# Project 01 - RAM Usage Alert Monitor

## Project Overview

The RAM Usage Alert Monitor is a Bash script that monitors system memory utilization, calculates the percentage of RAM being used, compares it against a predefined threshold, and generates alerts when usage becomes excessive. The script also logs monitoring information for future analysis and troubleshooting.

---

## Features

* Monitor total RAM available on the system
* Monitor free RAM
* Calculate used RAM
* Calculate RAM usage percentage
* Threshold-based alert generation
* Hostname detection
* Date and time tracking
* Log file creation
* Monitoring automation foundation

---

## Complete Script

```bash
#!/bin/bash

THRESHOLD=90

DATE=$(date +%Y-%m-%d_%H:%M:%S)

echo "==============================="
echo "RAM USAGE MONITOR"
echo "==============================="
echo "Date: $DATE"
echo ""

TOTAL_RAM=$(free | grep -i mem | awk '{print $2}')
echo "Total RAM: $TOTAL_RAM"

FREE_RAM=$(free | grep -i mem | awk '{print $4}')
echo "Free RAM: $FREE_RAM"

USED_RAM=$((TOTAL_RAM - FREE_RAM))
echo "USED_RAM: $USED_RAM"

RAM_PERCENTAGE=$(( USED_RAM * 100 / TOTAL_RAM ))
echo "RAM Percentage: $RAM_PERCENTAGE%"

SUBJECT="High RAM Usage Alert"
MESSAGE="Warning! RAM usage on $(hostname) is ${RAM_PERCENTAGE}%"

if [ "$RAM_PERCENTAGE" -ge "$THRESHOLD" ]
then
    echo "================================="
    echo "ALERT: High RAM Usage!"
    echo "$MESSAGE"
    echo "EMAIL ALERT WOULD BE SENT HERE"
    echo "================================="
else
    echo "RAM Usage Normal"
fi

LOGFILE="ram_monitor.log"

{
echo "===== $DATE ====="
echo "RAM Usage: ${RAM_PERCENTAGE}%"
echo "Hostname: $(hostname)"
echo ""
} >> $LOGFILE
```

---

## Concepts Learned

* Variables
* Command Substitution
* grep
* awk
* Arithmetic Expansion
* Conditional Statements (if/else)
* Logging
* Monitoring
* Hostname Detection
* System Administration Basics

---

## Real-World Use Case

System administrators frequently monitor server memory usage to detect performance issues before applications become unresponsive. This script provides the foundation for automated monitoring and alerting systems used in production environments.

---

# Project 02 - Automated Backup Manager

## Project Overview

The Automated Backup Manager is a Bash automation project that creates compressed backups of multiple Linux projects, stores them with timestamped filenames, removes outdated backups, and can be scheduled through cron for fully automated operation.

---

## Features

* Backup multiple project directories
* Automatic timestamp generation
* Compressed `.tar.gz` archives
* Function-based script structure
* Automatic cleanup of old backups
* Cron job automation
* Backup verification support
* Storage management

---

## Complete Script

```bash
#!/bin/bash

BACKUP_DIR="/home/backup"

mkdir -p "$BACKUP_DIR"

create_backup() {

    echo "Creating Backup..."

    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

    echo "TIMESTAMP : $TIMESTAMP"

    BACKUP_FILE="$BACKUP_DIR/backup_${TIMESTAMP}.tar.gz"

    echo "BACKUP FILE: $BACKUP_FILE"

    tar -czf "$BACKUP_FILE" /home/health-monitor /home/ram-usage
}

delete_old_backups() {

    echo "Deleting old backups..."

    find "$BACKUP_DIR" -name "*.tar.gz" -mtime +1 -delete
}

create_backup
delete_old_backups
```

---

## Cron Automation

```cron
* * * * * /home/backup-manager/backup-manager.sh
```

### Cron Schedule Breakdown

| Field | Meaning      |
| ----- | ------------ |
| *     | Minute       |
| *     | Hour         |
| *     | Day of Month |
| *     | Month        |
| *     | Day of Week  |

This example executes the script every minute.

---

## Backup Workflow

```text
Project Directories
        │
        ▼
Create Timestamp
        │
        ▼
Generate Archive
        │
        ▼
Store Backup
        │
        ▼
Delete Old Backups
        │
        ▼
Cron Automation
```

---

## Concepts Learned

* Variables
* Functions
* mkdir -p
* tar
* gzip Compression
* find
* File Cleanup
* Backup Rotation
* Cron Jobs
* Linux Automation

---

## Troubleshooting

```bash
chmod +x backup-manager.sh
apt install cron -y
service cron start
```

---

## Real-World Use Case

Organizations regularly create scheduled backups of applications, configuration files, and databases. Automated backup systems help reduce downtime and provide recovery options during system failures.

---

# Project 03 - Linux Volume Management (LVM) Lab

## Project Overview

This hands-on lab demonstrates how Linux Logical Volume Manager (LVM) works by creating virtual disks, converting them into Physical Volumes, combining them into a Volume Group, and creating Logical Volumes that can be formatted and mounted like traditional storage devices.

---

## Objective

Learn how Linux LVM works by:

* Creating virtual disks
* Creating Physical Volumes (PV)
* Creating a Volume Group (VG)
* Creating Logical Volumes (LV)
* Formatting storage with EXT4
* Mounting filesystems
* Managing flexible storage pools

---

## Environment

| Item             | Value        |
| ---------------- | ------------ |
| Operating System | Ubuntu Linux |
| User             | root         |
| Storage Type     | LVM          |
| Filesystem       | EXT4         |

---

## Architecture

```text
disk1.img (1 GB)  ──┐
                     ├──► devops-vg (2 GB pool)
disk2.img (1 GB)  ──┘         │
                               ├──► app-data (500 MB) → /mnt/app-data
                               └──► db-data  (800 MB) → /mnt/db-data
```

---

## Storage Layout

| Layer           | Name       | Size   |
| --------------- | ---------- | ------ |
| Physical Volume | /dev/loop0 | 1 GB   |
| Physical Volume | /dev/loop1 | 1 GB   |
| Volume Group    | devops-vg  | ~2 GB  |
| Logical Volume  | app-data   | 500 MB |
| Logical Volume  | db-data    | 800 MB |

---

## Step-by-Step Lab

### Step 1 - Check Existing Storage

```bash
lsblk
```

Display available block devices and mount points.

---

### Step 2 - Create Virtual Disk 1

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
```

Create a 1 GB virtual disk file.

---

### Step 3 - Create Virtual Disk 2

```bash
dd if=/dev/zero of=/tmp/disk2.img bs=1M count=1024
```

Create a second 1 GB virtual disk file.

---

### Step 4 - Attach Loop Devices

```bash
losetup -fP /tmp/disk1.img
losetup -fP /tmp/disk2.img
```

Verify:

```bash
losetup -a
```

---

### Step 5 - Verify Devices

```bash
lsblk
```

Expected:

```text
loop0    1G
loop1    1G
```

---

### Step 6 - Create Physical Volumes

```bash
pvcreate /dev/loop0
pvcreate /dev/loop1
```

Verify:

```bash
pvs
```

---

### Step 7 - Create Volume Group

```bash
vgcreate devops-vg /dev/loop0 /dev/loop1
```

Verify:

```bash
vgs
```

---

### Step 8 - Create Logical Volume

```bash
lvcreate -L 500M -n app-data devops-vg
```

Verify:

```bash
lvs
```

---

### Step 9 - Create Database Logical Volume

```bash
lvcreate -L 800M -n db-data devops-vg
```

---

### Step 10 - Format app-data

```bash
mkfs.ext4 /dev/devops-vg/app-data
```

---

### Step 11 - Format db-data

```bash
mkfs.ext4 /dev/devops-vg/db-data
```

---

### Step 12 - Create Mount Points

```bash
mkdir -p /mnt/app-data
mkdir -p /mnt/db-data
```

---

### Step 13 - Mount Filesystems

```bash
mount /dev/devops-vg/app-data /mnt/app-data
mount /dev/devops-vg/db-data /mnt/db-data
```

---

### Step 14 - Verify Configuration

```bash
lsblk
df -h
```

---

## Important Commands and Explanations

### dd

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
```

| Flag  | Description      |
| ----- | ---------------- |
| if    | Input File       |
| of    | Output File      |
| bs    | Block Size       |
| count | Number of Blocks |

---

### losetup

```bash
losetup -fP /tmp/disk1.img
```

| Flag | Description                      |
| ---- | -------------------------------- |
| -f   | Find first available loop device |
| -P   | Scan partitions                  |

---

### pvcreate

```bash
pvcreate /dev/loop0
```

Initialize a device as an LVM Physical Volume.

---

### vgcreate

```bash
vgcreate devops-vg /dev/loop0 /dev/loop1
```

Create a Volume Group using multiple Physical Volumes.

---

### lvcreate

```bash
lvcreate -L 500M -n app-data devops-vg
```

| Flag | Description         |
| ---- | ------------------- |
| -L   | Logical Volume Size |
| -n   | Logical Volume Name |

---

### mkfs.ext4

```bash
mkfs.ext4 /dev/devops-vg/app-data
```

Create an EXT4 filesystem on a Logical Volume.

---

### mount

```bash
mount /dev/devops-vg/app-data /mnt/app-data
```

Attach a filesystem to the Linux directory tree.

---

## Verification Commands

```bash
lsblk
pvs
vgs
lvs
df -h
losetup -a
```

---

## What I Learned

* Virtual disk creation using `dd`
* Loop device management using `losetup`
* Physical Volume creation
* Volume Group creation
* Logical Volume creation
* Filesystem management
* Storage mounting
* LVM architecture and design
* Linux storage administration

---

## Future Improvements

* Extend Logical Volumes using `lvextend`
* Resize filesystems using `resize2fs`
* Add additional disks to the Volume Group
* Configure persistent mounts using `/etc/fstab`
* Create LVM snapshots

---

# Skills Demonstrated

## Linux Administration

* Storage Management
* Filesystem Management
* Process Monitoring
* System Monitoring

## Bash Scripting

* Variables
* Functions
* Arithmetic Operations
* Conditional Logic
* Logging

## Automation

* Cron Jobs
* Scheduled Tasks
* Backup Rotation
* Monitoring Scripts

## DevOps Fundamentals

* Infrastructure Management
* Monitoring
* Backup and Recovery
* Storage Provisioning
* Operational Automation

---

# Repository Roadmap

### Completed Projects

* [x] RAM Usage Alert Monitor
* [x] Automated Backup Manager
* [x] Linux Volume Management (LVM) Lab

### Upcoming Projects

* [ ] Service Monitor & Alert System
* [ ] Disk Usage Monitor
* [ ] Log Analyzer
* [ ] User Management Automation
* [ ] AWS SES Email Notification Lab
* [ ] Self-Hosted Mail Server Lab

---

# Author

**Basit**

Linux & DevOps Learning Journey 🐧

Building hands-on projects to strengthen Linux Administration, Bash Scripting, Automation, Monitoring, Storage Management, and DevOps Engineering skills.
