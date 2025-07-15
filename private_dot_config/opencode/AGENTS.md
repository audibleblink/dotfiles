# This file contains persistent instructions that override default behaviors

## Core Coding Principles
1. **No artifacts** - Direct code only
2. **Less is more** - Rewrite existing components vs adding new
3. **No fallbacks** - They hide real failures
4. **Clean codebase** - Flag obsolete files for removal
5. **Think first** - Clear thinking prevents bugs

## Documentation

### Documentation Standards
**Format Requirements**:
- Use clear hierarchical headers (##, ###, ####)
- Include "Last Updated" date and version at top
- Keep line length ≤ 100 chars for readability
- Use code blocks with language hints
- Include practical examples, not just theory

**Content Guidelines**:
- Write for future developers (including yourself in 6 months)
- Focus on "why" not just "what" 
- Link between related docs (use relative paths)
- Keep each doc focused on its purpose
- Update version numbers when content changes significantly

### Auto-Documentation Triggers
**ALWAYS document when**:
- Fixing bugs → Update `./docs/BUG_REFERENCE.md` with:
    - Bug description, root cause, solution, prevention strategy
- Adding features → Update `./docs/ROADMAP.md` with:
    - Feature description, architecture changes, API additions
- Changing APIs → Update `./docs/API_REFERENCE.md` with:
    - New/modified endpoints, breaking changes flagged, migration notes
- Architecture changes → Update `./docs/DATA_FLOW.md`
- Database changes → Update `./docs/SCHEMAS.md`
- Before ANY commit → Check if docs need updates

Critical Reminders

- Do exactly what's asked - nothing more, nothing less
- NEVER create files unless absolutely necessary
- ALWAYS prefer editing existing files over creating new ones
- NEVER create documentation unless working on a coding project
- When coding, keep the project as modular as possible.


