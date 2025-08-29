---
description: Plan bugfixes or feature requests.
agent: plan
model: anthropic/claude-sonnet-4-20250514
---

# Initial ask
User states they need to create or modify some code
Use available tools and knowledge of the code to come up with several scenarios

## User Ask

$ARGUMENTS

## Checklist

- [ ] Understand the current, relevant code
- [ ] Review the ask with the user by asking clarifying questions
- [ ] Present at least 3 options of implementation overview, listing pro/cons and impact to the project
- [ ] Answer questions the user may have 

# Finally
 Once the user has selected and option, with possible revisions, create  PRD for the feature and save it to .opencode/<feature>.prd.md
