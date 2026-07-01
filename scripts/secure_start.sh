#!/bin/bash
echo "🔐 Starting OpenBox in secure mode..."

# Check Tailscale
if ! tailscale status 2>/dev/null | grep -q "active"; then
    echo "⚠️ Tailscale not active. Starting..."
    tailscale up --accept-routes --accept-dns
    sleep 2
fi

# Enforce security
~/openbox/scripts/enforce_security.sh || exit 1

# Start OpenBox on port 2232
export ALIST_PORT=2232
export OPENLIST_PORT=2232

# Kill existing
pkill openlist 2>/dev/null
pkill alist 2>/dev/null

# Start with secure config
openlist server --config ~/openbox/configs/openlist/config.json > ~/openbox/logs/openbox.log 2>&1 &

sleep 3

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip 2>/dev/null)

echo ""
echo "✅ OpenBox running securely!"
echo ""
echo "👑 SUPER ADMIN ACCESS:"
echo "   URL: http://$TAILSCALE_IP:2232"
echo "   Username: OpenClose"
echo "   Password: Openpassword"
echo "   🔐 YubiKey + 2FA required"
echo "   🚨 Emergency access only"
echo ""
echo "👤 SUB-ADMIN ACCESS:"
echo "   URL: http://$TAILSCALE_IP:2232"
echo "   Username: Opendev"
echo "   Password: Masterdev"
echo "   🔒 2FA required"
echo "   📝 Daily business & development"
echo ""
echo "📊 Active connections:"
ss -tuln | grep -E ':(2232|5245|8022)' || echo "No connections"

# Log access
echo "$(date) - OpenBox started - Super Admin: OpenClose, Sub-Admin: Opendev" >> ~/openbox/logs/access.log
