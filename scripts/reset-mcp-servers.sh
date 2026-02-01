#!/bin/bash

set -e

echo "🔄 Resetting MCP Servers for Claude Code"
echo "=========================================="
echo ""

# Get the current project directory
PROJECT_DIR="$(pwd)"
echo "Project directory: $PROJECT_DIR"
echo ""

# Function to check if a command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Check prerequisites
if ! check_command "claude"; then
    echo "❌ Claude Code is not installed or not in PATH"
    echo "Please install Claude Code first: curl -fsSL https://claude.ai/install.sh | bash"
    exit 1
fi

echo "📋 Current MCP servers for this project:"
echo ""

# List current servers
if claude mcp list 2>/dev/null | grep -q "Connected\|Failed"; then
    claude mcp list
    echo ""
else
    echo "No MCP servers currently configured for this project."
    echo ""
fi

# Get list of configured servers
SERVERS=$(claude mcp list 2>/dev/null | grep -E "^[a-zA-Z0-9_-]+:" | cut -d: -f1 | tr -d ' ' || true)

if [ -z "$SERVERS" ]; then
    echo "ℹ️  No MCP servers found to remove."
    echo ""
    echo "🎉 Reset complete! (Nothing to remove)"
    exit 0
fi

echo "🔍 Found MCP servers to remove:"
for server in $SERVERS; do
    echo "   - $server"
done
echo ""

read -p "❓ Are you sure you want to remove ALL MCP servers for this project? (y/N): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Reset cancelled."
    exit 0
fi

echo ""
echo "🗑️  Removing MCP servers..."

# Remove each server
for server in $SERVERS; do
    echo "   Removing $server..."
    if claude mcp remove "$server" 2>/dev/null; then
        echo "   ✅ Removed $server"
    else
        echo "   ⚠️  Failed to remove $server (may not exist)"
    fi
done

echo ""
echo "🧹 Cleaning up Claude MCP configuration..."

# Get the current project directory
PROJECT_DIR="$(pwd)"

# Use jq to safely remove MCP servers from Claude config if jq is available
if command -v jq &> /dev/null; then
    echo "   Cleaning Claude MCP configuration..."
    
    # Backup the config file
    cp "$HOME/.claude.json" "$HOME/.claude.json.backup"
    
    # Remove MCP servers for this project and any related paths
    jq "(
        .projects[\"$PROJECT_DIR\"].mcpServers = {} |
        .projects[\"$PROJECT_DIR\"].enabledMcpjsonServers = [] |
        .projects[\"$PROJECT_DIR\"].disabledMcpjsonServers = [] |
        del(.projects[\"$HOME/.mcp-servers/simple-search\"]) |
        del(.projects[\"$HOME/.mcp-servers\"])
    )" "$HOME/.claude.json" > "$HOME/.claude.json.tmp" && mv "$HOME/.claude.json.tmp" "$HOME/.claude.json"
    
    echo "   ✅ Cleaned Claude MCP configuration"
    echo "   💾 Backup saved to ~/.claude.json.backup"
else
    echo "   ⚠️  jq not found - skipping config cleanup"
    echo "   Install jq with: brew install jq"
fi

echo ""
echo "🧹 Cleaning up local files..."

# Remove the MCP servers directory if it exists
if [ -d "$HOME/.mcp-servers" ]; then
    echo "   Found ~/.mcp-servers directory"
    read -p "❓ Also remove ~/.mcp-servers directory? (y/N): " clean_files
    
    if [[ "$clean_files" =~ ^[Yy]$ ]]; then
        echo "   Removing ~/.mcp-servers directory..."
        rm -rf "$HOME/.mcp-servers"
        echo "   ✅ Removed ~/.mcp-servers directory"
    else
        echo "   ⏭️  Keeping ~/.mcp-servers directory"
    fi
else
    echo "   No ~/.mcp-servers directory found"
fi

echo ""
echo "🎉 MCP Reset Complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Run 'npm run setup:web-search' to add web search capabilities"
echo "   2. Or run 'claude mcp add <name> -- <command>' to add specific servers"
echo "   3. Check status with 'claude mcp list'"
echo ""
echo "💡 Tip: You can always reset again with 'npm run reset:mcp'"
