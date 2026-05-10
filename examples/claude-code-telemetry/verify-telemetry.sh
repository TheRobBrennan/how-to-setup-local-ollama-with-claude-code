#!/bin/bash

# Telemetry Verification Script
# This script verifies that the Claude Code telemetry monitoring stack is running correctly

echo "🔍 Verifying Claude Code Telemetry Setup..."
echo ""

# Check if OTel Collector is running
echo "1. Checking OTel Collector (HTTP receiver on port 4318)..."
if curl -s http://localhost:4318 > /dev/null 2>&1; then
    echo "   ✅ OTel Collector is running"
else
    echo "   ❌ OTel Collector is not responding"
    exit 1
fi

# Check if Prometheus is running (with retry for startup time)
echo ""
echo "2. Checking Prometheus (port 9090)..."
PROMETHEUS_READY=0
for i in {1..10}; do
    if curl -s http://localhost:9090 > /dev/null 2>&1; then
        echo "   ✅ Prometheus is running"
        PROMETHEUS_READY=1
        break
    else
        echo "   ⏳ Waiting for Prometheus to start... ($i/10)"
        sleep 2
    fi
done

if [ $PROMETHEUS_READY -eq 0 ]; then
    echo "   ❌ Prometheus is not responding after 20 seconds"
    echo "   💡 Tip: Prometheus may take longer to start. Try 'npm run telemetry:status' to check container status"
    exit 1
fi

# Check if Grafana is running (with retry for startup time)
echo ""
echo "3. Checking Grafana (port 3001)..."
GRAFANA_READY=0
for i in {1..10}; do
    if curl -s http://localhost:3001 > /dev/null 2>&1; then
        echo "   ✅ Grafana is running"
        GRAFANA_READY=1
        break
    else
        echo "   ⏳ Waiting for Grafana to start... ($i/10)"
        sleep 2
    fi
done

if [ $GRAFANA_READY -eq 0 ]; then
    echo "   ❌ Grafana is not responding after 20 seconds"
    echo "   💡 Tip: Grafana may take longer to start. Try 'npm run telemetry:status' to check container status"
    exit 1
fi

# Check node_exporter (macOS only, non-fatal)
echo ""
echo "4. Checking node_exporter (macOS system metrics on port 9100)..."
if [ "$(uname -s)" = "Darwin" ]; then
    if curl -s http://localhost:9100/metrics > /dev/null 2>&1; then
        echo "   ✅ node_exporter is running (CPU, memory, disk, network metrics enabled)"
    else
        echo "   ⚠️  node_exporter is not running - macOS system metrics unavailable"
        echo "   💡 It will be auto-installed next time you run: npm run telemetry:all"
        echo "   💡 Or install manually now: npm run telemetry:node-exporter:install"
    fi
else
    echo "   ℹ️  Skipping (not macOS) - system metrics not available on this platform"
fi

# Check Apple Silicon GPU exporter (macOS only, non-fatal)
echo ""
echo "5. Checking Apple Silicon GPU exporter..."
if [ "$(uname -s)" = "Darwin" ]; then
    if pgrep -f apple-silicon-gpu-exporter.py > /dev/null 2>&1; then
        echo "   ✅ GPU exporter is running (GPU utilization, frequency, and power metrics enabled)"
    else
        echo "   ⚠️  GPU exporter is not running - Apple Silicon GPU/power metrics unavailable"
        echo "   💡 It will be auto-started next time you run: npm run telemetry:all"
        echo "   💡 Or start manually now: npm run telemetry:gpu:start"
    fi
else
    echo "   ℹ️  Skipping (not macOS) - GPU metrics not available on this platform"
fi

echo ""
echo "✅ All services are running successfully!"
echo ""
echo "📊 Access the dashboards:"
echo "   - Grafana: http://localhost:3001 (admin/admin)"
echo "   - Prometheus: http://localhost:9090"
echo ""
echo "🔧 Next steps:"
echo "   1. Launch Claude Code with telemetry: npm run telemetry:launch"
echo "   2. Or run the script directly: ./launch-claude-with-telemetry.sh"
echo "   3. Start using Claude Code - metrics will be sent to the monitoring stack"
