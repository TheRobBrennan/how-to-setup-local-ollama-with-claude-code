# Docker Vane Example

This example demonstrates how to run [Vane](https://github.com/ItzCrazyKns/Vane), a privacy-focused AI search engine, with local Ollama on macOS using Docker Compose.

## What is Vane?

Vane is the privacy-focused successor of Perplexica, an open-source AI answering engine. It uses:
- **SearxNG** for web searches (bundled in the Docker image)
- **Local Ollama** for the LLM reasoning
- **Source citations** for every claim, allowing verification

## Privacy Benefits

With Vane and Ollama:
- Your query goes from browser to Vane (local Docker container)
- Vane sends search to SearxNG (local), which proxies to public search engines
- Vane sends reasoning to Ollama (local)
- Only the search keywords leave your PC (stripped of identifying headers by SearxNG)
- No chat history is uploaded anywhere
- No API keys to leak

## Prerequisites

1. **Docker Desktop** for macOS - [Download](https://www.docker.com/products/docker-desktop/)
2. **Ollama** installed and running on macOS
3. **qwen3.5:9b** model pulled in Ollama

## Quick Start

### 1. Pull the qwen3.5:9b model

```bash
npm run check:qwen3.5
```

Or manually:
```bash
ollama pull qwen3.5:9b
```

### 2. Ensure Ollama is exposed to network

Open Ollama app settings and enable "Expose Ollama to the network". This allows Docker containers to reach it.

### 3. Start Vane with Docker Compose

```bash
npm run docker:vane:up
```

This will:
- Pull the Vane Docker image (~1 GB)
- Start the container on port 3000
- Create a persistent volume for settings and search history
- Configure it to connect to Ollama at `http://host.docker.internal:11434`

### 4. Access Vane

Open <http://localhost:3000> in your browser.

### 5. Configure Vane to use Ollama

On first launch or in Settings:
1. Set connection type to **Ollama**
2. Set Base URL to `http://host.docker.internal:11434`
3. Click **Add Connection**
4. Select **qwen3.5:9b** as the chat model
5. (Optional) Select an embedding model or reuse qwen3.5:9b

## NPM Scripts

```bash
# Start Vane container
npm run docker:vane:up

# Stop Vane container
npm run docker:vane:down

# Restart Vane container
npm run docker:vane:restart

# View Vane logs
npm run docker:vane:logs
```

## Using Vane

Vane has three search modes:
- **Speed Mode**: Quick lookups (e.g., "what's the capital of France")
- **Balanced Mode**: Everyday default with sources
- **Quality Mode**: Deep research with more searches and pages

You can also scope searches to:
- Web
- Academic
- Social

## Troubleshooting

### Ollama connection error

If Vane cannot reach Ollama:
1. Verify Ollama is running: `curl http://localhost:11434/api/tags`
2. Ensure "Expose Ollama to the network" is enabled in Ollama settings
3. Test from inside container: `docker exec -it vane curl http://host.docker.internal:11434/api/tags`

### SearxNG returns no results

If queries return "no sources found":
1. Restart the container: `npm run docker:vane:restart`
2. If issues persist, consider running a separate SearxNG instance

### Ollama is slow

Check if Ollama is using GPU:
```bash
ollama ps
```
Should show 100% GPU. If showing CPU, your GPU may not have enough VRAM.

## Model Selection

- **qwen3.5:9b**: Good middle ground for research work (5-6 GB)
- **qwen3.5:4b**: Smaller variant for less VRAM
- **qwen3.5:2b**: Even smaller for constrained hardware
- **qwen3.5:27b/35b/122b**: Larger variants for more powerful hardware

## Additional Resources

- [Vane GitHub](https://github.com/ItzCrazyKns/Vane)
- [Vane Installation Docs](https://github.com/ItzCrazyKns/Vane/tree/master/docs/installation)
- [Ollama](https://ollama.com/)
- [Qwen3.5 Model Card](https://ollama.com/library/qwen3.5)
- [SearxNG Docs](https://docs.searxng.org/)
