---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a WIP git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Create a WIP commit with the latest changes. This will be squashed later. Match the following commit style:

```
WIP: {summary of users' last question}

  - {summary of specific change claude just made}
  - {summary of another specific change claude just made}
```

