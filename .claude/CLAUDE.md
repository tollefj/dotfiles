# General information

- Never create markdown documents unless asked for.
- Use precise language.
- No emojis.
- No conversational jargon.

# Tools

Use built-in tools over bash commands for file operations:

- **Read** over `cat`, `head`, `tail` for reading files
- **Edit** over `sed`, `awk` for editing files
- **Write** over `echo` for creating files
- **Glob** over `find`, `fd` for finding files by pattern
- **Grep** over `rg`, `grep` for searching file contents
- Use `tree`, `jq`, `yq` are available.
- Verify versions and project structure early in sessions, using suitable tools for the provided context. E.g. using "pip --outdated" for Python projects.

Reserve Bash for actual system commands (git, npm, docker, uv, etc.).

When exploring codebases or gathering context, use the **Explore agent** via Task tool rather than running searches directly.


# Web

- Prefer `WebFetch` for retrieving and analyzing specific URLs.
- Limit `WebSearch` to the current root domain unless broader research is explicitly required.
- Check for .md files as suffix when accessing websites, e.g., <https://domain.tld/docs/subpage.md>
- Check for `llms.txt` or `llm.txt` when entering websites for text documentation.

# Code style

- Self-documenting code over comments.
- Always follow the simplest path to the objective. Minimal files and nesting.
- Always run Python projects with `uv run <file>`. Look for `pyproject.toml`.
- Follow clean code principles.
- Never write tests unless asked.
- Never use mock data. Specify schemas instead with placeholders.
- Never interfere with git. Rather, suggest commands and comments for commits and pull requests.

## Refactoring Protocol

When asked to perform refactoring or replace hardcoded values:

1. Analysis First: ALWAYS grep/search for all related patterns (constants, strings, hex codes) globally before changing a single file.
2. Atomic Consistency: Never leave a refactoring half-done. If you change a definition, you must update ALL usages (interfaces, tests, utils).
3. Self-Verification: Before declaring a task done, run a verify step to ensure no legacy patterns remain.

## Anti-Sloth Rules

- Do not apply "quick fixes" unless explicitly asked.
- Assume the user wants the "proper engineering solution," not the hacky one.
- We are now writing production code not prototyping, look for global impact when doing changes
- All API should have integration tests, always update, delete or add these.
- Change is not done before it is tested.

# Packages

- Use the year 2026 to explore recent technical frameworks and packages.
- Prefer stable, well-documented packages with active maintenance.
- Simplistic packages can be implemented from scratch locally.

# Workflow

- Use **Plan mode** (EnterPlanMode) for non-trivial implementations requiring architectural decisions.
- Use **TodoWrite** to track multi-step tasks and show progress.
- Edit existing files rather than creating new ones when possible.
