# Examples Directory

This directory contains example scripts and demonstrations for the "How to Setup Local Ollama with Claude Code" project.

## � Claude Code Telemetry Example

### Claude Code Telemetry Overview
The Claude Code telemetry example ([`claude-code-telemetry/`](claude-code-telemetry/)) demonstrates how to set up comprehensive telemetry monitoring for Claude Code using OpenTelemetry, Prometheus, and Grafana.

### Claude Code Telemetry Features
- **OpenTelemetry Collector**: Receives telemetry data from Claude Code via OTLP
- **Prometheus**: Scrapes and stores metrics from the OTel Collector
- **Grafana**: Visualizes metrics with customizable dashboards
- **Easy Setup**: One-command setup with environment configuration

### Claude Code Telemetry Usage

#### Claude Code Telemetry Quick Start
```bash
# One command starts everything (recommended)
# On macOS: auto-installs node_exporter, sets up GPU metrics, starts Docker stack, launches Claude Code
npm run telemetry:all

# Access Grafana at http://localhost:3001 (admin/admin)
# Access Prometheus at http://localhost:9090
```

#### Claude Code Telemetry NPM Scripts
```bash
# Monitoring stack
npm run telemetry:all     # Start everything and launch Claude Code (one command)
npm run telemetry:setup   # Copy .env.example to .env
npm run telemetry:start   # Setup and start the monitoring stack
npm run telemetry:up      # Start the monitoring stack
npm run telemetry:down    # Stop the monitoring stack
npm run telemetry:restart # Restart the monitoring stack
npm run telemetry:logs    # View logs from all services
npm run telemetry:status  # Check status of all services
npm run telemetry:verify  # Verify all services are running

# macOS system metrics (auto-handled by telemetry:all)
npm run telemetry:node-exporter:install  # Install node_exporter via Homebrew
npm run telemetry:node-exporter:start    # Start with textfile collector enabled
npm run telemetry:node-exporter:stop     # Stop node_exporter
npm run telemetry:node-exporter:status   # Check if running

# Apple Silicon GPU metrics (auto-handled by telemetry:all)
npm run telemetry:gpu:setup   # One-time sudoers rule for passwordless powermetrics
npm run telemetry:gpu:start   # Start GPU/ANE/power metrics exporter
npm run telemetry:gpu:stop    # Stop GPU exporter
npm run telemetry:gpu:status  # Check if GPU exporter is running
```

### Claude Code Telemetry Documentation
See [`claude-code-telemetry/README.md`](claude-code-telemetry/README.md) for detailed setup instructions, configuration, and troubleshooting.

## � Docker Vane Example

