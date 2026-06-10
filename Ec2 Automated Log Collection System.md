Automated Log Collection System
Project Overview
The Automated Log Collection System is a simple Bash script that collects important Linux system logs, stores them in a dedicated directory, and creates a compressed archive for backup and troubleshooting purposes.

This project introduces basic Linux administration concepts such as log management, file operations, archiving, compression, and automation.

Features
Collects system logs

Creates directories automatically

Generates timestamped backup files

Compresses logs into a .tar.gz archive

Stores archives for future reference

Provides user-friendly output messages

Technologies Used
Linux

Bash Scripting

tar

gzip

cp

mkdir

Script
#!/bin/bash

mkdir -p collected_logs

mkdir -p logs_archive

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

cp /var/log/auth.log collected_logs/

cp /var/log/syslog collected_logs/

ARCHIVE_NAME="logs_archive/log_backup_$TIMESTAMP.tar.gz"

tar -czf "$ARCHIVE_NAME" collected_logs

echo "Logs collected successfully."

echo "Compressed archive saved as: $ARCHIVE_NAME"
How the Script Works
Step 1 – Create Log Collection Directory
mkdir -p collected_logs
Creates a directory named collected_logs.

The -p option prevents errors if the directory already exists.

Step 2 – Create Archive Directory
mkdir -p logs_archive
Creates a directory to store compressed log archives.

Step 3 – Generate Timestamp
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
Creates a unique timestamp.

Example:

2026-06-10_14-30-45
This prevents backup files from overwriting previous backups.

Step 4 – Copy Log Files
cp /var/log/auth.log collected_logs/
Copies authentication logs.

Authentication logs contain information about:

SSH logins

Failed login attempts

User authentication events

cp /var/log/syslog collected_logs/
Copies system logs.

System logs contain:

Service messages

System events

Application logs

Step 5 – Create Archive Name
ARCHIVE_NAME="logs_archive/log_backup_$TIMESTAMP.tar.gz"
Creates a unique archive filename.

Example:

logs_archive/log_backup_2026-06-10_14-30-45.tar.gz
Step 6 – Compress Logs
tar -czf "$ARCHIVE_NAME" collected_logs
Creates a compressed archive.

Options used:

Option	Description
c	Create archive
z	Compress using gzip
f	Specify output file
Step 7 – Display Status Messages
echo "Logs collected successfully."
Displays a success message.

echo "Compressed archive saved as: $ARCHIVE_NAME"
Displays the archive location.

Project Structure
10-log-collection-system
│
├── log_collection.sh
│
├── collected_logs
│   ├── auth.log
│   └── syslog
│
└── logs_archive
    └── log_backup_YYYY-MM-DD_HH-MM-SS.tar.gz
Running the Script
Make the script executable:

chmod +x log_collection.sh
Run the script:

./log_collection.sh
Verify Collected Logs
ls collected_logs
Expected output:

auth.log
syslog
Verify Archive Creation
ls logs_archive
Expected output:

log_backup_2026-06-10_14-30-45.tar.gz
View Archive Contents
tar -tzf logs_archive/log_backup_2026-06-10_14-30-45.tar.gz
Expected output:

collected_logs/
collected_logs/auth.log
collected_logs/syslog
Skills Learned
Linux Log Management

Bash Scripting

Directory Creation

File Copy Operations

Archiving with tar

Compression with gzip

Working with Timestamps

Linux Troubleshooting Fundamentals

Future Improvements
Add error handling

Generate log collection reports

Archive additional log files

Add automated scheduling using cron

Email archived logs automatically

Author
Syed Aftab

Linux Administration & Cloud Engineering Learning Journey
