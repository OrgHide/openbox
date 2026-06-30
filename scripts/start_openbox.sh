#!/bin/bash
echo "📦 Starting OpenBox..."

# Set config path
export ALIST_CONFIG=~/openbox/configs/openlist/config.json
export OPENLIST_CONFIG=~/openbox/configs/openlist/config.json

# Kill existing
pkill openlist 2>/dev/null
pkill alist 2>/dev/null

# Start OpenList with OpenBox config
openlist server --config ~/openbox/configs/openlist/config.json > ~/openbox/logs/openbox.log 2>&1 &

sleep 2

# Check if running
if pgrep -x "openlist" > /dev/null; then
    echo "✅ OpenBox running on http://localhost:5244"
    echo "   Username: admin"
    echo "   Password: MasterPassword"
else
    echo "⚠️ Trying alternative..."
    alist server --config ~/openbox/configs/openlist/config.json > ~/openbox/logs/openbox.log 2>&1 &
    sleep 2
    if pgrep -x "alist" > /dev/null; then
        echo "✅ OpenBox running on http://localhost:5244"
    fi
fi
