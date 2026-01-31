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
3. **Status check**: Run `claude /status` – it will report the API‑side default model (`claude-sonnet-4-5-…`) but the model actually used locally is the one you specified. The local model runs without billing.

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

### Troubleshooting
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

## � Available Scripts

This project includes npm scripts to simplify working with Ollama models:

### Quick Start Scripts

**Start with qwen2.5-coder:7b (default):**
```bash
npm start
```

**Start with gpt-oss:20b:**
```bash
MODEL=gpt-oss npm start
```

### Model-Specific Scripts

**qwen2.5-coder:7b:**
- `npm run check:qwen` - Check if model exists, download if missing
- `npm run start:qwen` - Check for model and start Claude Code

**gpt-oss:20b:**
- `npm run check:gpt-oss` - Check if model exists, download if missing
- `npm run start:gpt-oss` - Check for model and start Claude Code

### Testing

- `npm test` - Run workflow tests
- `npm run test:workflows` - Test GitHub Actions locally with act

## 📚 Additional Documentation

For more detailed information about this project:

- [GitHub Actions Setup](docs/github-setup.md) - Configure workflows and permissions
- [Testing Workflows](docs/testing-workflows.md) - Test GitHub Actions locally with act
- [Container Management](docs/act-container-management.md) - Docker container cleanup
- [Claude Co-Author Management](docs/claude-coauthor-management.md) - Control "co-authored by Claude" attribution
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to this project

## 🤝 Contributing

We welcome contributions! All commits must be GPG signed and follow the [conventional commit](https://www.conventionalcommits.org/) format. See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions.

## 🙏 Acknowledgments

- [Joe Njenga](https://medium.com/@joe.njenga) for the original Medium article
- [Ollama](https://ollama.ai/) for making local LLMs accessible
- [Anthropic](https://www.anthropic.com/) for Claude Code
