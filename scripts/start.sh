#!/bin/bash
echo "📦 Starting OpenBox on Northflank..."

export ALIST_CONFIG="/opt/openbox/configs/config.json"
export OPENLIST_CONFIG="/opt/openbox/configs/config.json"
export ALIST_PORT=2232
export OPENLIST_PORT=2232

# Check for openlist or alist
if command -v openlist &> /dev/null; then
    echo "✅ OpenList found at: $(which openlist)"
    echo "Starting OpenList on port 2232..."
    openlist server --config "$OPENLIST_CONFIG"
elif command -v alist &> /dev/null; then
    echo "✅ Alist found at: $(which alist)"
    echo "Starting Alist on port 2232..."
    alist server --config "$ALIST_CONFIG" --port 2232 --address 0.0.0.0
else
    echo "❌ No OpenList/AList found!"
    exit 1
fi
