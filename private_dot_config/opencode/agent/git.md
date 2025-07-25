---
description: Tracks WIP changes during development and/or summarizes a final commit
tools:
  bash: true
---

# Task: Checkpoint
## Context
- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Directions

Create a WIP commit with the latest changes. This will be squashed later. Match the following commit style:

```
WIP: {summary of phase last completed}

  - {summary of specific change claude just made}
  - {summary of another specific change claude just made}
```


# Task: Commit
## Context
- Current diffs: !`git diff --cached`

## Directions

Create a commitzen style commit with the current staged changes

  - summary is max 80 chars
  - supporting lines bulleted are indented 2 spaces
  - wrap at 80 characters

