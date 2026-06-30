#!/bin/bash
echo "📊 OPENBOX STATUS - Android A5"
echo "========================================"
echo "Codebase: https://github.com/OrgHide/openbox"
echo ""

echo "🔌 CONNECTIONS:"
for remote in gdrive1 gdrive2 gdrive3 dropbox1 onedrive1; do
    if rclone lsd $remote:/ &>/dev/null; then
        echo "  ✅ $remote: Connected"
    else
        echo "  ❌ $remote: Not connected"
    fi
done

echo ""
echo "🏗️ OPENBOX WAREHOUSE:"
if rclone ls openbox:/ --max-depth 1 &>/dev/null; then
    echo "  ✅ OpenBox: Working"
else
    echo "  ❌ OpenBox: Not working"
fi

echo ""
echo "🌐 SERVICES:"
pgrep -x "openlist" >/dev/null && echo "  ✅ OpenList: Running on port 5244" || echo "  ❌ OpenList: Not running"
pgrep -f "rclone serve" >/dev/null && echo "  ✅ WebDAV: Running on port 8080" || echo "  ❌ WebDAV: Not running"
pgrep -x "sshd" >/dev/null && echo "  ✅ SSH: Running on port 8022" || echo "  ❌ SSH: Not running"

echo ""
echo "📱 DEVICE: Android A5"
echo "📁 STORAGE:"
rclone about openbox: 2>/dev/null | grep -E 'Total|Used' || echo "  Storage info available"
