# blink-mcp Design Spec

## Overview

A FastMCP (Python) stdio server that serves markdown prompt files as MCP prompts. Its purpose is to be the single source of truth for slash commands/prompts shared across coding agents (opencode, Claude Code, Goose, etc.).

No tools. No resources. Prompts only.

## Decisions

- **Source of truth**: The MCP server owns the prompts. Agents consume them.
- **Universality**: No agent-specific metadata. Prompts are portable.
- **Argument handling**: `$ARGUMENTS` in prompt bodies is parsed and exposed as a native MCP prompt argument.
- **Prompt directory**: `~/.config/blink-mcp/prompts/`
- **File format**: Markdown with YAML frontmatter.
- **Hot reload**: Server watches the prompts directory and emits `notifications/prompts/list_changed`.
- **Template syntax**: Raw markdown served as-is. No template processing.
- **Language**: Python with FastMCP.
- **Transport**: stdio.

## File Format

Each prompt is a `.md` file in `~/.config/blink-mcp/prompts/`:

```markdown
---
description: Short description shown in prompt listings
---

The prompt body goes here.

User wants to do: $ARGUMENTS
```

- **Name**: Derived from filename. `sdd-new.md` → `sdd-new`.
- **Description**: From the `description` frontmatter field (required).
- **Arguments**: If `$ARGUMENTS` appears in the body, the prompt is registered with a single required string argument called `arguments`. If absent, no arguments.
- **Content**: Full markdown body below frontmatter, served as a `UserMessage`. `$ARGUMENTS` is replaced with the provided argument value at request time.
- Extra frontmatter fields are ignored.

## Server Architecture

Single file: `server.py`

Three responsibilities:

1. **Startup**: Scan prompts directory, parse all `.md` files, register each as an MCP prompt.
2. **Serve**: Handle `prompts/list` and `prompts/get` requests.
3. **Watch**: Monitor prompts directory for file changes (add/edit/delete), reload affected prompts, emit `notifications/prompts/list_changed`.

### Dependencies

- `mcp` (FastMCP Python SDK)
- `watchfiles` (OS-native filesystem watching)
- `python-frontmatter` (YAML frontmatter parsing)

### No Config

The prompts directory defaults to `~/.config/blink-mcp/prompts/`. Can be overridden via CLI argument or environment variable. No database, no state beyond disk.

## Migration

One-time `migrate.py` script to seed prompts from opencode commands:

1. Read `.md` files from `~/.config/opencode/command/`
2. Strip opencode-specific frontmatter fields (`agent`, `subtask`) — keep only `description`
3. Write to `~/.config/blink-mcp/prompts/` with the same filename
4. Body preserved as-is (raw markdown)

Run once, then discard.

## Agent Integration

Each agent adds blink-mcp to its MCP config as a stdio server pointing at `server.py`. Examples:

**opencode** (`opencode.jsonc`):
```jsonc
"blink-mcp": {
  "type": "local",
  "command": ["python", "/path/to/blink-mcp/server.py"]
}
```

**Claude Code** (`.mcp.json` or settings):
```json
{
  "mcpServers": {
    "blink-mcp": {
      "command": "python",
      "args": ["/path/to/blink-mcp/server.py"]
    }
  }
}
```

### What agents see

- `prompts/list` → all prompts with name + description
- `prompts/get` → rendered markdown content with `$ARGUMENTS` substituted
- `notifications/prompts/list_changed` → when files change on disk

### What agents don't see

- No tools
- No resources
- No agent-specific metadata
