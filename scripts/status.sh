#!/bin/bash
echo "📊 OpenBox Status"
echo "========================================"

echo "🌐 WebUI: $(pgrep -x 'openlist' > /dev/null && echo '✅ Running' || echo '❌ Stopped')"
echo "🔗 WebDAV: $(pgrep -f 'rclone serve' > /dev/null && echo '✅ Running' || echo '❌ Stopped')"
echo "🔒 SSH: $(pgrep -x 'sshd' > /dev/null && echo '✅ Running' || echo '❌ Stopped')"
echo ""

echo "☁️ Connected Clouds:"
rclone listremotes 2>/dev/null | sed 's/^/   ✅ /' || echo "   ❌ No clouds connected"
echo ""

echo "🔗 GitHub: https://github.com/OrgHide/openbox"
