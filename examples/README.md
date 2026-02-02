# Examples Directory

This directory contains example scripts and demonstrations for the "How to Setup Local Ollama with Claude Code" project.

## 🏒 NHL Games Script

### Overview
The NHL Games script (`scripts/nhl/nhl_games.sh`) provides professional, client-ready display of NHL hockey games with real-time scores and scheduling information.

### Features
- **Professional Formatting**: Unicode table borders with clean presentation
- **Date Flexibility**: Show games for any date (past, present, or future)
- **Real-time Status**: FINAL, IN PROGRESS, SCHEDULED game states
- **Live Game Details**: Period number, time remaining, intermission status
- **Timezone Support**: All times displayed in Pacific Standard Time (PST)
- **Comprehensive Legend**: Clear explanations of all game status indicators

### Usage

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
├── README.md                    # This file
└── scripts/
    └── nhl/
        └── nhl_games.sh         # NHL games script
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
