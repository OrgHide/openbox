#!/bin/bash
echo "📦 Starting OpenBox..."

export ALIST_CONFIG="/opt/openbox/configs/config.json"
export ALIST_PORT=2232

# Check if alist exists
if command -v alist &> /dev/null; then
    echo "✅ Alist found at: $(which alist)"
    
    # Initialize database with users
    echo "🔑 Setting up users..."
    alist admin set admin --password Openpassword 2>/dev/null
    alist admin set OpenClose --password Openpassword 2>/dev/null
    alist admin set Opendev --password Masterdev 2>/dev/null
    
    echo "🚀 Starting server on port 2232..."
    exec alist server --config "$ALIST_CONFIG" --port 2232 --address 0.0.0.0
else
    echo "❌ Alist not found!"
    exit 1
fi
