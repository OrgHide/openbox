#!/bin/bash
echo "📊 OpenBox Monitoring"
echo "========================================"

# Check if OpenBox is running
check_service() {
    if curl -f -s -o /dev/null http://127.0.0.1:2232/api/public/settings; then
        echo "✅ Service is healthy"
        return 0
    else
        echo "❌ Service is unhealthy"
        return 1
    fi
}

# Check disk space
check_disk() {
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -gt 85 ]; then
        echo "⚠️ Disk usage: $DISK_USAGE% (critical)"
    else
        echo "✅ Disk usage: $DISK_USAGE%"
    fi
}

# Check connections
check_connections() {
    CONNECTIONS=$(ss -tuln | grep -c ":2232" 2>/dev/null || echo "0")
    echo "🔌 Active connections: $CONNECTIONS"
}

# Run checks
echo ""
echo "🔄 Running health checks..."
check_service
check_disk
check_connections

echo ""
echo "✅ Monitoring complete"
