#!/bin/bash

# Launch Claude Code with telemetry enabled
# This script sources the .env file and launches Claude Code

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ ERROR: .env file not found at $ENV_FILE"
    echo "❌ Run: npm run telemetry:setup"
    exit 1
fi

# Source the .env file to set environment variables
set -a
source "$ENV_FILE"
set +a

# Launch Claude Code with the default model (qwen3.5:9b)
echo "🚀 Launching Claude Code with telemetry enabled..."
echo "📊 Telemetry will be sent to: $OTEL_EXPORTER_OTLP_ENDPOINT"
echo ""

ollama launch claude --model qwen3.5:9b
