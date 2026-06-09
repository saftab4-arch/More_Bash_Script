#!/bin/bash

# =====================================
# EC2 Health Monitoring & Reporting Tool
# Author: Syed
# =====================================

LOG_FILE="health-report.log"

system_checker() {

echo "========================================"
echo "EC2 HEALTH REPORT"
echo "========================================"

echo "Report Generated: $(date '+%Y-%m-%d %H:%M:%S')"

echo
echo "Hostname:"
hostname

echo
echo "Uptime:"
uptime -p


echo
echo "Memory Usage:"
free -h


echo
echo "Disk Usage:"
df -h


echo
echo "Top Processes:"
ps aux --sort=-%mem | head
echo
}

system_checker | tee -a "$LOG_FILE"
