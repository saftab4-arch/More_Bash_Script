User Management Tool
A Bash-based Linux administration utility that automates common user management tasks through an interactive menu-driven interface.

This project was created to practice Linux administration, Bash scripting, functions, conditionals, logging, and automation.

Project Overview
The User Management Tool allows administrators to:

Create users

Delete users

Check if a user exists

Lock user accounts

Unlock user accounts

Reset passwords

View user information

Log all administrative actions

The tool uses common Linux administration commands and wraps them into a simple interactive menu.

Technologies Used
Bash

Linux User Administration

Functions

Variables

If/Else Statements

Case Statements

While Loops

Logging

Features
Create User
Creates a new Linux user account and home directory.

Command Used:

useradd -m username
Explanation:

useradd creates a user account

-m creates the user's home directory

Example:

useradd -m john
Delete User
Deletes a user account and removes its home directory.

Command Used:

userdel -r username
Explanation:

userdel removes the user account

-r removes the home directory

Example:

userdel -r john
Check User
Checks whether a user exists on the system.

Command Used:

id username
Example:

id john
Output:

uid=1001(john) gid=1001(john) groups=1001(john)
Lock User Account
Temporarily disables a user account.

Command Used:

passwd -l username
Example:

passwd -l john
Unlock User Account
Re-enables a previously locked user account.

Command Used:

passwd -u username
Example:

passwd -u john
Reset Password
Allows an administrator to assign a new password.

Command Used:

passwd username
Example:

passwd john
View User Information
Displays user details.

Command Used:

id username
Example Output:

uid=1001(john)
gid=1001(john)
groups=1001(john)
Action Logging
All administrative actions are recorded in:

user_management.log
Example:

Thu Jun 05 10:15:33 UTC 2026 - User created: john
Thu Jun 05 10:18:21 UTC 2026 - Password reset for: john
Thu Jun 05 10:20:10 UTC 2026 - User locked: john
Script Structure
Variables
LOG_FILE="user_management.log"
Stores all administrative actions.

Functions
The script uses reusable Bash functions:

create_user()
delete_user()
check_user()
lock_user()
unlock_user()
reset_password()
view_user_info()
Conditional Logic
Used to verify whether users exist before performing actions.

if id "$USERNAME" &>/dev/null
then
    echo "User exists."
else
    echo "User does not exist."
fi
Menu System
The script uses:

while true
and

case
to create an interactive administration menu.

Sample Menu
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
Skills Demonstrated
Linux User Administration

Bash Scripting

Functions

Variables

Conditional Logic

Case Statements

Loops

Logging

Error Handling

System Administration

Learning Outcomes
This project helped practice:

Linux account management

Automation of repetitive administrative tasks

Bash scripting best practices

Menu-driven script design

User validation

Action auditing through log files

Future Enhancements
Version 2 Ideas:

List all local users

Group management

Add user to group

Remove user from group

Password expiration checks

Export reports

Email notifications

Account activity reporting

Author
Syed Basit Aftab

Linux • DevOps • AWS Learning Journey





