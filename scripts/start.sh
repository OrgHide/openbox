#!/bin/bash
echo "📦 Starting OpenBox on Northflank..."

# Set config path
export ALIST_CONFIG="/opt/openbox/configs/config.json"
export OPENLIST_CONFIG="/opt/openbox/configs/config.json"
export ALIST_PORT=2232
export OPENLIST_PORT=2232

# Check if openlist exists
if command -v openlist &> /dev/null; then
    echo "✅ OpenList found, starting..."
    openlist server --config "$OPENLIST_CONFIG" --port 2232 --address 0.0.0.0 > /opt/openbox/logs/openbox.log 2>&1
elif command -v alist &> /dev/null; then
    echo "✅ Alist found, starting..."
    alist server --config "$ALIST_CONFIG" --port 2232 --address 0.0.0.0 > /opt/openbox/logs/openbox.log 2>&1
else
    echo "❌ No OpenList/AList found! Installing..."
    
    # Try to install on the fly
    echo "📦 Installing OpenList..."
    wget -q -O /tmp/openlist.tar.gz \
        "https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-linux-amd64.tar.gz" && \
        tar -xzf /tmp/openlist.tar.gz -C /usr/local/bin/ && \
        chmod +x /usr/local/bin/openlist && \
        rm /tmp/openlist.tar.gz
    
    if command -v openlist &> /dev/null; then
        echo "✅ OpenList installed successfully!"
        openlist server --config "$OPENLIST_CONFIG" --port 2232 --address 0.0.0.0 > /opt/openbox/logs/openbox.log 2>&1
    else
        echo "❌ Installation failed. Exiting."
        exit 1
    fi
fi
