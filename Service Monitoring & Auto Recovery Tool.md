Service Monitoring & Auto Recovery Tool
Project Overview
This project is a Linux Bash script that allows administrators to monitor and manage system services. The script checks whether a service exists, displays its current status, allows administrators to start, stop, or restart services, and can automatically recover services if they are down.

All actions are logged with timestamps for auditing and troubleshooting purposes.

Features
Check if a service exists

View current service status

Start a service

Stop a service

Restart a service

Auto-recover a failed service

Log all actions with timestamps

Generate a service monitoring log file

Technologies Used
Linux

Bash Scripting

systemctl

grep

case statements

if statements

Logging

Full Script
#!/bin/bash

LOG_FILE="service_monitor.log"

read -p "Enter service name: " SERVICE

# Check if service exists
if ! systemctl list-unit-files | grep -q "^$SERVICE.service"
then
    echo "Service not found."
    exit 1
fi

echo
echo "Current Status:"
systemctl status "$SERVICE" --no-pager
echo

echo "=============================="
echo "1. Start Service"
echo "2. Stop Service"
echo "3. Restart Service"
echo "4. Auto Recover Service"
echo "5. Exit"
echo "=============================="

read -p "Choose an option: " CHOICE

case $CHOICE in

1)

    systemctl start "$SERVICE"

    echo "$(date) - $SERVICE started" >> "$LOG_FILE"

    echo "Service started successfully."

    ;;

2)

    systemctl stop "$SERVICE"

    echo "$(date) - $SERVICE stopped" >> "$LOG_FILE"

    echo "Service stopped successfully."

    ;;

3)

    systemctl restart "$SERVICE"

    echo "$(date) - $SERVICE restarted" >> "$LOG_FILE"

    echo "Service restarted successfully."

    ;;

4)

    if systemctl is-active --quiet "$SERVICE"
    then

        echo "Service is already running."

        echo "$(date) - $SERVICE already running" >> "$LOG_FILE"

    else

        echo "Service is down."
        echo "Attempting auto recovery..."

        systemctl restart "$SERVICE"

        if systemctl is-active --quiet "$SERVICE"
        then

            echo "Recovery successful."

            echo "$(date) - $SERVICE auto recovered successfully" >> "$LOG_FILE"

        else

            echo "Recovery failed."

            echo "$(date) - $SERVICE auto recovery failed" >> "$LOG_FILE"

        fi

    fi

    ;;

5)

    echo "Exiting Service Monitor Tool..."

    exit 0

    ;;

*)

    echo "Invalid option selected."

    ;;

esac

echo
echo "Report saved to: $LOG_FILE"
Command Breakdown
Shebang
#!/bin/bash
Tells Linux to execute the script using the Bash shell.

Log File Variable
LOG_FILE="service_monitor.log"
Stores the log file name in a variable so it can be reused throughout the script.

User Input
read -p "Enter service name: " SERVICE
Prompts the user to enter a service name and stores it in the variable SERVICE.

Example:

ssh
nginx
cron
Verify Service Exists
if ! systemctl list-unit-files | grep -q "^$SERVICE.service"
systemctl list-unit-files
Displays all installed services.

Example:

ssh.service
cron.service
nginx.service
grep -q
Quiet mode.

Does not print output.

Only checks if a match exists.

^
Matches the beginning of a line.

!
Logical NOT operator.

Translation:

If the service does NOT exist, display an error and exit.

Display Service Status
systemctl status "$SERVICE" --no-pager
Shows the current status of the selected service.

Example:

Active: active (running)
Why use --no-pager?
Normally:

systemctl status ssh
opens a pager and waits for the user to press:

q
Using:

--no-pager
prints the output and immediately continues the script.

Menu System
case $CHOICE in
The case statement acts like a menu controller.

Example:

1 -> Start Service
2 -> Stop Service
3 -> Restart Service
4 -> Auto Recover
5 -> Exit
What Does ;; Mean?
Example:

1)
    echo "Starting Service"
    ;;
The ;; tells Bash:

End this menu option and stop processing.

It is not the same as break.

Start Service
systemctl start "$SERVICE"
Starts the selected service.

Example:

systemctl start nginx
Stop Service
systemctl stop "$SERVICE"
Stops the selected service.

Restart Service
systemctl restart "$SERVICE"
Restarts the selected service.

Auto Recovery
systemctl is-active --quiet "$SERVICE"
Checks if the service is currently running.

If stopped:

systemctl restart "$SERVICE"
attempts automatic recovery.

The script then verifies whether recovery was successful.

Logging
echo "$(date) - $SERVICE restarted" >> "$LOG_FILE"
Appends a timestamped entry to the log file.

Example:

Thu Jun 05 15:20:01 UTC 2026 - nginx restarted
>> Operator
Appends data to an existing file.

Without overwriting previous entries.

Exit Script
exit 0
Terminates the script successfully.

Exit code:

0 = Success
Sample Log Output
Thu Jun 05 15:00:01 UTC 2026 - nginx started
Thu Jun 05 15:05:01 UTC 2026 - nginx restarted
Thu Jun 05 15:10:01 UTC 2026 - nginx auto recovered successfully
Skills Demonstrated
Linux Administration

Bash Scripting

Service Management

Process Monitoring

Auto Recovery

Logging

User Input Handling

Conditional Statements

Case Statements

Troubleshooting

System Automation

Future Improvements
Monitor multiple services

Continuous monitoring loop

Cron job integration

Email notifications

Service health reports

Automatic log rotation

Dashboard integration
