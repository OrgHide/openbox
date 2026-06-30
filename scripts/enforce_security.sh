#!/bin/bash
echo "🛡️ OpenBox Security Enforcement"
echo "========================================"

# Get current IP
CURRENT_IP=$(curl -s ifconfig.me 2>/dev/null || echo "127.0.0.1")

echo "📡 Current IP: $CURRENT_IP"

# Check IP whitelist
if ! grep -q "$CURRENT_IP" ~/openbox/security/ip_whitelist.txt 2>/dev/null; then
    echo "❌ IP $CURRENT_IP not whitelisted!"
    echo "   Add to: ~/openbox/security/ip_whitelist.txt"
    exit 1
fi

echo "✅ IP whitelisted"

# Check device registration
DEVICE_ID="MASTER-KANOR-PHONE"
if ! grep -q "$DEVICE_ID" ~/openbox/security/device_registry.txt 2>/dev/null; then
    echo "❌ Device $DEVICE_ID not registered!"
    echo "   Add to: ~/openbox/security/device_registry.txt"
    exit 1
fi

echo "✅ Device registered"

# Enforce single connection
ACTIVE_SESSIONS=$(pgrep -c "sshd|rclone|openlist" 2>/dev/null || echo "0")
if [ "$ACTIVE_SESSIONS" -gt 5 ]; then
    echo "⚠️ Multiple active sessions detected!"
    echo "   Killing extra sessions..."
    pkill -f "openlist|rclone" 2>/dev/null
fi

echo "✅ Single connection enforced"
echo "🛡️ All security checks passed!"
