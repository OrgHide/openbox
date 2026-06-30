#!/bin/bash
export TMPDIR=/data/data/com.termux/files/home/openbox/tmp
mkdir -p $TMPDIR

echo "📦 Starting OpenBox on Android A5..."

# Link configs
ln -sf ~/openbox/configs/rclone ~/.config/rclone
ln -sf ~/openbox/configs/alist ~/.config/alist

# Start WebDAV
pkill -f "rclone serve" 2>/dev/null
rclone serve webdav openbox:/ \
    --addr 0.0.0.0:8080 \
    --user admin \
    --pass MasterPassword \
    --read-only=false \
    --vfs-cache-mode writes \
    > ~/openbox/logs/webdav.log 2>&1 &

# Start Alist
pkill openlist 2>/dev/null
openlist server > ~/openbox/logs/openlist.log 2>&1 &

echo "✅ OpenBox started!"
echo "   WebUI: http://localhost:5244"
echo "   WebDAV: http://localhost:8080"
