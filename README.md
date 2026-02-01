# 🚀 Setup Local Ollama with Claude Code on macOS

Complete guide to setting up Claude Code with free local Ollama on macOS - no API keys, no billing.

## 💡 Inspiration

This guide was inspired by Joe Njenga's Medium articles on using Ollama with Claude Code:

- [I Tried New Claude Code Ollama Workflow (It's Wild & Free)](https://medium.com/@joe.njenga/i-tried-new-claude-code-ollama-workflow-its-wild-free-cb7a12b733b5) - The original guide that inspired this repository
- [I Tested (New) Ollama Launch For Claude Code, Codex, OpenCode (No More Configs)](https://medium.com/ai-software-engineer/i-tested-new-ollama-launch-for-claude-code-codex-opencode-more-bfae2af3c3db) - The updated guide using the simplified `ollama launch` command

The `ollama launch` command eliminates manual configuration and makes setup incredibly simple.

## 🖥️ Development Environment

This guide was developed and tested on:
- **Device**: 2021 14" MacBook Pro
- **Processor**: Apple M1 Max
- **RAM**: 64 GB
- **OS**: macOS Tahoe 26.2

## 🛠️ Prerequisites

Before you begin, you'll need:

- **macOS 14 Sonoma or later** (required for Ollama)
- Basic familiarity with terminal/command line

## 🚦 Quick Start

The new `ollama launch` command (v0.15+) handles all configuration automatically. No more manual environment variable setup!

### Step 1: Update Ollama

Ensure you have Ollama v0.15 or later:

```bash
# Check your version
ollama --version
```

If you need to update, download the latest from [ollama.com/download](https://ollama.com/download) (~104.3 MB for macOS).

### Step 2: Install Claude Code

For macOS, Linux, or WSL:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

After installation, restart your terminal and verify:

```bash
claude --version
```

**Important**: Add Claude Code to your PATH (if prompted during installation):

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

### Step 3: Pull a Coding Model

For this guide, we're using a local model that runs entirely on your local machine:

```bash
ollama pull qwen2.5-coder:7b
```

**About this model:**
- Trained specifically for coding tasks
- Handles typical coding tasks like building REST APIs, writing functions, and understanding code structure
- When modifying existing code, it references what's already there and makes integrated changes
- Size: ~4.7GB download

**Other local model options:**
- `qwen3-coder` (~18GB) - Larger, more capable coding model
- `starcoder2:3b` (~1.7GB) - Compact coding model

**Note:** Cloud models are also available (e.g., `glm-4.7:cloud`) but require an [Ollama Cloud account](https://ollama.com/cloud).

#### Experimenting with Larger Models

For more complex tasks, you might want to try `gpt-oss:20b`, a larger general-purpose model:

```bash
ollama pull gpt-oss:20b
```

Run it with:

```bash
ollama launch claude --model gpt-oss:20b
```

**About this model:**
- Handles a wider range of tasks beyond just coding — documentation generation, code review, and architectural planning
- Size: ~12GB download
- **Trade-off:** Uses more RAM and processes tokens more slowly than smaller models
- **Performance:** Unknown how well it will perform on this hardware setup - experimentation needed

### Step 4: Configure Context Length (Local Models Only)

**⚠️ IMPORTANT**: The context length configuration in the README may not work as expected. The `ollama launch` command should handle this automatically, but if you encounter issues, see the troubleshooting section below.

**Note:** Cloud models automatically run at full context length, so you can skip this step if using cloud models.

### Step 5: Launch Claude Code

**⚠️ CRITICAL**: Always specify the model explicitly to avoid accidentally using cloud models:

```bash
ollama launch claude --model qwen2.5-coder:7b
```

**Do NOT use** `ollama launch claude` without specifying a model, as it may default to cloud models and incur billing charges.

The `launch` command will:
- Set up all environment variables automatically
- Launch Claude Code with your specified local model

Claude Code will start and connect to your local Ollama instance, running the `qwen2.5-coder:7b` model entirely on your local machine.

## 🌐 Free Web Search (Optional)

Get real-time web search and URL fetching capabilities without any API keys or billing!

### ⚠️ Important: Model Requirements

**MCP tools only work with gpt-oss:20b model**
- ✅ **gpt-oss:20b**: Can execute web search and fetch commands
- ❌ **qwen2.5-coder:7b**: Recognizes tool calls but cannot execute them

### Quick Setup

```bash
npm run setup:web-search
```

This interactive script will help you set up:
- **Fetch MCP Server**: Fetch and read content from any URL
- **Simple Python Search**: Search DuckDuckGo for current information
- **Both**: Get the full web browsing experience

### What You Can Do

Once configured, Claude Code can:
- Search the web for current information
- Fetch and read documentation from URLs
- Access real-time data beyond its training cutoff
- Research topics and summarize findings

### Example Usage

```
"Search the web for latest TypeScript 5.4 features"
"Fetch content from https://docs.python.org/3/whatsnew/3.13.html"
"What are the current best practices for React Server Components?"
```

### Pro Tips for Local Models

**Use these phrases to trigger MCP tools:**
- "Search the web for..." → Uses local DuckDuckGo search
- "Fetch the JSON from..." → Uses local JSON fetcher
- "Get the HTML content from..." → Uses local HTML fetcher
- "Use the search tool to find..." → Explicit MCP usage

**Available MCP Tools:**
- `search_web` - DuckDuckGo web search
- `fetch_json` - Fetch JSON from URLs
- `fetch_html` - Fetch HTML from URLs  
- `fetch_markdown` - Fetch and convert to Markdown
- `fetch_txt` - Fetch plain text from URLs

### 🏒 Example: fetch_json with NHL Scores

Test your `fetch_json` tool with this comprehensive example:

```bash
# Ask Claude to:
Fetch JSON from https://sploosh-ai-hockey-analytics.vercel.app/api/nhl/scores?date=2026-01-31 and for each unique entry in the games array (unique by id): convert startTimeUTC to Pacific Standard Time (UTC-8) → HH:MM AM/PM, create matchup string as awayTeam.abbrev vs homeTeam.abbrev, determine score/status (if gameState is OFF, FINAL, or gameOutcome.lastPeriodType is REG or gameOutcome.otPeriods > 0: use awayTeam.score – homeTeam.score; if gameState is LIVE or CRIT: show current score + (live); append (OT) if lastPeriodType == OT or otPeriods > 0; append (SO) if lastPeriodType == SO), sort rows by converted start time, and render a markdown table with columns: Time (PST), Match-up, Score / Status
```

**Expected Output:** A formatted table showing:
- Game times converted to Pacific Standard Time (PST)
- Games sorted chronologically from earliest to latest
- Complete game information including teams, scores, and game status
- All JSON data returned without truncation (94,733+ characters supported)

**Sample Output:**
```
| Time (PST)   | Match-up     | Score / Status     |
|--------------|--------------|--------------------|
| 9:30 AM      | LAK vs PHI   | 3 – 2 (final) (OT) |
| 10:00 AM     | COL vs DET   | 5 – 0 (final)      |
| 12:30 PM     | NYR vs PIT   | 5 – 6 (final)      |
| ...          | ...          | ...                |
```

This example verifies that:
- ✅ The `fetch_json` tool returns complete JSON data (no 5000-char limit)
- ✅ Large API responses are handled properly
- ✅ Time zone conversions work correctly
- ✅ Data sorting and formatting functions as expected

**Avoid these phrases (trigger built-in tools):**
- "Web search for..." → Tries to use Anthropic's WebSearch
- "Can you search online..." → May trigger cloud tools

### Learn More

See the complete guide: [`docs/free-web-search-setup.md`](docs/free-web-search-setup.md)

**Key Benefits:**
- ✅ 100% Free - No API keys required
- ✅ Privacy-focused - Runs on your local machine
- ✅ Works with local Ollama models
- ✅ No rate limits or subscriptions

### Troubleshooting

**MCP Server Shows "Failed" During Searches:**
- This is normal during heavy usage - servers recover automatically
- Caused by network timeouts or rate limiting from DuckDuckGo
- Solution: Wait a moment between searches or run `npm run reset:mcp` to restart

**Server Not Responding:**
```bash
# Check server status
npm run mcp:list

# Restart servers
npm run reset:mcp && npm run setup:web-search
```

## 🔌 IDE Integration

Claude Code works standalone but also integrates with popular IDEs:

### VS Code
Install the official Claude Code extension from the VS Code marketplace

### Windsurf/Cursor
Claude Code should integrate automatically - if you see "IDE disconnected" messages, the core functionality still works with local models

### Other IDEs
Check the [Claude Code documentation](https://docs.anthropic.com/claude/docs/claude-code) for additional integration options

**Note**: IDE integration is optional - Claude Code works perfectly fine from the terminal with local Ollama models.

## ✅ Verify Local-Only Setup

To confirm you're using local models (no cloud billing):

1. **Check the model name**: Look for your local model name (e.g., `qwen2.5-coder:7b` or `gpt-oss:20b`) in Claude Code's interface
2. **No auth conflicts**: You should NOT see authentication conflict warnings
3. **Status check**: Run `/status` within Claude Code – it will show your current configuration. Here's example output for a local setup:

```
Version: 2.1.27
Session name: /rename to add a name
Session ID: 51c15324-528f-4dbf-b613-ae5934ed3000
cwd: /Users/rob/repos/how-to-setup-local-ollama-with-claude-code
Auth token: ANTHROPIC_AUTH_TOKEN
Anthropic base URL: http://localhost:11434

Model: gpt-oss:20b
Memory:
Setting sources: Shared project settings
```

The status shows your local model (e.g., `gpt-oss:20b`) and localhost URL, confirming local-only operation.

**Correct local setup shows:**
- Model: `qwen2.5-coder:7b` (or other local model)
- No authentication warnings
- Token usage: **"↑ 0 tokens"** (confirming no cloud billing)
- Optional: "/model to try Opus 4.5" (means you can switch to cloud, but aren't currently)

**Incorrect cloud setup shows:**
- Model: `claude-sonnet-4-5-20250929` or similar
- Auth conflict warnings
- Active API key usage
- Token usage showing actual token counts (being billed)

### Cloud Model Troubleshooting
If you see cloud models being used:
```bash
# Clear Anthropic credentials
claude /logout
unset ANTHROPIC_AUTH_TOKEN

# Relaunch with EXPLICIT model specification
ollama launch claude --model qwen2.5-coder:7b
```

**⚠️ Always use `--model` parameter** - `ollama launch claude` without a model may default to cloud models and incur charges!

**Common Issues:**
- **"Sonnet 4.5" appears**: You're using cloud models, not local
- **"Missing API key"**: Claude Code wants Anthropic credentials
- **"API Usage Billing"**: Likely using cloud services
- **Solution**: Always specify `--model qwen2.5-coder:7b` (or other local model)

### ⚠️ DANGER: /model Command
- You may see `/model to try Opus 4.5` in the interface
- **DO NOT type `/model`** - this will switch you to paid cloud models
- This is an upsell mechanism that can lead to unexpected billing
- If you accidentally switch to cloud, use the logout steps above immediately

## 🤖 Available Models

**gpt-oss:20b (Recommended for MCP Tools)**
- **Size**: 11GB | **Speed**: Slower | **RAM**: 16GB+ | **MCP Tools**: ✅ **Works**
- **Best For**: Web search, fetching, general tasks

**qwen2.5-coder:7b (Coding Focus)**
- **Size**: 4.7GB | **Speed**: Fast | **RAM**: 8GB+ | **MCP Tools**: ⚠️ **Limited**
- **Best For**: Coding, programming tasks

### gpt-oss:20b (Recommended for MCP Tools)
- **Size**: 11GB
- **Speed**: Slower but more capable
- **Quality**: Higher reasoning capability
- **Specialization**: General purpose with better tool execution
- **RAM**: 16GB+ recommended
- **✅ MCP Tools**: Can execute web search and fetch commands

### qwen2.5-coder:7b (Coding Focus)
- **Size**: 4.7GB
- **Speed**: Fast
- **Quality**: Excellent for coding
- **Specialization**: Optimized for programming tasks
- **RAM**: 8GB+ recommended
- **⚠️ MCP Tools**: Recognizes tool calls but cannot execute them

## � Available Scripts

This project includes npm scripts to simplify working with Ollama models:

### Quick Start Scripts

**Start with gpt-oss:20b (recommended for MCP tools):**
```bash
npm run start:gpt-oss
```

**Start with qwen2.5-coder:7b (coding focus):**
```bash
npm start
```

**Choose model at runtime:**
```bash
npm start                    # Uses qwen by default
MODEL=qwen npm start         # Explicit qwen
MODEL=gpt-oss npm start      # Uses gpt-oss
```

### Model-Specific Scripts

**qwen2.5-coder:7b:**
- `npm run check:qwen` - Check if model exists, download if missing
- `npm run start:qwen` - Check for model and start Claude Code

**gpt-oss:20b:**
- `npm run check:gpt-oss` - Check if model exists, download if missing
- `npm run start:gpt-oss` - Check for model and start Claude Code

### Web Search Setup

- `npm run setup:web-search` - Interactive setup for free web search (no API keys)
- `npm run reset:mcp` - Remove all MCP servers for this project
- `npm run mcp:list` - List all configured MCP servers
- `npm run mcp:status` - Check MCP server status

### Testing

- `npm test` - Run workflow tests
- `npm run test:workflows` - Test GitHub Actions locally with act

- [Joe Njenga](https://medium.com/@joe.njenga) for the original Medium article
- [Ollama](https://ollama.ai/) for making local LLMs accessible
- [Anthropic](https://www.anthropic.com/) for Claude Code

## 📚 Additional Documentation

- [`docs/free-web-search-setup.md`](docs/free-web-search-setup.md) - Complete guide for free web search
- [`docs/web-search-quick-start.md`](docs/web-search-quick-start.md) - Quick reference guide
- [`docs/act-container-management.md`](docs/act-container-management.md) - GitHub Actions testing
- [`docs/claude-coauthor-management.md`](docs/claude-coauthor-management.md) - Claude coauthor setup
- [`docs/github-setup.md`](docs/github-setup.md) - GitHub integration
- [`docs/gpt-oss-20b-exploration.md`](docs/gpt-oss-20b-exploration.md) - GPT-OSS model exploration
