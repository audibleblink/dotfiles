---
description: Create well-formatted commit message using the conventional commits style
mode: subagent
permission:
  bash:
    "git diff": "allow"
    "git log *": "allow"
    "git branch": "deny"
    "git status": "deny"
    "git commit *": "deny"
    "git add *": "deny"
    "git stage *": "deny"
    "git reset *": "deny"
    "git restore *": "deny"
---

# Generating a git commit message

> [!IMPORTANT]  Important 
>  IGNORE changes not staged for commit:


## Generic Process

1. Generate a Commit message using a descriptive commit message that:
   - Uses the repo's existing summary style and tone
   - Lists key changes and additions
   - Roughly follows this template (wrap the body at 78 columns):

 ```txt
 <what changed, keep under 75 characters>

     - change one
     - change two
 ```


## Commit Style


- **Concise first line**: Keep the first line under 75 characters. Do
  not end the subject line with a period.

- **Present tense, imperative mood**: Use the imperative mood in the
  subject line.

