# Claude Code Telemetry Setup

This example demonstrates how to set up comprehensive telemetry monitoring for Claude Code and locally-hosted Ollama models using OpenTelemetry, Prometheus, and Grafana.

> **Why two metric sources?** Claude Code's built-in telemetry only emits aggregate counters (token usage, session count, cost). It does **not** expose per-query response times. To compare the actual latency and throughput of locally-hosted models like `qwen3.5:9b`, `gemma4-26b`, or `gpt-oss:20b`, we added the [`ollama-metrics`](https://github.com/NorskHelsenett/ollama-metrics) sidecar, which scrapes the Ollama API after each request and exposes a full Prometheus histogram for request duration, time-per-token, and RAM usage per model.

## What This Provides

- **OpenTelemetry Collector**: Receives telemetry data from Claude Code via OTLP
- **Ollama Metrics Sidecar**: Scrapes Ollama API for per-request latency, token throughput, and RAM usage per model
- **Prometheus**: Scrapes and stores metrics from both the OTel Collector and Ollama sidecar
- **Grafana**: Visualizes metrics with pre-built dashboards for both Claude Code and Ollama performance

## Architecture

```
Claude Code → OTLP → OpenTelemetry Collector ─┐
                                               ├─→ Prometheus → Grafana
Ollama (local) ← poll ← ollama-metrics sidecar ┘
```

## Prerequisites

