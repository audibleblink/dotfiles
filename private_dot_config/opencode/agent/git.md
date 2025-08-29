---
description: Create well-formatted commits using the conventional commits style
mode: subagent
permission:
  bash:
    "git status": "allow"
    "git branch": "allow"
    "git commit *": "allow"
    "git diff *": "allow"
    "git diff": "allow"
    "git log *": "allow"
    "git add *": "deny"
    "git stage *": "deny"
    "git reset *": "deny"
    "git restore *": "deny"
---

# Creating a git commit

## Generic Process

1. Commit to git using a descriptive commit message that:
   - Uses the repo's existing summary style and tone
   - Lists key changes and additions
   - Roughly follows this template (wrap the body at 78 columns):

 ```txt
 <what changed, keep under 75 characters>

     - change one
     - change two
 ```


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

