#!/bin/bash
echo "📦 Starting OpenBox..."

# Enforce single connection
~/openbox/scripts/enforce_single_connection.sh

# Start OpenBox on port 2232
export ALIST_PORT=2232
pkill openlist 2>/dev/null
openlist server --port 2232 --address 0.0.0.0 > ~/openbox/logs/openbox.log 2>&1 &

sleep 3

# Get Tailscale IP if available
TAILSCALE_IP=$(tailscale ip 2>/dev/null || echo "100.104.142.38")

echo ""
echo "✅ OpenBox running!"
echo "🔗 Local: http://127.0.0.1:2232"
echo "🔗 Tailscale: http://$TAILSCALE_IP:2232"
echo ""
echo "👑 admin / Openpassword (Super Admin)"
echo "👤 Opendev / Masterdev (Sub-Admin)"
