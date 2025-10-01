---
description: Create well-formatted commits using the conventional commits style
agent: git
subtask: true
---

Create well-formatted commits with the conventional commits style.

## Context

**Current git status** !`git status`

**Current git diff (staged and unstaged changes)** !`git diff --no-ext-diff HEAD | tr @ _`

**Current branch** !`git branch --show-current`

**Recent commit format** !`git log --oneline -10`

COMMIT_EDITMSG location: ${ARGUMENTS}
