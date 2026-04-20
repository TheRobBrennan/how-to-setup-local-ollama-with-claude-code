# Claude Code Local Ollama Setup

## Project Overview

This repository is a **template** for setting up **Claude Code** to run locally with **Ollama** models on macOS.  It provides scripts, documentation, and example workflows so you can start using Claude Code without API keys or cloud billing.

Key goals:
- Run Claude Code entirely on your machine.
- Use local Ollama models (e.g., `qwen2.5-coder:7b`, `gemma4-26b`, `gpt-oss:20b`).
- Add free web‑search/MCP functionality without external keys.
- Provide a clean npm‑based workflow for model management, server config, and testing.

## Repository Structure

```
├── .claude                # Claude Code settings (permissions, attribution)
├── docs                    # Markdown guides and docs
├── examples                # Reproducible scripts (e.g., NHL schedule)
├── modelfiles              # Ollama Modelfiles for custom models
├── package.json            # npm scripts for all common tasks
├── scripts                 # Helper scripts (reset‑mcp‑servers, etc.)
├── .github                 # GitHub Actions CI & workflow tests
├── CLAUDE.md               # This file – project‑level instructions
└── README.md               # High‑level guide
```

### Important Folders
- **`docs/`** – Contains step‑by‑step guides such as *Free Web Search Setup*, *Web‑Search Quick Start*, *Testing & Development Setup*, *MCP‑Server management*, and model‑specific exploration.
- **`examples/`** – Example scripts (e.g., NHL schedule) that demonstrate how to invoke npm scripts from within Claude Code.
- **`modelfiles/`** – Modelfiles used by `ollama create` for custom‑configured models.
- **`scripts/`** – Bash helpers like `reset-mcp-servers.sh`.

## NPM Scripts

Run `npm run <script>` or use the aliases in `package.json`.  All scripts are grouped by function.

| Category | Script | Description |
|----------|--------|-------------|
| **Claude Code** | `claude:install` | Install the CLI. |
| | `claude:remove` | Remove the CLI. |
| | `claude:update` | Update to latest CLI. |
| **Model Management** | `check:<model>` | Pull the base model if missing. |
| | `start:<model>` | Pull/check and launch Claude Code with the model. |
| | `launch:<model>` | Directly launch if the model already exists. |
| | `model:build:<model>` | Build custom model from Modelfile then launch. |
| | `model:create:<model>` | Create a custom model from a base Modelfile. |
| | `model:remove:<model>` | Remove a custom model. |
| **Server / MCP** | `setup:web-search` | Interactive setup of free web‑search MCP servers. |
| | `reset:mcp` | Remove all MCP servers. |
| | `mcp:list` | List configured MCP servers. |
| | `mcp:status` | Quick status helper. |
| **Container / Testing** | `test` | Run all tests & GitHub Actions locally. |
| | `test:workflows` | Only run GitHub‑Actions workflow tests via `act`. |
| **Miscellaneous** | `npm start` | Default script; launches Claude Code with the default model (`qwen2.5-coder:7b`). |
| | `npm run start:gpt-oss` | Quick launch with `gpt-oss:20b`. |
| | `npm run ollama:restart` | Restart the Ollama server with optimized env vars. |
| | `nhl:date`, `nhl:today` | Example script to fetch NHL schedules. |

### How to Use
1. **Choose a model** – Run `npm run start:<model>` or `npm run launch:<model>`.
2. **Add MCP (web‑search)** – `npm run setup:web-search`.
3. **Verify** – In Claude Code, type `/mcp` and run a test query.

## Local Ollama Setup

### Installing Ollama

Download and install the latest release from [ollama.com/download](https://ollama.com/download) (~104 MB for macOS). Ensure you have **v0.15 or later** for the `ollama launch` command used by this project.

### Pulling and Creating Models
Use the npm scripts.  For example:
```bash
npm run check:qwen      # Pull qwen2.5-coder:7b if missing
npm run start:qwen      # Check & launch
```
Or create a custom variant:
```bash
npm run model:create:gemma4
npm run model:build:gemma4
```
The Modelfile is located in `modelfiles/gemma4-26b.Modelfile`.

### Optimizing the Ollama Server
The `ollama:restart` script sets `OLLAMA_FLASH_ATTENTION=1` and `OLLAMA_KV_CACHE_TYPE=q8_0` before restarting Ollama.  These settings boost performance for local inference.

## Web‑Search and MCP

Claude Code uses the **Model Context Protocol (MCP)** to perform web search and fetch operations locally.

1. **Setup** – `npm run setup:web-search` will install the fetch‑MCP server and optionally a simple DuckDuckGo search server.
2. **Configuration** – The chosen MCP servers are added with `claude mcp add …` commands executed during setup.
3. **Permissions** – `.claude/settings.json` already allows `fetch_*` MCP tools and denies generic `WebSearch`/`WebFetch`.
4. **Testing** – After launch, type `/mcp` in Claude Code and run:
   ```bash
   Search the web for "latest TypeScript 5.4 features"
   Fetch the content from https://github.com/ollama/ollama
   ```

## Development Guidelines

| Topic | Rule | Why |
|-------|------|-----|
| **Commit messages** | Conventional‑commit style (`feat:`, `fix:`, `chore:`). | Keeps history readable and CI checks pass. |
| **Co‑author attribution** | Disabled by default (`gitAttribution: false`). | Avoids unwanted `Co‑authored‑by` trailers. |
| **Testing** | Run `npm run test` before pushing. | Validates GitHub Actions workflows locally. |
| **MCP server cleanup** | `npm run reset:mcp` removes stale servers. | Keeps local environment clean. |
| **Docker usage** | Required only for local Actions tests. | `act` needs Docker. |

## MCP and Model Requirements

- **`gpt-oss:20b`** – Full MCP support (search & fetch).
- **`gemma4-26b`** – MCP‑compatible, best for complex reasoning and agentic workflows.
- **`gemma4-e4b`** – MCP‑compatible, faster and lighter than `gemma4-26b`.
- **`qwen2.5-coder:7b`** – Recognizes MCP calls but cannot execute them; use `gpt-oss` for web tasks.
- **Permissions** – `.claude/settings.json` allows `mcp__fetch__*` and `mcp__simple-search__search_web`.  It denies generic `WebFetch`/`WebSearch` to force MCP usage.

## Testing & CI

The repository includes GitHub Actions to:
- Validate PR titles.
- Automate version bumps.
- Clean up GitHub Container Registry.

Locally, you can run the same tests with:
```bash
npm run test:workflows
```
This uses `act` and requires Docker Desktop.

## Attribution & Permissions

- **Co‑author attribution** is turned off by default (see `.claude/settings.json`).
- The file also demonstrates how to enable or customize attribution if desired.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| MCP server not starting | Verify Node.js and Python are installed.  Re‑run `npm run setup:web-search`. |
| `claude` command not found | Add `~/.local/bin` to `PATH` (`export PATH="$HOME/.local/bin:$PATH"`). |
| Stale Docker containers from `act` | Manually stop and remove containers via `docker ps -a` and `docker rm`. |
| Using a cloud model accidentally | Always specify `--model` when launching: `ollama launch claude --model <model>`. |

---

For more details, see the individual docs in the `docs/` folder or the `README.md` at the repo root.
