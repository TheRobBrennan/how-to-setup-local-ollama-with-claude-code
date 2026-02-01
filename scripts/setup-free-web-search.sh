#!/bin/bash

set -e

echo "🆓 Setting up FREE Web Search for Claude Code"
echo "=============================================="
echo "No API keys required!"
echo ""

check_command() {
    if command -v "$1" &> /dev/null; then
        echo "✅ $1 is installed"
        return 0
    else
        echo "❌ $1 is not installed"
        return 1
    fi
}

echo "📋 Checking prerequisites..."
echo ""

MISSING_DEPS=0

if ! check_command "claude"; then
    echo "   Please install Claude Code first:"
    echo "   curl -fsSL https://claude.ai/install.sh | bash"
    MISSING_DEPS=1
fi

if ! check_command "node"; then
    echo "   Installing Node.js via Homebrew..."
    if check_command "brew"; then
        brew install node
    else
        echo "   Please install Node.js manually from: https://nodejs.org/"
        MISSING_DEPS=1
    fi
fi

if ! check_command "npm"; then
    echo "   npm should come with Node.js"
    MISSING_DEPS=1
fi

echo ""

if [ $MISSING_DEPS -eq 1 ]; then
    echo "❌ Missing required dependencies. Please install them and try again."
    exit 1
fi

echo "✅ All prerequisites satisfied!"
echo ""

echo "🔧 Choose your free web search option:"
echo ""
echo "1) Fetch MCP Server (Recommended - fetch content from URLs)"
echo "2) Simple Python Search (DuckDuckGo scraping)"
echo "3) Both (fetch + search)"
echo "4) Skip setup"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1|3)
        echo ""
        echo "📥 Installing Fetch MCP Server..."
        
        npm install -g mcp-fetch-server
        
        echo "   Adding Fetch MCP server to Claude Code..."
        claude mcp add --transport stdio \
            fetch \
            -- npx -y mcp-fetch-server
        
        echo ""
        echo "✅ Fetch MCP Server configured successfully!"
        
        if [ "$choice" = "1" ]; then
            echo ""
            echo "🎉 Setup complete!"
            echo ""
            echo "📝 Next steps:"
            echo "   1. Launch Claude Code: ollama launch claude --model qwen2.5-coder:7b"
            echo "   2. Check MCP status: /mcp"
            echo "   3. Try fetching a URL: 'Fetch content from https://example.com'"
            echo ""
            echo "📚 For more information, see: docs/free-web-search-setup.md"
            exit 0
        fi
        ;;
esac

case $choice in
    2|3)
        echo ""
        echo "📥 Setting up Simple Python Search..."
        
        if ! check_command "python3"; then
            echo "   ❌ Python 3 is required for this option"
            echo "   Install with: brew install python3"
            exit 1
        fi
        
        mkdir -p ~/.mcp-servers/simple-search
        
        echo "   Creating Python search server..."
        # Get the directory where this script is located
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        
        # Copy the Python script from the scripts folder
        cp "$SCRIPT_DIR/simple-search-mcp.py" ~/.mcp-servers/simple-search/search_server.py
        
        chmod +x ~/.mcp-servers/simple-search/search_server.py
        
        echo "   Adding Simple Search MCP server to Claude Code..."
        claude mcp add --transport stdio \
            simple-search \
            -- python3 ~/.mcp-servers/simple-search/search_server.py
        
        echo ""
        echo "✅ Simple Python Search configured successfully!"
        ;;
        
    4)
        echo ""
        echo "⏭️  Skipping setup"
        echo "   You can run this script again anytime"
        exit 0
        ;;
        
    *)
        echo ""
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "🎉 Free Web Search setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Launch Claude Code: ollama launch claude --model qwen2.5-coder:7b"
echo "   2. Check MCP status: /mcp"

if [ "$choice" = "3" ]; then
    echo "   3. Try fetching: 'Fetch content from https://example.com'"
    echo "   4. Try searching: 'Search the web for latest Python features'"
else
    echo "   3. Try searching: 'Search the web for latest Python features'"
fi

echo ""
echo "📚 For more information, see: docs/free-web-search-setup.md"
echo ""
echo "💡 Pro tip: Use 'claude mcp list' to see all configured servers"
