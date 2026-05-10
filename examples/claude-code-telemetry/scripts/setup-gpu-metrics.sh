#!/bin/bash
# setup-gpu-metrics.sh
# Creates a sudoers rule so powermetrics can run without a password prompt,
# enabling the Apple Silicon GPU/ANE exporter to sample metrics automatically.

SUDOERS_FILE="/etc/sudoers.d/powermetrics-exporter"
CURRENT_USER="$(whoami)"
RULE="${CURRENT_USER} ALL = NOPASSWD: /usr/bin/powermetrics"

if [ "$(uname -s)" != "Darwin" ]; then
    echo "ℹ️  Skipping GPU metrics setup (not macOS)"
    exit 0
fi

if sudo test -f "$SUDOERS_FILE" 2>/dev/null; then
    echo "✅ sudoers rule already exists — GPU metrics can sample without password"
    exit 0
fi

echo "🔐 Setting up passwordless sudo for powermetrics (Apple Silicon GPU metrics)..."
echo "   This requires your password once to create the rule at:"
echo "   $SUDOERS_FILE"
echo ""
echo "   Rule: $RULE"
echo ""

echo "$RULE" | sudo tee "$SUDOERS_FILE" > /dev/null
sudo chmod 440 "$SUDOERS_FILE"

if sudo test -f "$SUDOERS_FILE"; then
    echo "✅ sudoers rule created — GPU exporter can now run without a password prompt"
else
    echo "❌ Failed to create sudoers rule — GPU metrics will not be available"
    exit 1
fi
