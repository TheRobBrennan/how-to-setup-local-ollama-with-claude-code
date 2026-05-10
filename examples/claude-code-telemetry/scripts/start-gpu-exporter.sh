#!/bin/bash
# Starts apple-silicon-gpu-exporter.py as a proper background daemon.
# Using a wrapper script avoids Python stream init errors from nohup.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEXTFILE_DIR="${1:-/tmp/node-exporter-textfile}"
LOG_FILE="/tmp/apple-silicon-gpu-exporter.log"
PID_FILE="/tmp/apple-silicon-gpu-exporter.pid"

mkdir -p "$TEXTFILE_DIR"
pkill -f apple-silicon-gpu-exporter.py 2>/dev/null
sleep 0.5

python3 -u "$SCRIPT_DIR/apple-silicon-gpu-exporter.py" "$TEXTFILE_DIR" \
    </dev/null >"$LOG_FILE" 2>&1 &

echo $! > "$PID_FILE"
echo "✅ Apple Silicon GPU exporter started (PID: $(cat $PID_FILE))"
