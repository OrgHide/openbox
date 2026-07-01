#!/bin/bash
echo "📦 Starting OpenBox..."

export ALIST_CONFIG="/data/data/com.termux/files/home/openbox/configs/config.json"
export OPENLIST_CONFIG="/data/data/com.termux/files/home/openbox/configs/config.json"

# Kill everything
pkill -9 -f "openlist\|alist" 2>/dev/null
pkill -9 -f "socat" 2>/dev/null
sleep 2

# Start OpenBox
if command -v openlist &> /dev/null; then
    openlist server --config "$OPENLIST_CONFIG" > ~/openbox/logs/openbox.log 2>&1 &
elif command -v alist &> /dev/null; then
    alist server --config "$ALIST_CONFIG" > ~/openbox/logs/openbox.log 2>&1 &
fi

sleep 3
socat TCP-LISTEN:2232,fork,reuseaddr TCP:127.0.0.1:5244 &

sleep 2
TAILSCALE_IP=$(tailscale ip 2>/dev/null || echo "100.104.142.38")

echo ""
echo "✅ OpenBox running!"
echo "🔗 Local: http://127.0.0.1:2232"
echo "🔗 Tailscale: http://$TAILSCALE_IP:2232"
echo ""
echo "👑 admin / fGtageil (Super Admin)"
echo "👤 Opendev / Masterdev (Sub-Admin)"
