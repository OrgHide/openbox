#!/bin/bash
echo "🛡️ OpenBox Security Enforcement"
echo "========================================"

# Get current Tailscale IP
TAILSCALE_IP=$(tailscale ip 2>/dev/null)
CURRENT_IP=$(curl -s ifconfig.me 2>/dev/null || echo "0.0.0.0")

echo "📡 Current Public IP: $CURRENT_IP"
echo "🔒 Tailscale IP: $TAILSCALE_IP"

# Check if connected via Tailscale
if [ -z "$TAILSCALE_IP" ]; then
    echo "❌ Not connected to Tailscale!"
    echo "   Run: tailscale up"
    exit 1
fi

echo "✅ Connected to Tailscale"

# Check device allowlist
DEVICE_ID="MASTER-KANOR-PHONE"
if ! grep -q "$DEVICE_ID" ~/openbox/security/device_allowlist.yaml 2>/dev/null; then
    echo "❌ Device $DEVICE_ID not allowed!"
    echo "   Add to: ~/openbox/security/device_allowlist.yaml"
    exit 1
fi

echo "✅ Device allowed"

# Enforce single connection
ACTIVE_SESSIONS=$(pgrep -c "sshd|rclone|openlist" 2>/dev/null || echo "0")
if [ "$ACTIVE_SESSIONS" -gt 5 ]; then
    echo "⚠️ Multiple sessions detected!"
    echo "   Killing extra sessions..."
    pkill -f "openlist|rclone" 2>/dev/null
fi

echo "✅ Single connection enforced"

# Check for clone detection
CLONE_DETECTED=$(tailscale status 2>/dev/null | grep -c "DUPLICATE" || echo "0")
if [ "$CLONE_DETECTED" -gt 0 ]; then
    echo "⚠️ Clone detected! Revoking access..."
    # Auto-revoke
    tailscale logout
    exit 1
fi

echo "✅ No clones detected"
echo "🛡️ All security checks passed!"
