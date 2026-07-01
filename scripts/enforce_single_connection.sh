#!/bin/bash
echo "🛡️ OpenBox Connection Enforcement"
echo "========================================"

# Check active connections on port 2232
CONNECTIONS=$(ss -tuln | grep -c ":2232" 2>/dev/null || echo "0")

if [ "$CONNECTIONS" -gt 1 ]; then
    echo "⚠️ Multiple connections detected! ($CONNECTIONS)"
    echo "🔒 Enforcing single connection..."
    # Kill older connections
    pkill -f "openlist.*2232" 2>/dev/null
    pkill -f "alist.*2232" 2>/dev/null
    echo "✅ Extra connections killed"
else
    echo "✅ Single connection active"
fi

# Show current connections
echo ""
echo "📊 Active connections on port 2232:"
ss -tuln | grep ":2232" || echo "No active connections"