### Docker Vane Overview
The Docker Vane example ([`docker-vane/`](docker-vane/)) demonstrates how to run [Vane](https://github.com/ItzCrazyKns/Vane), a privacy-focused AI search engine, with local Ollama on macOS using Docker Compose.

### Docker Vane Features
- **Privacy-Focused**: All reasoning happens locally with Ollama
- **Source Citations**: Every claim includes verifiable source links
- **SearxNG Integration**: Bundled web search with privacy features
- **Docker Compose**: Easy spin up/down with npm scripts

### Docker Vane Usage

#### Docker Vane Quick Start
```bash
# Pull qwen3.5:9b model
npm run check:qwen3.5

# Start Vane container
npm run docker:vane:up

# Access at http://localhost:3000
```

#### Docker Vane NPM Scripts
```bash
npm run docker:vane:up      # Start Vane container
npm run docker:vane:down    # Stop Vane container
npm run docker:vane:restart # Restart Vane container
npm run docker:vane:logs    # View Vane logs
```

### Docker Vane Documentation
See [`docker-vane/README.md`](docker-vane/README.md) for detailed setup instructions, configuration, and troubleshooting.

## 🏒 NHL Games Script

### Script Overview
The NHL Games script (`scripts/nhl/nhl_games.sh`) provides professional, client-ready display of NHL hockey games with real-time scores and scheduling information.

#### Script Features
- **Professional Formatting**: Unicode table borders with clean presentation
- **Date Flexibility**: Show games for any date (past, present, or future)
- **Real-time Status**: FINAL, IN PROGRESS, SCHEDULED game states
- **Live Game Details**: Period number, time remaining, intermission status
- **Timezone Support**: All times displayed in Pacific Standard Time (PST)
- **Comprehensive Legend**: Clear explanations of all game status indicators

#### Script Usage

#### NPM Scripts (Recommended)
```bash
# Show today's games
npm run nhl:today

# Show games for specific date
npm run nhl:date -- 2026-02-03
npm run nhl:date -- 2026-01-31
npm run nhl:date -- 2025-12-25
```

#### Direct Script Usage
```bash
# Show today's games (default)
./examples/scripts/nhl/nhl_games.sh

# Show games for specific date
./examples/scripts/nhl/nhl_games.sh 2026-02-03
./examples/scripts/nhl/nhl_games.sh 2026-01-31
```

### Date Format
- **Required**: `YYYY-MM-DD` format
- **Examples**: `2026-02-03`, `2026-01-31`, `2025-12-25`
- **Default**: Current date when no date provided

### Output Examples

#### Today's Games (Completed)
```
🏒 NHL Hockey Games
📅 Saturday, January 31, 2026

┌─────────────┬─────────────────┬─────────────────────┐
│    Time     │     Matchup     │    Score/Status     │
├─────────────┼─────────────────┼─────────────────────┤
│ 09:30 AM    │ LAK @ PHI       │ 3 - 2 FINAL OT      │
│ 10:00 AM    │ COL @ DET       │ 5 - 0 FINAL         │
│ 12:30 PM    │ NYR @ PIT       │ 5 - 6 FINAL         │
│ 01:00 PM    │ WPG @ FLA       │ 2 - 1 FINAL         │
│ 01:00 PM    │ SJS @ CGY       │ 2 - 3 FINAL         │
│ 02:00 PM    │ CAR @ WSH       │ 3 - 4 FINAL OT      │
│ 04:00 PM    │ MTL @ BUF       │ 4 - 2 FINAL         │
│ 04:00 PM    │ NJD @ OTT       │ 1 - 4 FINAL         │
│ 04:00 PM    │ NSH @ NYI       │ 4 - 3 FINAL         │
│ 04:00 PM    │ CBJ @ STL       │ 5 - 3 FINAL         │
│ 04:00 PM    │ TOR @ VAN       │ 3 - 2 FINAL SO      │
│ 06:00 PM    │ DAL @ UTA       │ 3 - 2 FINAL         │
│ 07:00 PM    │ MIN @ EDM       │ 7 - 3 FINAL         │
│ 07:00 PM    │ SEA @ VGK       │ 3 - 2 FINAL         │
└─────────────┴─────────────────┴─────────────────────┘
```

#### Future Games (Scheduled)
```
🏒 NHL Hockey Games
📅 Tuesday, February 03, 2026

┌─────────────┬─────────────────┬─────────────────────┐
│    Time     │     Matchup     │    Score/Status     │
├─────────────┼─────────────────┼─────────────────────┤
│ 04:00 PM    │ CBJ @ NJD       │ SCHEDULED           │
│ 04:00 PM    │ WSH @ PHI       │ SCHEDULED           │
│ 04:00 PM    │ OTT @ CAR       │ SCHEDULED           │
│ 04:30 PM    │ BUF @ TBL       │ SCHEDULED           │
│ 04:30 PM    │ PIT @ NYI       │ SCHEDULED           │
│ 05:30 PM    │ TOR @ EDM       │ SCHEDULED           │
│ 07:00 PM    │ SEA @ ANA       │ SCHEDULED           │
└─────────────┴─────────────────┴─────────────────────┘
```

#### Live Games (In Progress)
```
🏒 NHL Hockey Games
📅 Thursday, February 26, 2026
┌─────────────┬─────────────────┬─────────────────────┐
│    Time     │     Matchup     │    Score/Status     │
├─────────────┼─────────────────┼─────────────────────┤
│ 07:00 PM    │ TOR @ VAN       │ 2 - 1 (3rd - 5:30)  │
│ 07:30 PM    │ EDM @ CGY       │ 0 - 0 (2nd - INT)   │
│ 08:00 PM    │ BOS @ MTL       │ 1 - 1 (1st - 15:00) │
│ 08:30 PM    │ NYR @ NJD       │ 3 - 2 (OT - 2:15)   │
└─────────────┴─────────────────┴─────────────────────┘
```

### Game Status Legend

```
📊 Game Status Legend:
  • FINAL - Game completed
  • (1st - 15:00) - Live game: 1st period with 15:00 remaining
  • (2nd - INT) - Live game: 2nd period intermission
  • (3rd - 5:30) - Live game: 3rd period with 5:30 remaining
  • (OT - 2:15) - Overtime period with 2:15 remaining
  • SCHEDULED - Game upcoming (shows as "SCHEDULED")
  • OT - Game ended in overtime
  • SO - Game ended in shootout
```

### Game Status Indicators

| Status        | Description                                                      |
|---------------|-----------------------------------------------------------------|
| **FINAL**      | Game completed with final score                                 |
| **IN PROGRESS**| Game currently being played with period/time details          |
| **SCHEDULED**   | Game upcoming (shows as "SCHEDULED")                             |
| **OT**         | Game ended in overtime                                         |
| **SO**         | Game ended in shootout                                         |

### Live Game Details

When games are in progress, the script shows:
- **Period number**: 1st, 2nd, 3rd, OT
- **Time remaining**: Minutes and seconds left in period
- **Intermission status**: Shows "Intermission" between periods

### Technical Details

#### Data Source
- **API**: `https://sploosh-ai-hockey-analytics.vercel.app/api/nhl/scores`
- **Format**: JSON with comprehensive game information
- **Updates**: Real-time data for live games

#### Timezone Handling
- **Input**: UTC timestamps from API
- **Output**: Pacific Standard Time (UTC-8)
- **Format**: 12-hour format (e.g., "07:00 PM")

#### Dependencies
- **curl**: HTTP requests to NHL API
- **jq**: JSON parsing and data transformation
- **awk**: Table formatting and output

### Integration with Claude Code

This script demonstrates the power of combining:
- **Local Ollama models** (gpt-oss:20b recommended)
- **MCP tools** (fetch_json, search_web)
- **Natural language prompts**: "Show me the NHL games for today"

### Use Cases

#### Business/Client Presentations
- Professional formatting suitable for client reports
- Clear game status information for planning
- Timezone-aware scheduling

#### Personal Use
- Quick game schedule checks
- Live score tracking
- Historical game results

#### Development Examples
- JSON API integration
- Data transformation and formatting
- Shell scripting best practices

## 📁 Directory Structure

```
examples/
├── README.md                           # This file
├── claude-code-telemetry/              # Claude Code telemetry monitoring
│   ├── docker-compose.yml              # Monitoring stack orchestration
│   ├── otel-collector-config.yaml      # OTel Collector configuration
│   ├── prometheus.yml                  # Prometheus configuration
│   ├── grafana/                        # Grafana dashboards and provisioning
│   ├── .env.example                    # Example environment variables
│   └── README.md                       # Telemetry setup documentation
├── docker-vane/                        # Privacy-focused AI search engine
│   ├── docker-compose.yml              # Vane container configuration
│   └── README.md                       # Vane setup documentation
└── scripts/
    └── nhl/
        └── nhl_games.sh                # NHL games script
```

## 🚀 Getting Started

1. **Ensure dependencies**:
   ```bash
   # Check for required tools
   which curl jq awk
   ```

2. **Make script executable**:
   ```bash
   chmod +x examples/scripts/nhl/nhl_games.sh
   ```

3. **Test the script**:
   ```bash
   ./examples/scripts/nhl/nhl_games.sh
   ```

4. **Use NPM scripts** (recommended):
   ```bash
   npm run nhl:today
   npm run nhl:date -- 2026-02-03
   ```

## 🤝 Contributing

Feel free to submit improvements, additional features, or new example scripts! Key areas for enhancement:

- Additional sports leagues
- Custom formatting options
- Notification systems
- Data export capabilities

## 📄 License

This project follows the same license as the main repository.
