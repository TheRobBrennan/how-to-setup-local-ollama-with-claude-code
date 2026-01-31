# gpt-oss:20b Model Exploration

## Overview

Exploration of the gpt-oss:20b model with Claude Code on macOS M1 Max (64GB RAM).

## Setup Details

- **Model**: gpt-oss:20b
- **Download Size**: 13GB
- **Hardware**: 2021 14" MacBook Pro, M1 Max, 64GB RAM
- **Software**: Ollama v0.15.2, Claude Code v2.1.27
- **Date**: 2026-01-30

## Initial Performance Notes

### Startup
- ✅ Model loaded successfully
- ✅ Reasonable startup time for 13GB model
- ✅ Interface responsive immediately after launch

### Resource Usage
- **RAM Usage**: TBD (need to monitor during active use)
- **Storage**: 13GB downloaded model
- **CPU**: Initial loading uses significant CPU, then stabilizes

## Capabilities to Test

### Coding Tasks
- [ ] Code generation and completion
- [ ] Code review and refactoring
- [ ] Debugging assistance
- [ ] Multi-language support

### Beyond Coding
- [ ] Documentation generation
- [ ] Architectural planning
- [ ] Code explanation
- [ ] Technical writing

### Performance Comparison
- [ ] Response speed vs qwen2.5-coder:7b
- [ ] Quality of responses
- [ ] Context handling
- [ ] Memory efficiency

## Usage Commands

```bash
# Start with gpt-oss:20b
npm run start:gpt-oss

# Or directly
ollama launch claude --model gpt-oss:20b
```

## Trade-offs

### Advantages
- Larger model (20B parameters vs 7B)
- Broader capabilities beyond coding
- Potentially higher quality responses

### Disadvantages
- Larger storage footprint (13GB vs 4.7GB)
- Higher RAM usage
- Potentially slower response times
- More resource intensive

## Findings

This section will be updated as we explore the model's capabilities

### Initial Setup
- ✅ Easy setup with existing npm scripts
- ✅ No configuration issues
- ✅ Local-only operation confirmed
