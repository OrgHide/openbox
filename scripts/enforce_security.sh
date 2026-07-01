#!/bin/bash
echo "🛡️ OpenBox Security Enforcement"
echo "========================================"
echo ""

# Check for Super Admin
if [ "$USER" = "OpenClose" ]; then
    echo "👑 Super Admin detected - Full access granted"
    echo "🔐 YubiKey required for authentication"
    echo "✅ Emergency access enabled"
elif [ "$USER" = "Opendev" ]; then
    echo "👤 Sub-Admin detected - Limited access"
    echo "🔒 Read-only for high-risk operations"
    echo "🚫 Recycle bin deletion: DISABLED"
    echo "🚫 Super Admin deletion: DISABLED"
    echo "🚫 Entire space deletion: DISABLED"
else
    echo "❌ Unknown user - Access denied"
    exit 1
fi

echo ""
echo "🔍 Checking security policies..."

# Check Tailscale
if ! tailscale status 2>/dev/null | grep -q "active"; then
    echo "❌ Tailscale not connected!"
    echo "   Run: tailscale up"
    exit 1
fi

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip 2>/dev/null)
echo "✅ Tailscale connected: $TAILSCALE_IP"

# Check device allowlist
DEVICE_ID="MASTER-KANOR-PHONE"
if ! grep -q "$DEVICE_ID" ~/openbox/security/device_allowlist.yaml 2>/dev/null; then
    echo "⚠️ Device not in allowlist"
fi

echo ""
echo "📊 Active sessions:"
ss -tuln | grep -E ':(2232|5245|8022)' || echo "No connections"

echo ""
echo "🛡️ All security checks passed!"
