#!/bin/bash

echo "=== System Health Check ==="
echo "Host: $(hostname)"
echo "Date: $(date)"
echo

# CPU load
echo "--- CPU Load ---"
uptime

# Memory
echo
echo "--- Memory ---"
free -h

# Disk
echo
echo "--- Disk ---"
df -h /

# Network
echo
echo "--- Network ---"
if ping -c 2 8.8.8.8 > /dev/null 2>&1; then
    echo "Internet: OK"
else
    echo "Internet: FAILED"
fi

echo
echo "=== Done ==="
