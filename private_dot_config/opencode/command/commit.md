---
description: Create well-formatted commits using the conventional commits style
permission:
  bash:
    "git status": "allow"
    "git commit": "allow"
    "git diff": "allow"
    "git log": "allow"
    "git add": "deny"
    "git stage": "deny"
    "git reset": "deny"
    "git restore": "deny"
    "*": "ask"
---

# Creating a git commit

## Goal

Create well-formatted commits with the conventional commits style.

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff --no-ext-diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commit format: !`git log --oneline -10`

## Generic Process

1. Commit to git using a descriptive commit message that:

   - Uses the repo's existing summary style and tone

   - Roughly follows this template (wrap the body at 78 columns):

         ```txt
         <what changed, keep under 75 characters>

             - change one
             - change two
         ```

   - Lists key changes and additions

## Commit Style

- **Atomic commits**: Each commit should contain related changes that
  serve a single purpose.

- **Split large changes**: If changes touch multiple concerns, split
  them into separate commits. Always reviews the commit diff to ensure
  the message matches the changes.

- **Concise first line**: Keep the first line under 72 characters. Do
  not end the subject line with a period.

- **Present tense, imperative mood**: Use the imperative mood in the
  subject line.
