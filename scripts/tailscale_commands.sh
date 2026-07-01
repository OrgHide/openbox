#!/bin/bash
echo "🔐 Tailscale Commands"
echo "========================================"

echo "📡 Tailscale Status:"
tailscale status

echo ""
echo "📱 Your Tailscale IP:"
tailscale ip

echo ""
echo "🔗 Connected Devices:"
tailscale status | grep -v "offline"

echo ""
echo "🌐 OpenBox Access URL:"
TAILSCALE_IP=$(tailscale ip 2>/dev/null)
echo "   http://$TAILSCALE_IP:2232"
echo ""
echo "👑 Super Admin: OpenClose / Openpassword"
echo "👤 Sub-Admin: Opendev / Masterdev"
