

Skip to content
Using Western Governors University Mail with screen readers

2 of 6,302
(no subject)
External
Inbox

Syed Aftab via wgu.edu 
Attachments
9:56 PM (15 minutes ago)
to me



--
Syed Basit Aftab
Computer Technology Specialist
South River Public Schools
📍 South River, NJ
📧 saftab@srivernj.org
🌐 https://url.us.m.mimecastprotect.com/s/ou4yCL91x8cVDy22RcBfkUy3jlR?domain=srivernj.org



This e-mail is a private communication, intended only for the use of the named recipient(s), and may contain information or attachments that are confidential or privileged. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or use of the contents of this message is strictly prohibited. If you have received this message in error, or are not the named recipient, please notify us immediately by contacting the sender at the e- mail address noted above and delete and destroy all copies of this message. 
 2 Attachments
  •  Scanned by Gmail
# 🐚 Bash Scripting Journey
> From zero to real scripts — 20 hands-on Bash scripts with explanations, outputs, and lessons learned.

---

## 📋 Table of Contents

| # | Script | What it teaches |
|---|--------|----------------|
| 01 | [greet.sh](#01-greetsh) | Arguments, -z check, if/fi |
| 02 | [filepath.sh](#02-filepathsh) | File existence check, if/else |
| 03 | [install_package.sh](#03-install_packagesh) | For loop, dpkg check, apt-get |
| 04 | [local_demo.sh](#04-local_demosh) | Local vs global variables |
| 05 | [system_info.sh](#05-system_infosh) | Functions, set -euo pipefail, main() |
| 06 | [greet_add.sh](#06-greet_addsh) | Functions with arguments, math |
| 07 | [for-loop-counter.sh](#07-for-loop-countersh) | C-style for loop, mkdir, argument validation |
| 08 | [while-loop.sh](#08-while-loopsh) | While loop, even numbers |
| 09 | [functions.sh](#09-functionssh) | Basic functions, tea example |
| 10 | [func-w-args.sh](#10-func-w-argssh) | Functions with hardcoded arguments |
| 11 | [user-entry.sh](#11-user-entrysh) | Functions with user input, greet + install |
| 12 | [function-reuse.sh](#12-function-reusesh) | source — reusing functions from another script |
| 13 | [create-user.sh](#13-create-usersh) | if inside function, adduser, id check |
| 14 | [service.sh](#14-servicesh) | systemctl check, if/else |
| 15 | [system-detail.sh](#15-system-detailsh) | awk, free, df, ps — system info with parsing |
| 16 | [error-handle.sh](#16-error-handlesh) | set -euo pipefail, error handling |
| 17 | [system_info_full.sh](#17-system_info_fullsh) | Full system report with print_header |
| 18 | [backup.sh](#18-backupsh) | tar backup, timestamps, functions |
| 19 | [time-logger.sh](#19-time-loggersh) | Cron job, appending to log file |
| 20 | [cron setup](#20-cron-setup) | crontab -e, scheduling scripts |

---

## 01 greet.sh

**What it teaches:** Script arguments (`$1`), `-z` empty check, `if/then/fi`

```bash
#!/bin/bash

if [ -z "$1" ]
then
    echo "Usage: ./greet.sh <name>"
    exit 1
fi

echo "Hello, $1!"
```

**Output — with name:**
```
$ ./greet.sh Sarah
Hello, Sarah!
```

**Output — without name:**
```
$ ./greet.sh
Usage: ./greet.sh <name>
```

**Key concepts:**
- `$1` → first argument typed after the script name — you don't define it, Bash sets it automatically
- `-z` → checks if string is empty (zero length)
- `exit 1` → stops script immediately with error code

---

## 02 filepath.sh

**What it teaches:** Reading user input, checking if a file exists

```bash
#!/bin/bash

read -p "Enter the file path please: " filepath

if [ -f "$filepath" ]
then
    echo "File exists"
else
    echo "File does not exist"
fi
```

**Output:**
```
$ ./filepath.sh
Enter the file path please: /etc/hosts
File exists

$ ./filepath.sh
Enter the file path please: /fake/path
File does not exist
```

**Key concepts:**
- `read -p` → prompts user and stores their input in a variable
- `-f` → checks if a file exists and is a regular file
- `if/else/fi` → two-path decision

---

## 03 install_package.sh

**What it teaches:** For loop, checking installed packages, installing with apt-get

```bash
#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run this command with root access"
    exit
fi

PACKAGES="nginx curl wget"

for package in $PACKAGES
do
    if dpkg -s "$package" &> /dev/null
    then
        echo "Package already installed"
    else
        echo "Installing $package..."
        apt-get install -y "$package"
        echo "$package installation completed"
    fi
done
```

**Output:**
```
Installing nginx...
... (apt output) ...
nginx installation completed
Package already installed
Package already installed
```

**Key concepts:**
- `$EUID` → your user ID — 0 means root
- `PACKAGES="nginx curl wget"` → you define what to install here
- `for package in $PACKAGES` → loops one package at a time, `$package` = current item
- `dpkg -s` → checks if already installed
- `&> /dev/null` → silences output, only checks pass/fail
- `-y` on apt-get → auto-confirms all prompts

---

## 04 local_demo.sh

**What it teaches:** Local vs global variables

```bash
#!/bin/bash

global_var="I am global"

test_local() {
    local local_var="I am local"
    echo "$local_var"
}

test_global() {
    normal_var="I am normal"
}

test_local
echo "$local_var"
test_global
echo "$normal_var"
echo "$global_var"
```

**Output:**
```
I am local
                    ← blank, local_var is destroyed after function ends
I am normal
I am global
```

**Key concepts:**

| Variable | Keyword | Visible outside function? |
|----------|---------|--------------------------|
| `local_var` | `local` | NO — dies when function ends |
| `normal_var` | none | YES — leaks out globally |
| `global_var` | none, outside function | YES — always visible |

- `local` keyword keeps a variable trapped inside its function
- Without `local`, a variable created inside a function becomes global

---

## 05 system_info.sh

**What it teaches:** Reusable functions, `set -euo pipefail`, `main()` pattern

```bash
#!/bin/bash
set -euo pipefail

print_header() {
    echo
    echo "=============================="
    echo "$1"
    echo "=============================="
}

system_info() {
    print_header "SYSTEM INFORMATION"
    hostname
    uname -a
}

uptime_info() {
    print_header "SYSTEM UPTIME"
    uptime
}

disk_usage() {
    print_header "TOP DISK USAGE"
    du -ah / 2>/dev/null | sort -rh 2>/dev/null | head -5 || true
}

memory_usage() {
    print_header "MEMORY USAGE"
    free -h
}

cpu_processes() {
    print_header "TOP CPU PROCESSES"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}

main() {
    system_info
    uptime_info
    disk_usage
    memory_usage
    cpu_processes
}

main
```

**Output:**
```
==============================
SYSTEM INFORMATION
==============================
ubuntu
Linux ubuntu 6.8.0-117-generic ...

==============================
SYSTEM UPTIME
==============================
20:58:29 up 34 min, 0 users, load average: 0.00

==============================
TOP DISK USAGE
==============================
5.5G    /
2.9G    /usr
...
```

**Key concepts:**
- `set -euo pipefail` → safety flags: stop on error (`-e`), stop on undefined variable (`-u`), stop on pipe failure (`-o pipefail`)
- `print_header` → reusable function — write once, call from every section
- `$1` inside `print_header` → the title passed in, e.g. `"SYSTEM INFORMATION"`
- `main()` pattern → define all functions first, call `main` at the very last line
- `|| true` → prevents broken pipe from killing the script

---

## 06 greet_add.sh

**What it teaches:** Multiple functions, passing arguments, math with `$(( ))`

```bash
#!/bin/bash

greet() {
    echo "Hello, $1!"
}

add() {
    sum=$(($1 + $2))
    echo "Sum: $sum"
}

greet "Syed"
add 10 12
```

**Output:**
```
Hello, Syed!
Sum: 22
```

**Key concepts:**
- Functions use `()` only when **defining** — never when calling
- `$1`, `$2` inside a function = arguments passed to **that function specifically**
- `$(( ))` → math operator in Bash
- Arguments separated by **spaces**, never commas — `add 10 12` not `add 10,12`

---

## 07 for-loop-counter.sh

**What it teaches:** C-style for loop, argument validation, mkdir with check

```bash
#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <prefix> <start> <end>"
    echo "Example: $0 folder 1 5"
    exit 1
fi

prefix=$1
start=$2
end=$3

for(( num=start; num<=end; num++)); do
    if [[ -d "${prefix}${num}" ]]; then
        echo "⚠️ Folder already exists: ${prefix}${num}"
    else
        mkdir "${prefix}${num}"
        echo "Folder created: ${prefix}${num}"
    fi
done
```

**Output:**
```
$ ./for-loop-counter.sh folder 1 9
Folder created: folder1
Folder created: folder2
⚠️ Folder already exists: folder3
⚠️ Folder already exists: folder4
Folder created: folder6
...
```

**Key concepts:**
- `$#` → total number of arguments passed
- `-ne 3` → not equal to 3
- `$0` → the script name itself
- C-style for loop: `for(( num=start; num<=end; num++ ))`
- `-d` → checks if a directory exists
- `${prefix}${num}` → combines two variables with no space between them

---

## 08 while-loop.sh

**What it teaches:** While loop, even number generation

```bash
#!/bin/bash

num=0

while [[ $num -le 10 ]]; do
    num=$(( num+2 ))
    echo "Even number : $num"
done
```

**Output:**
```
Even number : 2
Even number : 4
Even number : 6
Even number : 8
Even number : 10
Even number : 12
```

**Key concepts:**
- `while [[ condition ]]; do ... done` → keeps looping as long as condition is true
- `-le` → less than or equal to
- `num=$(( num+2 ))` → adds 2 each round
- Space required: `while [[ ` not `while[[`
- `do` and `done` are required — they open and close the loop body

---

## 09 functions.sh

**What it teaches:** Basic function definition and calling

```bash
#!/bin/bash

tea() {
    echo " put some warm water"
    echo " put some milk"
    echo " put some tea leaf"
    echo " drink it"
}

echo " tea making process"
tea
echo " finished"
```

**Output:**
```
tea making process
put some warm water
put some milk
put some tea leaf
drink it
finished
```

**Key concepts:**
- Define a function with `name() { ... }`
- Call it by just writing `tea` — no `()` needed when calling
- The `echo` lines before and after show code runs top to bottom, jumping into the function when called

---

## 10 func-w-args.sh

**What it teaches:** Functions with hardcoded arguments passed at call time

```bash
#!/bin/bash

greeting() {
    echo " Hello sir $1"
}

install_package() {
    echo "Installing package requested by user"
    sudo apt install -y "$install_package"
}

greeting " Basit "
greeting " syed"
install_package "nginx"
```

**Output:**
```
Hello sir  Basit
Hello sir  syed
Installing package requested by user
```

**Key concepts:**
- Same function called multiple times with different arguments
- `$1` inside the function gets the value passed at call time
- Each call to `greeting` gets its own fresh `$1`

---

## 11 user-entry.sh

**What it teaches:** Functions with user input, greet and install combined

```bash
#!/bin/bash

# Function to greet user
greet() {
    echo "Namaste $1 ji!"
}

# Function to install package
install_package() {
    echo "Installing: $1"
    sudo apt-get install -y "$1"
}

# --- User input section ---
read -p "Enter your name: " username
read -p "Enter package name to install: " package

# --- Function calls ---
greet "$username"
install_package "$package"
```

**Output:**
```
Enter your name: Syed
Enter package name to install: curl
Namaste Syed ji!
Installing: curl
```

**Key concepts:**
- `read -p` collects user input into a variable
- That variable is then passed as `$1` to the function
- Functions defined first, user input collected after, functions called last — clean structure

---

## 12 function-reuse.sh

**What it teaches:** `source` — loading and reusing functions from another script

```bash
#!/bin/bash

source ./user-entry.sh

echo "------"
echo "Lets call the our func from previous script"

read -p " What is your name? " new-name
read -p "What package you want to install? " pack

greet "$new-name"
install_package "$pack"
```

**Output:**
```
------
Lets call our func from previous script
What is your name? Basit
What package you want to install? wget
Namaste Basit ji!
Installing: wget
```

**Key concepts:**
- `source ./script.sh` → loads all functions and variables from another script into current one
- You can then call `greet` and `install_package` as if they were defined here
- This is how you **reuse code** across multiple scripts without copy-pasting

---

## 13 create-user.sh

**What it teaches:** if inside a function, checking if user exists, adduser

```bash
#!/bin/bash

create_user() {
    read -p "Enter your baby's name " name

    if id "$name" &>/dev/null; then
        echo "This baby '$name' already exist, choose different name"
        exit 1
    fi

    sudo adduser "$name" && echo "baby name given $name" || echo "Baby name not given"
}

create_user
```

**Output — user exists:**
```
Enter your baby's name arfah
This baby 'arfah' already exist, choose different name
```

**Output — new user:**
```
Enter your baby's name newuser
... (adduser prompts) ...
baby name given newuser
```

**Key concepts:**
- `id "$name"` → checks if a Linux user with that name already exists
- `&>/dev/null` → silences both normal and error output
- `&&` → run next command only if previous succeeded
- `||` → run next command only if previous failed
- `adduser` → creates a real Linux system user

---

## 14 service.sh

**What it teaches:** Checking if a service is running with systemctl

```bash
#!/bin/bash

read -p "Enter service name: " service

if systemctl is-active --quiet "$service"; then
    echo "Service '$service' is running"
else
    echo "Service '$service' is NOT running"
fi
```

**Output:**
```
$ ./service.sh
Enter service name: ssh
Service 'ssh' is running

$ ./service.sh
Enter service name: nginx
Service 'nginx' is NOT running
```

**Key concepts:**
- `systemctl is-active --quiet` → checks if service is running, no output
- Returns exit code 0 (success) if running, non-zero if not
- `if` reads that exit code automatically — no `[ ]` needed here
- `--quiet` → suppresses systemctl's own output

---

## 15 system-detail.sh

**What it teaches:** awk for parsing command output, system info functions

```bash
#!/bin/bash

check_memory() {
    free -h | awk 'NR==2 {print "Available memory: " $7}'
}

check_storage() {
    df -h / | awk 'NR==2 {print "Available disk: " $4}'
}

top_process() {
    ps aux --sort=-%mem | awk 'NR==2 {print "Top memory process: user="$1" pid="$2" mem%="$4}'
}

echo "=== System Details ==="
check_memory
check_storage
top_process
```

**Output:**
```
=== System Details ===
Available memory: 1.4Gi
Available disk: 13G
Top memory process: user=root pid=1208 mem%=5.2
```

**Key concepts:**
- `awk 'NR==2 {print ...}'` → NR means row number, so NR==2 = second row of output
- `$4`, `$7` → column numbers in that row
- `free -h` → RAM info, `df -h /` → disk info, `ps aux` → process list
- Piping (`|`) into awk is how you extract specific data from command output

---

## 16 error-handle.sh

**What it teaches:** `set -euo pipefail` with a real function example

```bash
#!/bin/bash
# Strict mode — production-grade bash error handling:
#   -e           : script exits the moment any command fails
#   -u           : exits if you use an undefined variable (catches typos)
#   -o pipefail  : a pipeline fails if ANY command in it fails (not just the last)
set -euo pipefail

create_directory() {
    mkdir "$1"
    echo "$1 bana diya"
}

create_directory test_folder
echo "Aage badhte hain - sab theek hai"
```

**Output:**
```
test_folder bana diya
Aage badhte hain - sab theek hai
```

**Key concepts:**

| Flag | Meaning |
|------|---------|
| `-e` | Stop immediately if any command fails |
| `-u` | Error if undefined variable is used |
| `-o pipefail` | Fail if any part of a pipe fails |

- Without these flags, Bash silently ignores errors and keeps running
- This is considered best practice for production scripts

---

## 17 system_info_full.sh

**What it teaches:** Combining everything — functions calling functions, full system report

*(Same as Script 05 — the polished final version with all sections)*

**Output:**
```
==============================
SYSTEM INFORMATION
==============================
ubuntu
Linux ubuntu 6.8.0 ...

==============================
SYSTEM UPTIME
==============================
up 34 min, 0 users ...

==============================
TOP DISK USAGE
==============================
5.5G  /
2.9G  /usr
...
```

**Key concepts:**
- `print_header` called from inside every other function
- `$1` inside `print_header` = the title string passed in
- `main()` at the bottom calls everything in order
- One `main` line at the very end triggers the whole script

---

## 18 backup.sh

**What it teaches:** tar backups, timestamps, dirname/basename, functions

```bash
#!/bin/bash

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/shell-backups}"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$BACKUP_DIR/practice-scripts_${TIMESTAMP}.tar.gz"

prepare_backup_dir() {
    if [[ ! -d $BACKUP_DIR ]]
    then
        mkdir -p "$BACKUP_DIR"
        echo "Backup folder created: $BACKUP_DIR"
    fi
}

take_backup() {
    tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
    echo "Backup created: $ARCHIVE"
}

prepare_backup_dir
take_backup
```

**Output:**
```
Backup created: /root/shell-backups/practice-scripts_2026-05-28_01-07-29.tar.gz
```

**Key concepts:**
- `$(dirname "$0")` → folder where the script lives
- `$(date +%Y-%m-%d_%H-%M-%S)` → current timestamp formatted for filenames
- `${BACKUP_DIR:-$HOME/shell-backups}` → use BACKUP_DIR if set, otherwise default to `$HOME/shell-backups`
- `tar -czf` → create compressed `.tar.gz` archive
- `mkdir -p` → creates folder and any missing parent folders
- `[[ ! -d ]]` → true if directory does NOT exist

---

## 19 time-logger.sh

**What it teaches:** Appending to a file with `>>`, command substitution with `$(date)`

```bash
#!/bin/bash

echo "Cron ran at: $(date)" >> "/root/practice-scripts/time-log.txt"
```

**Output (inside time-log.txt after running twice):**
```
Cron ran at: Thu May 28 01:40:01 UTC 2026
Cron ran at: Thu May 28 01:41:01 UTC 2026
```

**Key concepts:**
- `>>` → appends to file (does not overwrite — adds a new line each time)
- `>` → would overwrite the file completely
- `$(date)` → runs the `date` command and drops the output inline
- This script is designed to be run automatically by cron

---

## 20 Cron Setup

**What it teaches:** Scheduling scripts to run automatically with crontab

**Setup commands used:**
```bash
crontab -e                                        # open cron editor
chmod +x /root/practice-scripts/time-logger.sh   # make script executable
```

**Crontab entry added:**
```
* * * * * /root/practice-scripts/time-logger.sh
```

**Output (time-log.txt grows automatically every minute):**
```
Cron ran at: Thu May 28 01:40:01 UTC 2026
Cron ran at: Thu May 28 01:41:01 UTC 2026
```

**Cron time format:**
```
* * * * *  command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, 0=Sunday)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)

* = every
```

**Key concepts:**
- `crontab -e` → opens your personal cron schedule for editing
- `* * * * *` → runs every single minute
- The script must be executable (`chmod +x`) for cron to run it
- Use full absolute paths in cron — it does not know your current directory

---

## 🧠 Concepts Learned

| Concept | First seen in |
|---------|--------------|
| `$1`, `$2` arguments | Script 01 |
| `-z` empty check | Script 01 |
| `read -p` user input | Script 02 |
| `-f` file check | Script 02 |
| For loop over list | Script 03 |
| `dpkg -s` package check | Script 03 |
| `local` keyword | Script 04 |
| `set -euo pipefail` | Script 05 |
| Reusable functions | Script 05 |
| `main()` pattern | Script 05 |
| `$(( ))` math | Script 06 |
| C-style for loop | Script 07 |
| `$#` argument count | Script 07 |
| While loop | Script 08 |
| `source` another script | Script 12 |
| `id` user check | Script 13 |
| `&&` and `\|\|` chaining | Script 13 |
| `systemctl is-active` | Script 14 |
| `awk` output parsing | Script 15 |
| `tar` backup | Script 18 |
| `>>` append to file | Script 19 |
| `crontab -e` scheduling | Script 20 |

---

## 🚀 How to Run Any Script

```bash
# 1. Make it executable
chmod +x script-name.sh

# 2. Run it
./script-name.sh

# 3. Run with arguments (if needed)
./script-name.sh arg1 arg2

# 4. Run as root (if needed)
sudo ./script-name.sh
```

---

*Built on Ubuntu 24 — Bash scripting from scratch 🔥*
README.md
Displaying 1 to 19 shubham Scripts Practice.zip.