1. **Docker Desktop** for macOS - [Download](https://www.docker.com/products/docker-desktop/)
2. **Claude Code** installed and configured
3. **Homebrew** - for installing `node_exporter` (macOS system metrics)
4. Basic understanding of Docker Compose

## Quick Start

### 0. Install node_exporter (macOS System Metrics)

> **What is node_exporter?** It's a Prometheus exporter that runs natively on your Mac and exposes CPU, memory, disk, network, and load metrics to Prometheus. Because our Prometheus runs inside Docker (which uses a Linux VM on macOS), the exporter **must** run locally — not in Docker — to report actual host metrics.

```bash
npm run telemetry:node-exporter:install  # Installs via Homebrew
npm run telemetry:node-exporter:start    # Starts as a background service
```

Verify it's running:
```bash
curl http://localhost:9100/metrics | head -20
```

You only need to do this once — Homebrew services persist across reboots.

> **GPU metrics**: Apple Silicon GPU utilization IS available via `powermetrics`. A custom exporter is included — see [Step 0b](#0b-set-up-apple-silicon-gpu-metrics-macos-only) below.

### 0b. Set Up Apple Silicon GPU Metrics (macOS only)

> **How it works**: The `apple-silicon-gpu-exporter.py` script samples `sudo powermetrics` every 15 seconds and writes Prometheus `.prom` files to `/tmp/node-exporter-textfile/`. `node_exporter` reads that directory via `--collector.textfile.directory` and exposes the metrics to Prometheus. This is the same data source Activity Monitor uses, but routed into your dashboard.

This requires a one-time `sudo` setup to allow `powermetrics` to run without a password prompt:

```bash
npm run telemetry:gpu:setup   # Adds /etc/sudoers.d/powermetrics-exporter
npm run telemetry:gpu:start   # Starts the background exporter
```

> **`telemetry:all` handles this automatically** — `gpu:setup` and `gpu:start` are included in the startup sequence. The first run will prompt for your password once to create the sudoers rule; all subsequent runs are passwordless.

### 1. Set Up Environment Configuration

**⚠️ IMPORTANT: You must create a `.env` file before starting the monitoring stack**

Check if the `.env` file exists:
```bash
ls examples/claude-code-telemetry/.env
```

If it doesn't exist, copy the example file:
```bash
cp examples/claude-code-telemetry/.env.example examples/claude-code-telemetry/.env
```

Or use the convenience script:
```bash
npm run telemetry:setup
```

Then review and customize the settings in [`examples/claude-code-telemetry/.env`](examples/claude-code-telemetry/.env) as needed.

### 2. Start the Monitoring Stack

```bash
npm run telemetry:up
```

This will:
- Load environment variables from `.env` file
- Start OpenTelemetry Collector on port 4317 (gRPC) and 4318 (HTTP)
- Start Prometheus on port 9090
- Start Grafana on port 3001

### 3. Launch Claude Code with Telemetry

Use the convenience script to launch Claude Code with telemetry automatically enabled:

```bash
npm run telemetry:launch  # Launch with qwen3.5:9b (default)
```

Or choose a specific model:

```bash
npm run telemetry:launch:claude:gemma4    # Launch with gemma4-26b
npm run telemetry:launch:claude:gemma4-e4b # Launch with gemma4-e4b
npm run telemetry:launch:claude:gpt-oss    # Launch with gpt-oss:20b
npm run telemetry:launch:claude:qwen3.5:9b # Launch with qwen3.5:9b
```

This sources the environment variables from [`.env`](.env) and launches Claude Code with the specified model.

Or run the script directly:
```bash
cd examples/claude-code-telemetry
./launch-claude-with-telemetry.sh
```

**Alternative**: For production or organization-wide deployment, use the managed settings file:

**macOS**: `/Library/Application Support/ClaudeCode/managed-settings.json`

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TELEMETRY": "1",
    "OTEL_METRICS_EXPORTER": "otlp",
    "OTEL_LOGS_EXPORTER": "otlp",
    "OTEL_EXPORTER_OTLP_PROTOCOL": "grpc",
    "OTEL_EXPORTER_OTLP_ENDPOINT": "http://localhost:4317"
  }
}
```

### 4. Verify Telemetry is Working

The verification script runs automatically after starting the monitoring stack. You can also run it manually:

```bash
npm run telemetry:verify
```

This checks that all services are running and displays dashboard access information.

### 5. Access the Dashboards

- **Grafana**: <http://localhost:3001>
  - Username: `admin`
  - Password: `admin`
- **Prometheus**: <http://localhost:9090>

## Available Metrics

### Claude Code Metrics (via OpenTelemetry)

| Metric | Description |
|--------|-------------|
| `claude_code_token_usage_tokens_total` | Token counts by type: `input`, `output`, `cacheRead`, `cacheCreation` |
| `claude_code_active_time_seconds_total` | Active time per session by type: `user`, `cli` |
| `claude_code_session_count_total` | Total sessions started |
| `claude_code_cost_usage_USD_total` | Cumulative cost in USD per model |

> **Note**: Claude Code metrics are aggregate counters. They do **not** include per-query response time — use the Ollama metrics below for latency comparisons.

### Ollama Metrics (via ollama-metrics sidecar)

| Metric | Description |
|--------|-------------|
| `ollama_request_duration_seconds` | **Per-request latency histogram** — supports p50/p95/p99 by model |
| `ollama_time_per_token_seconds` | Time to generate each token (lower = faster) |
| `ollama_generated_tokens_total` | Total output tokens generated per model |
| `ollama_prompt_tokens_total` | Total prompt tokens sent per model |
| `ollama_model_ram_mb` | RAM consumed by each loaded model |
| `ollama_loaded_models` | Number of models currently loaded in memory |

### macOS System Metrics (via node_exporter — optional)

> **Requires** `node_exporter` running locally. See [Setup step 0](#0-install-node_exporter-macos-system-metrics) above.

| Metric | Description |
|--------|-------------|
| `node_cpu_seconds_total` | CPU time by mode (user/system/idle) — per core and overall |
| `node_memory_total_bytes` / `node_memory_wired_bytes` | Total RAM and wired memory (best proxy for model memory pressure) |
| `node_load1` / `node_load5` / `node_load15` | System load averages — useful during model inference |
| `node_disk_read_bytes_total` / `node_disk_written_bytes_total` | Disk throughput — spikes when loading models from disk |
| `node_network_receive_bytes_total` / `node_network_transmit_bytes_total` | Network throughput per interface |
| `node_filesystem_avail_bytes` | Available disk space per mount — track as you pull more models |

### Apple Silicon GPU & Power Metrics (via custom exporter)

> **Requires** one-time sudoers setup. See [Setup step 0b](#0b-set-up-apple-silicon-gpu-metrics-macos-only) above.

| Metric | Description |
|--------|-------------|
| `apple_silicon_gpu_utilization_ratio` | GPU utilization (0=idle, 1=fully busy) — same source as Activity Monitor |
| `apple_silicon_gpu_frequency_hz` | Current GPU clock frequency in Hz |
| `apple_silicon_gpu_power_mw` | GPU power consumption in milliwatts |
| `apple_silicon_ane_power_mw` | Neural Engine (ANE) power consumption in milliwatts |
| `apple_silicon_cpu_power_mw` | CPU power consumption in milliwatts |
| `apple_silicon_combined_power_mw` | Total SoC power consumption in milliwatts |

For a complete list of Claude Code metrics, see the [Claude Code Monitoring Documentation](https://code.claude.com/docs/en/monitoring-usage).

## Configuration Files

- [`docker-compose.yml`](docker-compose.yml) - Orchestrates the monitoring stack (OTel Collector, Prometheus, Grafana, ollama-metrics sidecar)
- [`otel-collector-config.yaml`](otel-collector-config.yaml) - OTel Collector configuration
- [`prometheus.yml`](prometheus.yml) - Prometheus scraping configuration (scrapes both OTel Collector and ollama-metrics)
- [`grafana/provisioning/`](grafana/provisioning/) - Grafana datasource and dashboard provisioning
- [`.env.example`](.env.example) - Example environment variables

## NPM Scripts

### Monitoring Stack

```bash
npm run telemetry:all     # Start monitoring stack and launch Claude Code with telemetry (one command)
npm run telemetry:start   # Setup and start the monitoring stack (one command)
npm run telemetry:launch  # Launch Claude Code with telemetry enabled
npm run telemetry:setup   # Copy .env.example to .env
npm run telemetry:up      # Start the monitoring stack
npm run telemetry:verify  # Verify all services are running
npm run telemetry:down    # Stop the monitoring stack
npm run telemetry:restart # Restart the monitoring stack
npm run telemetry:logs    # View logs from all services
npm run telemetry:status  # Check status of all services
```

### node_exporter (macOS System Metrics)

```bash
npm run telemetry:node-exporter:install  # Install via Homebrew (one-time)
npm run telemetry:node-exporter:start    # Start with textfile collector enabled
npm run telemetry:node-exporter:stop     # Stop the background process
npm run telemetry:node-exporter:status   # Check if it's running
```

### Apple Silicon GPU Exporter

```bash
npm run telemetry:gpu:setup   # One-time: create sudoers rule for passwordless powermetrics
npm run telemetry:gpu:start   # Start the GPU/ANE/power metrics background exporter
npm run telemetry:gpu:stop    # Stop the GPU exporter
npm run telemetry:gpu:status  # Check if the GPU exporter is running
```

## Troubleshooting

### Claude Code not sending metrics

1. Use the convenience script to launch Claude Code with telemetry enabled:
   ```bash
   npm run telemetry:launch
   ```
   This automatically sources the environment variables from [`.env`](.env) and launches Claude Code.

2. Verify the monitoring stack is running:
   ```bash
   npm run telemetry:status
   ```

3. Check if OTel Collector is running:
   ```bash
   curl http://localhost:4318
   ```
   Should return `404 page not found` (expected - port 4318 is HTTP receiver)

   Or check container status:
   ```bash
   npm run telemetry:status
   ```

4. Restart Claude Code after enabling telemetry

### Grafana not connecting to Prometheus

1. Verify Prometheus is running:
   ```bash
   curl http://localhost:9090
   ```

2. Check Grafana datasource configuration in the UI:
   - Configuration → Data Sources → Prometheus
   - Ensure URL is `http://prometheus:9090`

