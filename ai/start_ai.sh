#!/bin/bash
echo "🤖 OpenBox AI Agent"
echo "========================================"
echo ""

# Load environment variables
if [ -f ~/openbox/.env ]; then
    source ~/openbox/.env
fi

# Set API key if not set
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "⚠️ OPENROUTER_API_KEY not set!"
    echo "Please set: export OPENROUTER_API_KEY=your_key"
    exit 1
fi

echo "✅ API Key found"
echo ""

# Run AI agent
python3 ~/openbox/ai/openbox_agent.py "$@"
