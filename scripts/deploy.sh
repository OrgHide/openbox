#!/bin/bash
echo "🚀 Deploying OpenBox to Northflank..."

# Check token
if [ -z "$NORTHFLANK_TOKEN" ]; then
    echo "❌ NORTHFLANK_TOKEN not set!"
    echo "Please set: export NORTHFLANK_TOKEN=your_token"
    exit 1
fi

# Deploy
curl -X POST \
    -H "Authorization: Bearer $NORTHFLANK_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "service": "openbox",
        "version": "'$(git rev-parse HEAD)'",
        "environment": {
            "DEPLOY_TIME": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
            "GIT_COMMIT": "'$(git rev-parse HEAD)'",
            "OPENBOX_VERSION": "2.0.0"
        }
    }' \
    https://api.northflank.com/v1/deploy

echo ""
echo "✅ Deployment initiated!"
echo "📊 Check: https://app.northflank.com"
