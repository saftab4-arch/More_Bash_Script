# 🐧 User Management Tool

A Bash-based Linux administration utility that automates common user management tasks through an interactive, menu-driven interface.

Built as part of my **Linux / DevOps / AWS learning journey** to practice Bash scripting, functions, conditional logic, logging, and the automation of repetitive system administration tasks.


## 📋 Overview

The User Management Tool wraps common Linux user-administration commands into a single, easy-to-use interactive menu. Instead of remembering and typing each command individually, an administrator can drive everything from one script.

Supported actions:

- Create users
- Delete users
- Check if a user exists
- Lock user accounts
- Unlock user accounts
- Reset passwords
- View user information
- Log every administrative action to an audit file

---

## ✅ Prerequisites

Most of the commands used here (`useradd`, `userdel`, `passwd`) modify the system account database and **require root privileges**. Run the script with `sudo` or as the root user:

```bash
sudo ./user_management.sh
```

You'll also need a Linux environment (a VM, a Docker Ubuntu container, Killercoda, or a cloud instance all work).

---

## 🚀 Installation & Usage

```bash
# 1. Clone the repository
git clone https://github.com/saftab4-arch/user-management-tool.git
cd user-management-tool

# 2. Make the script executable
chmod +x user_management.sh

# 3. Run it (root required)
sudo ./user_management.sh
```

Once running, you'll see the interactive menu and can select an option by number.

---

## 🧩 Features & Command Reference

Each feature maps to a standard Linux administration command. The **"why"** is included for each so the behavior is clear, not just the syntax.

### Create User

Creates a new Linux user account along with its home directory.

```bash
useradd -m john
```

| Flag | Meaning |
|------|---------|
| `useradd` | Creates a new user account |
| `-m` | Also creates the user's home directory |

### Delete User

Removes a user account and its home directory.

```bash
userdel -r john
```

| Flag | Meaning |
|------|---------|
| `userdel` | Removes the user account |
| `-r` | Also removes the home directory and mail spool |

### Check User

Verifies whether a user exists on the system.

```bash
id john
```

Output:

```
uid=1001(john) gid=1001(john) groups=1001(john)
```

### Lock User Account

Temporarily disables an account by locking its password.

```bash
passwd -l john
```

### Unlock User Account

Re-enables a previously locked account.

```bash
passwd -u john
```

### Reset Password

Assigns a new password to an existing user.

```bash
passwd john
```

### View User Information

Displays the user's UID, GID, and group memberships.

```bash
id john
```

---

## 📝 Action Logging

Every administrative action is appended to an audit log so changes can be traced after the fact.

**Log file:** `user_management.log`

Example contents:

```
Thu Jun 05 10:15:33 UTC 2026 - User created: john
Thu Jun 05 10:18:21 UTC 2026 - Password reset for: john
Thu Jun 05 10:20:10 UTC 2026 - User locked: john
```

---

## 🏗️ Script Structure

### Variable

```bash
LOG_FILE="user_management.log"
```

Stores the path of the audit log used by every function.

### Functions

The script is organized into reusable functions, one per task:

```
create_user()       delete_user()      check_user()
lock_user()         unlock_user()      reset_password()
view_user_info()
```

### Conditional Logic

