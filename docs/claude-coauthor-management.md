# Managing Claude Co-Author Attribution

Control the "co-authored by Claude" attribution in commit messages using project-specific configuration.

## Quick Solution

This repository includes `.claude/settings.json` as a working example. Create the same file in your project root:

```json
{
  "gitAttribution": false,
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

This disables Claude's co-author attribution for commits and pull requests in this project.

## Configuration Options

### Disable All Attribution

```json
{
  "gitAttribution": false,
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

### Enable Attribution (Default Behavior)

```json
{
  "gitAttribution": true,
  "attribution": {
    "commit": "Co-authored-by: Claude <claude@anthropic.com>",
    "pr": "Co-authored-by: Claude <claude@anthropic.com>"
  }
}
```

### Custom Attribution

```json
{
  "gitAttribution": true,
  "attribution": {
    "commit": "Co-authored-by: AI Assistant <ai@example.com>",
    "pr": "Assisted-by: Claude AI"
  }
}
```

## Configuration Scope

### Project-Level (This Repository)
- **Location**: `.claude/settings.json` (in your repository root)
- **Scope**: Only affects the current project
- **Example**: This repository includes a working example at `.claude/settings.json`
- **Version control**: Can be committed to share with team, or gitignored for personal preference

### External Documentation

For comprehensive information about Claude Code configuration:

- **Official Claude Code Documentation**: [https://docs.anthropic.com/claude/docs/claude-code](https://docs.anthropic.com/claude/docs/claude-code)
- **Claude Code Settings Reference**: Check `claude --help` for available configuration options
- **MCP Configuration**: See `claude mcp --help` for MCP server settings

To explore available settings in your Claude Code installation:
```bash
# View all available options
claude --help

# Check for settings-related flags
claude --help | grep -i settings
```

## Verification

After creating the configuration:

1. Make a change and commit it
2. Check the commit message:
   ```bash
   git log -1 --format=fuller
   ```
3. Verify no "Co-authored-by" trailer appears

## Sharing with Team

### Option 1: Commit the Configuration
```bash
git add .claude/settings.json
git commit -m "chore: disable Claude co-author attribution"
```

### Option 2: Keep it Personal
Add to `.gitignore`:
```
.claude/settings.json
```

## Related Settings

The `.claude/settings.json` file supports multiple configuration options beyond attribution settings. For complete documentation, see the [official Claude Code settings documentation](https://code.claude.com/docs/en/settings).

Additional settings include:
- **Permissions**: Control which tools and commands Claude can use
- **Environment variables**: Configure persistent environment settings
- **Hooks**: Customize Claude's behavior at different lifecycle points
- **File suggestions**: Configure custom file search behavior
- **System prompts**: Add project-specific instructions via `CLAUDE.md`

## Troubleshooting

**Attribution still appears:**
- Verify the file is at `.claude/settings.json` (relative to project root)
- Check JSON syntax is valid
- Restart Claude Code session
- Ensure `gitAttribution` is set to `false`

**File not working:**
- Confirm you're in the correct project directory
- Check file permissions (should be readable)
- Verify Claude Code version supports this configuration
