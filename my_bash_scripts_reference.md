# My Bash Scripts Reference
> All important scripts in one place

---

## 1. Backup Script (`backup.sh`)
**Location:** `/home/Scripts/backup.sh`

```bash
#!/bin/bash

SOURCE="/home/Scripts"
DESTINATION="/home/backup"
ARCHIVE="$DESTINATION/backups-$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
LOGFILE="/home/backup/backup.log"

echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup started" >> $LOGFILE

tar -cvzf $ARCHIVE $SOURCE

find $DESTINATION -name "*.tar.gz" -mtime +7 -delete

echo "[$(date +%Y-%m-%d_%H-%M-%S)] Backup completed" >> $LOGFILE
echo "--------------------------------------" >> $LOGFILE
```

**What it does:**
- Compresses `/home/Scripts` into a timestamped `.tar.gz` file saved in `/home/backup/`
- Logs start and completion time to `backup.log`
- Auto-deletes backups older than 7 days

---

## 2. Cron Job Setup
**Command to edit crontab:** `crontab -e`

```bash
# Run backup every day at 2am
0 2 * * * /home/Scripts/backup.sh
```

**Cron time format:**
```
* * * * * command
| | | | |
| | | | └── Day of week (0-7)
| | | └──── Month (1-12)
| | └────── Day of month (1-31)
| └──────── Hour (0-23)
└────────── Minute (0-59)
```

---

## 3. Uncompress / Extract a tar.gz File
**Command:**
```bash
tar -xvf backups-2026-05-28_23-59-16.tar.gz
```

**Flags explained:**
- `-x` = extract
- `-v` = verbose (show files being extracted)
- `-f` = specify the filename

**Output example after extraction:**
```
home/Scripts/
home/Scripts/backup.sh
home/Scripts/test1.sh
home/Scripts/test1.txt
home/Scripts/test2.txt
home/Scripts/test2.sh
```

---

## 4. Check Backup Log
**To see when each cron backup ran:**
```bash
cat /home/backup/backup.log
```
The log records a timestamped entry every time the backup script starts and completes.

---

## 5. Service Status Checker (`check-file.sh`)
**Location:** `/home/Scripts/check-file.sh`

```bash
#!/bin/bash

read -p "Enter service name: " SERVICE

read -p "Do you want to check the service status? (y/n): " answer

if [ "$answer" = "y" ]; then
    systemctl status "$SERVICE"

    if systemctl is-active --quiet "$SERVICE"; then
        echo "$SERVICE is active"
    else
        echo "$SERVICE is not active"
    fi
else
    echo "Skipped"
fi
```

**What it does:**
- Prompts user to enter a service name (e.g. `apache2`, `nginx`)
- Asks whether to check its status
- Uses `systemctl` to check and report if the service is active or not

---

## 6. While Loop Script (`while-loop.sh`)
**Location:** `/home/scripts/while-loop.sh`

```bash
#!/bin/bash

read -p "Enter the number " number

while [ $number -le 12 ];

do

echo " $number"

number=$((number + 1))

done
```

**What it does:**
- Prompts the user to enter a starting number
- Counts up from that number to 12, printing each value
- Example: entering `5` prints 5, 6, 7, 8, 9, 10, 11, 12

---

## 7. Functions with Arguments (`test.sh`)
**Location:** `~/test.sh`

```bash
#!/bin/bash

greeting() {
    echo " Hello sir $1"
}

install_package() {
    echo "Installing package requested by user"
    sudo apt install -y "$1"
}

greeting " Basit "
greeting " syed"
install_package "apache2"
```

**What it does:**
- Defines two reusable functions: `greeting` and `install_package`
- `greeting` takes a name as an argument (`$1`) and prints a greeting
- `install_package` takes a package name and installs it via `apt`
- Functions are called at the bottom with arguments passed in

---

## Quick Reference — Useful Commands

| Task | Command |
|---|---|
| Run backup manually | `./backup.sh` |
| Edit cron jobs | `crontab -e` |
| Extract tar.gz | `tar -xvf filename.tar.gz` |
| Create tar.gz | `tar -cvzf archive.tar.gz /path/` |
| Check backup log | `cat /home/backup/backup.log` |
| List backups | `ls /home/backup/` |
| Check service status | `systemctl status <service>` |
