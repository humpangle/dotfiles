cat `CLAUDE.local.md`

```
# Claude Code Configuration for /temp directory

## Working Directory Rules

### Temporary Directory
- Use `.___scratch/tmp` as the temporary directory for all operations
- This directory should be used instead of `/tmp` for testing, temporary files, and scratch work
- Auto-create this directory if it doesn't exist when needed

### Directory Structure
```
.___scratch/
├── tmp/           # Temporary files and testing
├── logs/          # Log files
└── cache/         # Cache files
```

## File Operations
- Always prefer using `.___scratch/tmp` for temporary file operations
- Create subdirectories within `.___scratch/tmp` as needed for organization
- Clean up temporary files after operations complete

## Testing
- Use `.___scratch/tmp` for creating test files and directories
- Use subdirectories like `.___scratch/tmp/test_*` for specific test scenarios
```

#=======================================================================================================================

$HOME/dotfiles/llm-templates/

claude

-------------------------------------------------------------------------------

commit staged

<details>
<summary><code>⫸ Prompt: Inspect, draft, and commit</code></summary>
  I’ve already staged some changes.
  Do the following in one go:
  1. Run `git diff --no-ext-diff --staged`.
  2. Generate a descriptive, sentence‑case commit message with a brief subject line and a body explaining why the change was made.
  3. Commit the staged changes using that message (i.e. run `git commit -m "<subject>" -m "<body>"`).
  Use the style:
  - Subject max ~120 chars, sentence case (no period at end).
  - Body wraps at ~120 chars, explains rationale.
</details>

-------------------------------------------------------------------------------

<details>
<summary><code>⫸ Prompt #1: Draft commit message</code></summary>
  I’ve staged some changes.
  Run `git diff --no-ext-diff --staged` and propose a concise, sentence‑case commit message:
  - One‑line subject (~120 chars, no trailing period).
  - Multi‑line body (wrap ~120 chars) explaining why.
</details>

<details>
<summary><code>⫸ Prompt #2: Commit with approved message</code></summary>
  Commit the staged changes with the message we just finalized.
  Run: git commit -m "<subject>" -m "<body>"
</details>
