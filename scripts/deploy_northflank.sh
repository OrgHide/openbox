#!/bin/bash
echo "🚀 Deploying OpenBox to Northflank"
echo "========================================"

# Load Northflank token
export NORTHFLANK_TOKEN="${NORTHFLANK_TOKEN:-}"
if [ -z "$NORTHFLANK_TOKEN" ]; then
    echo "❌ NORTHFLANK_TOKEN not set!"
    echo "Please set: export NORTHFLANK_TOKEN=your_token"
    exit 1
fi

# Deploy to Northflank
echo "📦 Deploying service..."
curl -X POST \
    -H "Authorization: Bearer $NORTHFLANK_TOKEN" \
    -H "Content-Type: application/json" \
    -d @~/openbox/deploy/northflank.json \
    https://api.northflank.com/v1/deploy

echo ""
echo "✅ Deployment initiated!"
echo "📊 Check status: https://app.northflank.com"
