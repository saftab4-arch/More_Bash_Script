#!/bin/bash
# Simple disk cleanup script
# Clears common junk: apt cache, old logs, temp files, docker leftovers

echo "=== Disk Cleanup ==="
echo "Date: $(date)"
echo

echo "--- Before ---"
df -h /
echo

echo "Cleaning apt cache..."
sudo apt clean

echo "Removing unused packages..."
sudo apt autoremove -y

echo "Clearing old journal logs (keep last 7 days)..."
sudo journalctl --vacuum-time=7d

echo "Clearing /tmp files older than 7 days..."
sudo find /tmp -type f -atime +7 -delete 2>/dev/null

echo "Cleaning up unused Docker data (stopped containers, dangling images)..."
docker system prune -f

echo
echo "--- After ---"
df -h /

echo
echo "=== Done ==="
