#!/bin/bash
export TMPDIR=/data/data/com.termux/files/home/.tmp

# Kill existing
pkill -f "rclone serve" 2>/dev/null

# Start with security
rclone serve webdav warehouse:/ \
    --addr 127.0.0.1:8080 \
    --user admin \
    --pass MasterPassword \
    --read-only=false \
    --vfs-cache-mode writes \
    --vfs-cache-max-age 1h \
    --vfs-cache-max-size 1G \
    --dir-cache-time 5m \
    --poll-interval 1m \
    --header "X-Content-Type-Options: nosniff" \
    --header "X-Frame-Options: DENY" \
    > ~/warehouse/logs/webdav.log 2>&1 &

echo "✅ WebDAV running on port 8080"
