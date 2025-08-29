---
description: Create well-formatted commits using the conventional commits style
agent: git
model: anthropic/claude-3-5-sonnet-20241022
---

Create well-formatted commits with the conventional commits style.

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff --no-ext-diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commit format: !`git log --oneline -10`

