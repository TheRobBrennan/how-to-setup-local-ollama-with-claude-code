# 🆓 Free Web Search for Claude Code (No API Keys Required)

This guide shows you how to add completely free web search capabilities to your local Claude Code setup without any API keys or paid services.

## 🎯 What You'll Get

- **100% Free**: No API keys, no subscriptions, no costs
- **No Rate Limits**: Works with your local Ollama models
- **Privacy-Focused**: All searches run through your local machine
- **Multiple Search Engines**: Google, Bing, DuckDuckGo support

## 🛠️ Prerequisites

Before you begin, ensure you have:

- **Claude Code** installed and working with Ollama
- **Node.js** (v16 or later) - for running the MCP server
- **npm** - comes with Node.js
- **Git** - for cloning repositories

### Install Node.js (if needed)

```bash
# Check if Node.js is installed
node --version

# If not installed, install via Homebrew
brew install node

# Verify installation
node --version
npm --version
```

## 🚀 Quick Setup

We'll use the **fetch-mcp-server** - a lightweight, open-source MCP server that provides web search and content fetching without any API keys.

### Step 1: Install the MCP Server

```bash
# Create a directory for MCP servers
mkdir -p ~/.mcp-servers
cd ~/.mcp-servers

# Install fetch-mcp-server globally
npm install -g mcp-fetch-server
```

### Step 2: Add to Claude Code

```bash
# Add the fetch MCP server to Claude Code
claude mcp add --transport stdio \
  fetch \
  -- npx -y mcp-fetch-server
```

### Step 3: Verify Installation

```bash
# List all configured MCP servers
claude mcp list

# You should see 'fetch' in the list
```

### Step 4: Test It Out

Launch Claude Code with your local model:

```bash
ollama launch claude --model qwen2.5-coder:7b
```

Within Claude Code, check MCP status:

```
/mcp
```

Now try asking Claude to fetch web content:

- "Fetch the content from <https://docs.python.org/3/whatsnew/3.13.html>"
- "Get the latest information from the React documentation"
- "Read the content from <https://github.com/ollama/ollama>"

## 🔍 Alternative: Web Search with DuckDuckGo

For actual web search (not just fetching URLs), you can use a custom MCP server that scrapes DuckDuckGo results.

### Option A: Simple Python MCP Server

Create a simple Python-based web search server:

```bash
# Create the MCP server directory
mkdir -p ~/.mcp-servers/simple-search
cd ~/.mcp-servers/simple-search

# Create the Python script
cat > search_server.py << 'EOF'
#!/usr/bin/env python3
import json
import sys
import urllib.request
import urllib.parse
from html.parser import HTMLParser

class DuckDuckGoParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.results = []
        self.current_result = {}
        self.in_result = False
        self.in_title = False
        self.in_snippet = False
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        if tag == 'div' and attrs_dict.get('class', '').startswith('result'):
            self.in_result = True
            self.current_result = {}
        elif self.in_result and tag == 'a' and 'class' in attrs_dict:
            if 'result__a' in attrs_dict['class']:
                self.in_title = True
                self.current_result['url'] = attrs_dict.get('href', '')
        elif self.in_result and tag == 'div' and 'class' in attrs_dict:
            if 'result__snippet' in attrs_dict['class']:
                self.in_snippet = True
                
    def handle_data(self, data):
        if self.in_title:
            self.current_result['title'] = data.strip()
        elif self.in_snippet:
            self.current_result['snippet'] = data.strip()
            
    def handle_endtag(self, tag):
        if tag == 'div' and self.in_result:
            if self.current_result:
                self.results.append(self.current_result)
            self.in_result = False
            self.current_result = {}
        elif tag == 'a' and self.in_title:
            self.in_title = False
        elif tag == 'div' and self.in_snippet:
            self.in_snippet = False

def search_web(query):
    """Search DuckDuckGo and return results"""
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote(query)}"
    headers = {'User-Agent': 'Mozilla/5.0'}
    
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as response:
            html = response.read().decode('utf-8')
            
        parser = DuckDuckGoParser()
        parser.feed(html)
        
        return {
            "results": parser.results[:10],
            "query": query
        }
    except Exception as e:
        return {"error": str(e), "query": query}

def main():
    """MCP server main loop"""
    for line in sys.stdin:
        try:
            request = json.loads(line)
            
            if request.get("method") == "tools/list":
                response = {
                    "tools": [{
                        "name": "search_web",
                        "description": "Search the web using DuckDuckGo",
                        "inputSchema": {
                            "type": "object",
                            "properties": {
                                "query": {
                                    "type": "string",
                                    "description": "Search query"
                                }
                            },
                            "required": ["query"]
                        }
                    }]
                }
                print(json.dumps(response))
                sys.stdout.flush()
                
            elif request.get("method") == "tools/call":
                tool_name = request["params"]["name"]
                if tool_name == "search_web":
                    query = request["params"]["arguments"]["query"]
                    results = search_web(query)
                    response = {
                        "content": [{
                            "type": "text",
                            "text": json.dumps(results, indent=2)
                        }]
                    }
                    print(json.dumps(response))
                    sys.stdout.flush()
                    
        except Exception as e:
            error_response = {"error": str(e)}
            print(json.dumps(error_response))
            sys.stdout.flush()

if __name__ == "__main__":
    main()
EOF

# Make it executable
chmod +x search_server.py
```

