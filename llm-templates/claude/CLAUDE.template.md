# CLAUDE.md/AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) and Codex (openai) when working with code in this repository.

## General Instructions for Codex/Claude Code

### Git Commit Rules

- **Always** wait for explicit user approval before running `git stage`
- **Always** wait for explicit user approval before running `git commit`
- When asked to commit:
  - **DO NOT** stage remaining unstaged files - only commit what is already staged
  - Run `git diff --no-ext-diff --staged` to review staged changes
  - Draft a commit message following the format:
     - Subject: ~120 chars, no trailing period
     - Body: Multi-line explanation of why changes were made (wrap ~120 chars)
  - Present the draft commit message to the user for approval
  - Only execute `git commit -m "<subject>" -m "<body>"` after user confirms

### Configuration for temporary directory

- **Always** use `.___scratch/tmp` for temporary file operations.
- **Never** use `/tmp` or `/temp` for temporary file operations
- Auto-create this directory if it doesn't exist when needed
- Clean up temporary files after operations complete

#### Directory Structure

```
.___scratch/
├── tmp/           # Temporary files
```

#### Testing that requires temporary file operations
- Use `.___scratch/tmp` for creating test files and directories
- Use subdirectories like `.___scratch/tmp/test_*` for specific test scenarios
