---
description: Implement the feature
agent: build
---

Implement the feature

**Input**: A PRD and Execution Plan

**Steps**

1. **Read context files**

   Read the @prd.md and @plan.md

2. **Show current progress**

   Display:
   - Progress: "N/M phase/tasks complete"
   - Remaining phase/tasks overview

3. **Implement phase tasks (async sub-agent loops until done or blocked)**

   Choose the next unfinished phase. If multiple phases can be conducted in parallel, 
   spin off sub-agents for each

   For each pending task:
   - Show which task is being worked on
   - Make the code changes required
   - Keep changes minimal and focused
   - Mark task complete in the tasks file: `- [ ]` → `- [x]`
   - Validate functionality and correctness
   - Continue to next task in the phase

   **Pause if:**
   - Task is unclear → ask for clarification
   - Implementation reveals a design issue → suggest updating artifacts
   - Error or blocker encountered → report and wait for guidance
   - User interrupts

4. **On completion or pause, show status**

   Display:
   - Tasks completed this session
   - Overall progress: "N/M tasks complete"
   - If all done: say so and @git commit
   - If paused: explain why and wait for guidance

**Output During Implementation**

```
## Implementing: <change-name> (schema: <schema-name>)

Working on task 3/7: <task description>
[...implementation happening...]
✓ Task complete

Working on task 4/7: <task description>
[...implementation happening...]
✓ Task complete
```

**Output On Completion**

```
## Implementation Complete

**Change:** <change-name>
**Schema:** <schema-name>
**Progress:** 7/7 tasks complete ✓

### Completed This Session
- [x] Task 1
- [x] Task 2
...

All tasks complete! 
```

**Output On Pause (Issue Encountered)**

```
## Implementation Paused

**Change:** <change-name>
**Progress:** 4/7 tasks complete

### Issue Encountered
<description of the issue>

**Options:**
1. <option 1>
2. <option 2>
3. Other approach

What would you like to do?
```

**Guardrails**
- Keep going through tasks until done or blocked
- Always read context files before starting
- If implementation reveals issues, pause and suggest artifact updates
- Keep code changes minimal and scoped to each task
- Update task checkbox immediately after completing each task
- Pause on errors, blockers, or unclear requirements - don't guess

