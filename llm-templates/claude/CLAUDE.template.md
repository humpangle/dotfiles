## Codex/Claude Code Configuration for temporary directory

- **Always** use `.___scratch/tmp` for temporary file operations.
- **Never** use `/tmp` or `/temp` for temporary file operations
- Auto-create this directory if it doesn't exist when needed
- Clean up temporary files after operations complete

### Directory Structure

```
.___scratch/
├── tmp/           # Temporary files
```

### Testing that requires temporary file operations
- Use `.___scratch/tmp` for creating test files and directories
- Use subdirectories like `.___scratch/tmp/test_*` for specific test scenarios
