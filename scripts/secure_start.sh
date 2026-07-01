#!/bin/bash
echo "🔐 Starting OpenBox in secure mode..."
echo "========================================"

# Check Tailscale
if ! command -v tailscale &> /dev/null; then
    echo "❌ Tailscale not installed!"
    echo "   Install: curl -fsSL https://tailscale.com/install.sh | sh"
    exit 1
fi

# Start Tailscale if not connected
if ! tailscale status 2>/dev/null | grep -q "active"; then
    echo "⚠️ Tailscale not active. Starting..."
    tailscale up --accept-routes --accept-dns
    sleep 3
fi

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip 2>/dev/null)
echo "✅ Tailscale connected: $TAILSCALE_IP"

# Set Tailscale IP in config
sed -i "s/100.x.x.x/$TAILSCALE_IP/g" ~/openbox/security/user_hierarchy.yaml 2>/dev/null

# Enforce security
~/openbox/scripts/enforce_security.sh || exit 1

# Start OpenBox
export ALIST_PORT=2232
export OPENLIST_PORT=2232

pkill openlist 2>/dev/null
pkill alist 2>/dev/null

openlist server --config ~/openbox/configs/openlist/config.json > ~/openbox/logs/openbox.log 2>&1 &

sleep 3

echo ""
echo "✅ OpenBox running securely!"
echo "========================================"
echo ""
echo "👑 SUPER ADMIN (Emergency):"
echo "   URL: http://$TAILSCALE_IP:2232"
echo "   Username: OpenClose"
echo "   Password: Openpassword"
echo "   🔐 YubiKey + 2FA required"
echo ""
echo "👤 SUB-ADMIN (Daily):"
echo "   URL: http://$TAILSCALE_IP:2232"
echo "   Username: Opendev"
echo "   Password: Masterdev"
echo "   🔒 2FA required"
echo ""
echo "📊 Active connections:"
ss -tuln | grep -E ':(2232|5245|8022)' || echo "No connections"
echo ""
echo "📝 Access logged: ~/openbox/logs/access.log"
echo "========================================"

# Log access
echo "$(date) - OpenBox started - Tailscale IP: $TAILSCALE_IP" >> ~/openbox/logs/access.log