Add to Claude Code:

```bash
claude mcp add --transport stdio \
  simple-search \
  -- python3 ~/.mcp-servers/simple-search/search_server.py
```

### Option B: Use Existing Open-Source MCP Server

There are several community-built MCP servers that provide free web search:

#### 1. MCP-WebSearch (Multi-Engine)

```bash
cd ~/.mcp-servers
git clone https://github.com/snwfdhmp/mcp-websearch.git
cd mcp-websearch
npm install

# Add to Claude Code
claude mcp add --transport stdio \
  websearch \
  -- node ~/.mcp-servers/mcp-websearch/index.js
```

This server supports multiple search engines and automatically rotates between them to avoid rate limits.

#### 2. Tavily-Free (Limited Free Tier)

While Tavily has a paid API, they offer a generous free tier:

```bash
# Install Tavily MCP server
npm install -g @tavily/mcp-server

# Get free API key from tavily.com (1000 searches/month free)
# Add to Claude Code
claude mcp add --transport stdio \
  --env TAVILY_API_KEY=your_free_key_here \
  tavily \
  -- npx -y @tavily/mcp-server
```

## 🎯 Usage Examples

Once configured, you can ask Claude Code to search the web:

### Basic Search

```
Search the web for "latest TypeScript 5.4 features"
```

### Fetch Specific URLs

```
Fetch the content from https://github.com/ollama/ollama/blob/main/README.md
```

### Research Tasks

```
Search for "best practices for React Server Components" and summarize the findings
```

### Current Events

```
What are the latest developments in AI coding assistants?
```

## 🔧 Managing MCP Servers

```bash
# List all configured servers
claude mcp list

# Get details for a specific server
claude mcp get fetch

# Remove a server
claude mcp remove fetch

# Check status within Claude Code
/mcp
```

## ⚡ Performance Tips

1. **Be Specific**: More specific queries return better results
   - Good: "Python 3.13 new features list"
   - Less good: "Python updates"

2. **Batch Requests**: If you need multiple searches, ask Claude to do them sequentially
   - "Search for X, then search for Y, and compare the results"

3. **Use Fetch for Known URLs**: If you know the URL, use fetch instead of search
   - Faster and more reliable than searching

4. **Avoid Rapid-Fire Queries**: Give a few seconds between searches to avoid rate limits

## 🐛 Troubleshooting

### MCP Server Not Starting

```bash
# Check if Node.js is installed
node --version

# Check if the server file exists
ls -la ~/.mcp-servers/

# Try running the server manually to see errors
npx @modelcontextprotocol/server-fetch
```

### "Command not found: claude"

```bash
# Ensure Claude Code is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
claude --version
```

### Search Results Empty or Error

```bash
# Check your internet connection
curl -I https://duckduckgo.com

# Try a different search engine/MCP server
# Some search engines may block automated requests

# Check Claude Code logs
claude --verbose
```

### Rate Limiting Issues

If you're hitting rate limits:

1. **Wait a few minutes** before trying again
2. **Use a different search engine** (switch MCP servers)
3. **Add delays** between searches in your queries
4. **Consider using fetch** for known URLs instead of searching

## 🔒 Privacy & Security

### What Data is Shared?

- **Search queries**: Sent to the search engine (Google, DuckDuckGo, etc.)
- **Your IP address**: Visible to the search engine
- **User agent**: Identifies your request as coming from a script

### Staying Private

1. **Use DuckDuckGo**: More privacy-focused than Google
2. **Use a VPN**: Hide your IP address
3. **Rotate search engines**: Use multiple MCP servers
4. **Review results**: Always verify information from web searches

## 📊 Comparison: Free Options

| Solution              | Setup Difficulty | Rate Limits      | Search Quality | Privacy    |
|-----------------------|------------------|------------------|----------------|------------|
| Fetch MCP             | Easy             | None (URL only)  | N/A            | Excellent  |
| Simple Python Search  | Medium           | Moderate         | Good           | Good       |
| MCP-WebSearch         | Medium           | Low              | Good           | Good       |
| Tavily Free Tier      | Easy             | 1K/month         | Excellent      | Moderate   |

## 🎉 What's Next?

Once you have web search working, you can:

1. **Combine with local models**: Your local Ollama models can now access current information
2. **Build research workflows**: Ask Claude to research topics and summarize findings
3. **Stay current**: Get the latest documentation, news, and updates
4. **Verify information**: Cross-reference multiple sources

## 📚 Additional Resources

- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [Claude Code MCP Guide](https://code.claude.com/docs/en/mcp)
- [MCP Servers Repository](https://github.com/modelcontextprotocol/servers)
- [DuckDuckGo Search](https://duckduckgo.com/)

## 💡 Pro Tips

1. **Start with fetch**: It's the simplest and most reliable for known URLs
2. **Test incrementally**: Add one MCP server at a time
3. **Keep it simple**: Don't over-complicate with too many servers
4. **Document your setup**: Note which servers work best for your use cases
5. **Share your findings**: Contribute back to the community!

---

**Remember**: This is completely free and runs entirely on your local machine with your local Ollama models. No API keys, no subscriptions, no hidden costs!
