# CLAUDE.md/AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) and Codex (openai) when working with code in this repository.

## General Instructions for Codex/Claude Code

### Configuration for temporary directory

- **Always** use `.___scratch/temp/{timestamp}/` for temporary file operations, where `{timestamp}` is the current Unix timestamp in seconds (e.g., `.___scratch/temp/1751971577/`)
- **Never** use `/tmp` or `/temp` for temporary file operations
- Auto-create the timestamped directory if it doesn't exist when needed
- No cleanup necessary - each operation uses its own unique timestamped directory

#### Directory Structure

```
.___scratch/
├── temp/                    # Temporary files root
    ├── 1751971577/         # Example timestamped directory for one operation
    ├── 1751971623/         # Example timestamped directory for another operation
    └── ...
```

#### Usage Example
```bash
# Generate timestamp and create directory
TIMESTAMP=$(date +%s)
TEMP_DIR=".___scratch/temp/${TIMESTAMP}"
mkdir -p "${TEMP_DIR}"

# Use the directory for operations
echo "test" > "${TEMP_DIR}/file.txt"
```

#### Testing that requires temporary file operations
- Use `.___scratch/temp/{timestamp}/` for creating test files and directories
- Each test run gets its own timestamped directory for isolation
