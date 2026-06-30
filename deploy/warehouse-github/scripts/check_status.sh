#!/bin/bash
echo "📊 WAREHOUSE STATUS CHECK"
echo "========================================"

echo "🔌 CONNECTIONS:"
for remote in gdrive1 gdrive2 gdrive3 dropbox1 onedrive1; do
    if rclone lsd $remote:/ &>/dev/null; then
        echo "  ✅ $remote: Connected"
    else
        echo "  ❌ $remote: Not connected"
    fi
done

echo ""
echo "🏗️ WAREHOUSE:"
if rclone ls warehouse:/ --max-depth 1 &>/dev/null; then
    echo "  ✅ Warehouse: Working"
else
    echo "  ❌ Warehouse: Not working"
fi

echo ""
echo "🌐 SERVICES:"
pgrep -x "openlist" >/dev/null && echo "  ✅ OpenList: Running on port 5244" || echo "  ❌ OpenList: Not running"
pgrep -f "rclone serve" >/dev/null && echo "  ✅ WebDAV: Running on port 8080" || echo "  ❌ WebDAV: Not running"
pgrep -x "sshd" >/dev/null && echo "  ✅ SSH: Running on port 8022" || echo "  ❌ SSH: Not running"

echo ""
echo "📁 STORAGE:"
echo "  $(rclone about warehouse: 2>/dev/null | grep -E 'Total|Used' || echo '  Storage info available')"
