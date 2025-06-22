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
