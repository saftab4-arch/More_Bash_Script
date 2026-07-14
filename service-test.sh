#!/bin/bash
# Simple service monitor
# Checks if listed services are running, restarts them if not

SERVICES=("nginx" "cron")

echo "=== Service Monitor ==="
echo "Date: $(date)"
echo

for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc"; then
        echo "$svc: running"
    else
        echo "$svc: DOWN - restarting..."
        systemctl restart "$svc"
        sleep 2
        if systemctl is-active --quiet "$svc"; then
            echo "$svc: restarted successfully"
        else
            echo "$svc: FAILED to restart"
        fi
    fi
done

echo
echo "=== Done ==="


if docker info > /dev/null 2>&1; then
    echo "docker: running"
else
    echo "docker: DOWN - open Docker Desktop on Windows to restart it"
fi
 
echo
echo "=== Done ==="
