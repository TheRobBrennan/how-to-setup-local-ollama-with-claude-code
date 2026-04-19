# gemma4:26b-a4b-it-q8_0 Model Exploration

## Overview

Exploration of the gemma4:26b-a4b-it-q8_0 model with Claude Code on macOS M1 Max (64GB RAM).

## Setup Details

- **Model**: gemma4:26b-a4b-it-q8_0
- **Download Size**: 28GB
- **Architecture**: Mixture of Experts (MoE) — 26B total parameters, 4B active per inference
- **Context Window**: 256K tokens
- **Hardware**: 2021 14" MacBook Pro, M1 Max, 64GB RAM
- **Software**: Ollama v0.15+, Claude Code v2+

## Why This Model

Gemma 4 is Google DeepMind's frontier-level model family. The 26B MoE variant offers an excellent balance:
- **Efficiency**: Only 4B parameters are active per forward pass (MoE architecture)
- **Quality**: 26B total parameters means high-quality reasoning and output
- **Context**: 256K token context window — far larger than most local models
- **Capability**: Native function-calling support, strong agentic workflow performance

The `q8_0` quantization preserves near-full model quality at 28GB — fitting well within 64GB unified memory with ~36GB headroom for the OS and other processes.

## Quick Start

```bash
# First-time setup: pull base model and create configured local model (~28GB download)
npm run model:create:gemma4

# Check for configured model (creates it if missing) then launch Claude Code
npm run start:gemma4

# Launch directly (skips check, use when model is already created)
npm run launch:gemma4

# Or run the ollama command directly
ollama launch claude --model gemma4-26b
```

## Configuration

### Modelfile Parameters (`modelfiles/gemma4-26b.Modelfile`)

The configured model `gemma4-26b` is created from `gemma4:26b-a4b-it-q8_0` with these baked-in parameters:

- `temperature=1.0`
- `top_k=40`

### Server-Level Settings (environment variables)

`flash_attention` and `kv_cache_quant` are Ollama server settings — they must be set **before starting the Ollama server**, not at launch time. Add to your shell profile and restart Ollama:

```bash
echo 'export OLLAMA_FLASH_ATTENTION=1' >> ~/.zshrc
echo 'export OLLAMA_KV_CACHE_TYPE=q8_0' >> ~/.zshrc
source ~/.zshrc
# Restart Ollama from the menu bar, or:
killall ollama && ollama serve
```

## Initial Performance Notes

### Startup
- [ ] Model loaded successfully
- [ ] Startup time for 28GB model
- [ ] Interface responsive after launch

### Resource Usage
- **RAM Usage**: TBD (monitor during active use — expect ~28-32GB with KV cache)
- **Storage**: 28GB downloaded model
- **CPU/GPU**: TBD — M1 Max Neural Engine expected to accelerate inference

## Capabilities to Test

### Coding Tasks
- [ ] Code generation and completion
- [ ] Code review and refactoring
- [ ] Debugging assistance
- [ ] Multi-language support

### Advanced Reasoning
- [ ] Multi-step reasoning tasks
- [ ] Architectural planning
- [ ] Agentic workflows (multi-tool use)
- [ ] Long-context document understanding (256K window)

### MCP Tool Integration
- [ ] Web search tool execution
- [ ] Fetch tool execution
- [ ] Combined multi-tool workflows

### Performance Comparison
- [ ] Response speed vs gpt-oss:20b
- [ ] Response speed vs qwen2.5-coder:7b
- [ ] Quality of reasoning responses
- [ ] Context handling at large context lengths
- [ ] MCP tool reliability

## Trade-offs

### Advantages
- Frontier-level reasoning and agentic capabilities
- 256K context window (vs 128K or less for other local models)
- Native function-calling support — MCP tools expected to work
- MoE efficiency: only 4B active params per forward pass despite 26B total
- Near full-quality output from q8_0 quantization

### Disadvantages
- 28GB download and storage footprint
- Higher RAM usage than smaller models
- Slower response times than qwen2.5-coder:7b
- Requires 32GB+ RAM (64GB recommended for comfortable headroom)

## Findings

This section will be updated as we explore the model's capabilities.

### Initial Setup
- ✅ Easy setup with npm scripts (`npm run start:gemma4`)
- ✅ Local-only operation confirmed via `/status` — `Anthropic base URL: http://127.0.0.1:11434`
- ✅ Model confirmed: `gemma4:26b-a4b-it-q8_0`
- ⚠️ Claude Code UI shows "API Usage Billing" and "Opus 4.7 xhigh" banners — these are **static UI strings** in v2.1.114, not indicative of cloud billing
- ⚠️ Windsurf IDE extension install fails with `ERR_STREAM_PREMATURE_CLOSE` — cosmetic only, core functionality works fine
