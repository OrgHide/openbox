#!/bin/bash
echo "📦 Starting OpenBox on Northflank..."

# Set config path
export ALIST_CONFIG="/opt/openbox/configs/config.json"
export OPENLIST_CONFIG="/opt/openbox/configs/config.json"
export ALIST_PORT=2232
export OPENLIST_PORT=2232

# Check if openlist exists
if command -v openlist &> /dev/null; then
    echo "Starting openlist..."
    openlist server --config "$OPENLIST_CONFIG" > /opt/openbox/logs/openbox.log 2>&1
elif command -v alist &> /dev/null; then
    echo "Starting alist..."
    alist server --config "$ALIST_CONFIG" > /opt/openbox/logs/openbox.log 2>&1
else
    echo "❌ No OpenList/AList found!"
    exit 1
fi