### No metrics appearing in Prometheus

1. Check OTel Collector logs:
   ```bash
   npm run telemetry:logs
   ```

2. Verify Claude Code is actually sending data by checking the collector logs for incoming connections

## Customization

### Adding Custom Dashboards

1. Create a new dashboard JSON file in [`grafana/dashboards/`](grafana/dashboards/)
2. It will be automatically loaded by Grafana

### Modifying Scraping Interval

Edit [`prometheus.yml`](prometheus.yml):
```yaml
global:
  scrape_interval: 30s  # Change from default 15s
```

### Adding Additional Exporters

Edit [`otel-collector-config.yaml`](otel-collector-config.yaml) to add more exporters (e.g., Loki for logs).

### Comparing Model Performance

The **Ollama Model Performance** section of the Grafana dashboard at <http://localhost:3001> shows per-model comparisons. To compare models:

1. Run a session with one model: `npm run telemetry:launch:claude:qwen3.5:9b`
2. Exit and run another: `npm run telemetry:launch:claude:gemma4`
3. View the **Request Latency by Model (p50/p95/p99)** and **Avg Time Per Token by Model** panels to compare

## Security Considerations

- **Production Use**: Change default Grafana credentials
- **Network Security**: Consider running behind a reverse proxy
- **Data Retention**: Configure Prometheus retention based on your needs
- **Authentication**: Add authentication to Prometheus if exposed externally

## Resources

- [Claude Code Monitoring Documentation](https://code.claude.com/docs/en/monitoring-usage)
- [OpenTelemetry Collector Documentation](https://opentelemetry.io/docs/collector/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Claude Code ROI Measurement Guide](https://github.com/anthropics/claude-code-monitoring-guide)
- [ollama-metrics Sidecar](https://github.com/NorskHelsenett/ollama-metrics) - Prometheus metrics for Ollama

## Stopping the Stack

```bash
npm run telemetry:down
```

This will stop all containers and remove the network. Volumes are preserved to retain data.
