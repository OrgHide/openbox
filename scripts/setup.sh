#!/bin/bash
echo "🔧 Setting up OpenBox..."

# Create directories
mkdir -p ~/openbox/{data,logs,tmp,configs/rclone,configs/openlist}

# Copy configs
cp -r ~/openbox/configs/* ~/openbox/configs/ 2>/dev/null

# Set permissions
chmod 755 ~/openbox/scripts/*.sh

echo "✅ OpenBox setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Start OpenBox: ./scripts/start.sh"
echo "  2. Connect clouds: rclone config reconnect [remote]:"
echo "  3. Access WebUI: http://localhost:5244"