Before acting, the script confirms the user exists (or doesn't, for creation):

```bash
if id "$USERNAME" &>/dev/null
then
    echo "User exists."
else
    echo "User does not exist."
fi
```

> `&>/dev/null` discards both stdout and stderr so only the exit status is used for the check — keeping the menu output clean.

### Menu Loop

A `while true` loop combined with a `case` statement creates the interactive menu and keeps it running until the user chooses to exit.

---

## 🖥️ Sample Menu

```
=================================
      USER MANAGEMENT TOOL
=================================

1. Create User
2. Delete User
3. Check User
4. Lock User
5. Unlock User
6. Reset Password
7. View User Information
8. Exit
```

---

## 🎯 Skills Demonstrated

- Linux user administration
- Bash scripting
- Functions and code reuse
- Variables
- Conditional logic (`if` / `else`)
- `case` statements
- Loops (`while`)
- Logging and auditing
- Error handling and input validation
- Menu-driven script design

---

## 📚 Lessons Learned / Gotchas

A few things this project reinforced — documented here as honest learning moments:

- **Root is mandatory.** The first runs failed silently until I realized `useradd`, `userdel`, and `passwd` all need elevated privileges. A future version should check for root at startup (`if [[ $EUID -ne 0 ]]`) and exit early with a clear message.
- **Validate before you act.** Wrapping every action in an `id "$USERNAME"` check prevents confusing errors like trying to delete a user that doesn't exist.
- **Logging is cheap insurance.** Appending a timestamped line for every action turns the script into an auditable tool rather than a black box.
- **`&>/dev/null` matters.** Suppressing command output during existence checks keeps the menu readable instead of dumping raw command output between prompts.

---

## 🔮 Future Enhancements (v2 Ideas)

- Root-privilege check at startup
- List all local users
- Group management (create / delete groups)
- Add user to / remove user from a group
- Password expiration checks
- Export reports (CSV / text)
- Email notifications on account changes
- Account activity reporting

---

## 📜 Full Script

```bash
#!/bin/bash

LOG_FILE="user_management.log"

create_user() {

    read -p "Enter username: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        echo "User already exists."
    else
        useradd -m "$USERNAME"

        echo "$(date) - User created: $USERNAME" >> "$LOG_FILE"

        echo "User $USERNAME created successfully."
    fi

}

delete_user() {

    read -p "Enter username to delete: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        userdel -r "$USERNAME"

        echo "$(date) - User deleted: $USERNAME" >> "$LOG_FILE"

        echo "User $USERNAME deleted successfully."
    else
        echo "User does not exist."
    fi

}

check_user() {

    read -p "Enter username to check: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        echo "User exists."
    else
        echo "User does not exist."
    fi

}

lock_user() {

    read -p "Enter username to lock: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        passwd -l "$USERNAME"

        echo "$(date) - User locked: $USERNAME" >> "$LOG_FILE"

        echo "User $USERNAME has been locked."
    else
        echo "User does not exist."
    fi

}

unlock_user() {

    read -p "Enter username to unlock: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        passwd -u "$USERNAME"

        echo "$(date) - User unlocked: $USERNAME" >> "$LOG_FILE"

        echo "User $USERNAME has been unlocked."
    else
        echo "User does not exist."
    fi

}

reset_password() {

    read -p "Enter username: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        passwd "$USERNAME"

        echo "$(date) - Password reset for: $USERNAME" >> "$LOG_FILE"

        echo "Password updated successfully."
    else
        echo "User does not exist."
    fi

}

view_user_info() {

    read -p "Enter username: " USERNAME

    if id "$USERNAME" &>/dev/null
    then
        echo "User Information:"
        id "$USERNAME"

        echo "$(date) - Viewed user info: $USERNAME" >> "$LOG_FILE"
    else
        echo "User does not exist."
    fi

}

while true
do

    echo
    echo "================================="
    echo "      USER MANAGEMENT TOOL"
    echo "================================="
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. Check User"
    echo "4. Lock User"
    echo "5. Unlock User"
    echo "6. Reset Password"
    echo "7. View User Information"
    echo "8. Exit"
    echo

    read -p "Enter your choice: " CHOICE

    case $CHOICE in

        1) create_user ;;
        2) delete_user ;;
        3) check_user ;;
        4) lock_user ;;
        5) unlock_user ;;
        6) reset_password ;;
        7) view_user_info ;;

        8)
            echo "Exiting User Management Tool..."
            break
            ;;

        *)
            echo "Invalid option. Please try again."
            ;;

    esac

done
```

---

## 👤 Author

**Syed Basit Aftab**

Linux • DevOps • AWS Learning Journey

- GitHub: [@saftab4-arch](https://github.com/saftab4-arch)
- LinkedIn: [syed-b-9078141a8](https://www.linkedin.com/in/syed-b-9078141a8/)
