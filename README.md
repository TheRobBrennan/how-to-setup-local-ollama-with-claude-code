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

- macOS (this guide was verified on Tahoe 26.2, but other versions should work)
- Basic familiarity with terminal/command line

## 🚦 Quick Start

The new `ollama launch` command (v0.15+) handles all configuration automatically. No more manual environment variable setup!

### Step 1: Update Ollama

Ensure you have Ollama v0.15 or later:

```bash
# Check your version
ollama --version
```

If you need to update, download the latest from [ollama.com/download](https://ollama.com/download).

### Step 2: Install Claude Code

For macOS, Linux, or WSL:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

After installation, restart your terminal and verify:

```bash
claude --version
```

### Step 3: Pull a Coding Model

For this guide, we're using a local model that runs entirely on your MacBook Pro:

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
- `gpt-oss:20b` (~12GB) - Larger general-purpose model
- `starcoder2:3b` (~1.7GB) - Compact coding model

**Note:** Cloud models are also available (e.g., `glm-4.7:cloud`) but require an [Ollama Cloud account](https://ollama.com/cloud).

### Step 4: Configure Context Length (Local Models Only)

**Important:** For local models, increase the context length from the default 4,096 to 64,000 tokens.

Open Ollama's settings and update the context length to at least 64,000 tokens. This is required for multi-file operations and tool calls.

**Note:** Cloud models automatically run at full context length, so you can skip this step if using cloud models.

### Step 5: Launch Claude Code

Simply run:

```bash
ollama launch claude
```

That's it! The `launch` command will:
- Set up all environment variables automatically
- Present a model selection menu
- Launch Claude Code with your chosen model

You can also specify the model directly:

```bash
ollama launch claude --model qwen2.5-coder:7b
```

Claude Code will start and connect to your local Ollama instance, running the `qwen2.5-coder:7b` model entirely on your MacBook Pro.

## 📚 Additional Documentation

For more detailed information about this project:

- [GitHub Actions Setup](docs/github-setup.md) - Configure workflows and permissions
- [Testing Workflows](docs/testing-workflows.md) - Test GitHub Actions locally with act
- [Container Management](docs/act-container-management.md) - Docker container cleanup
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to this project

## 🤝 Contributing

We welcome contributions! All commits must be GPG signed and follow the [conventional commit](https://www.conventionalcommits.org/) format. See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions.

## 🙏 Acknowledgments

- [Joe Njenga](https://medium.com/@joe.njenga) for the original Medium article
- [Ollama](https://ollama.ai/) for making local LLMs accessible
- [Anthropic](https://www.anthropic.com/) for Claude Code
