#!/bin/bash
echo "📦 Installing OpenList..."

# Try to install via go
apk add --no-cache go git
go install github.com/alist-org/alist/v3@latest
cp /root/go/bin/alist /usr/local/bin/openlist
chmod +x /usr/local/bin/openlist
apk del go git

echo "✅ OpenList installed"
