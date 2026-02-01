# 🚀 Web Search Quick Start Guide

Get web search working with your local Claude Code in under 5 minutes!

## One-Command Setup

```bash
npm run setup:web-search
```

This will guide you through setting up completely free web search (no API keys required).

## What Gets Installed

### Option 1: Fetch MCP Server (Recommended)

- **What it does**: Fetches and reads content from any URL
- **Best for**: Reading documentation, articles, GitHub files
- **Example**: "Fetch content from <https://docs.python.org/3/whatsnew/3.13.html>"

### Option 2: Simple Python Search

- **What it does**: Searches DuckDuckGo for information
- **Best for**: Finding current information, research
- **Example**: "Search the web for latest TypeScript features"

### Option 3: Both

Get the full experience - fetch URLs and search the web!

## Quick Test

After setup, launch Claude Code:

```bash
npm start
```

Try these commands:

```
/mcp
```

Check that your MCP servers are connected, then try:

```
Search the web for "Python 3.13 new features"
```

or

```
Fetch the content from https://github.com/ollama/ollama
```

## Managing MCP Servers

```bash
# List all servers
npm run mcp:list

# Or use Claude CLI directly
claude mcp list

# Remove a server
claude mcp remove fetch
claude mcp remove simple-search

# Reset ALL servers (clean slate)
npm run reset:mcp
```

## Troubleshooting

### Server Not Found

```bash
# Re-run setup
npm run setup:web-search
```

### Python Not Found

```bash
# Install Python 3
brew install python3
```

### Node.js Not Found

```bash
# Install Node.js
brew install node
```

## Need More Help?

See the complete guide: [`free-web-search-setup.md`](free-web-search-setup.md)

## Key Features

- ✅ **100% Free** - No API keys, no subscriptions
- ✅ **Privacy-Focused** - Everything runs locally
- ✅ **Works with Local Models** - Use with qwen2.5-coder:7b or gpt-oss:20b
- ✅ **No Rate Limits** - Search as much as you need
- ✅ **Easy Setup** - One command to get started

---

**That's it!** You now have web search capabilities with your completely free, local Claude Code setup.
