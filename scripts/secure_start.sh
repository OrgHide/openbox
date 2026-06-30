#!/bin/bash
echo "🔐 Starting OpenBox in secure mode..."

# Enforce security first
~/openbox/scripts/enforce_security.sh || exit 1

# Start services
~/openbox/scripts/start_openbox.sh

# Monitor connections
echo ""
echo "📊 Active connections:"
ss -tuln | grep -E ':(5244|8080|8022)' || echo "No connections"

# Log access
echo "$(date) - OpenBox started - IP: $(curl -s ifconfig.me)" >> ~/openbox/logs/access.log
