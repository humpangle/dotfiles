# /pr-create-draft

Create a draft pull request with title derived from the current branch name and recent commits.

## Usage

```
/pr-create-draft
```

## Process

1. **Analyze current branch**:
   - Get current branch name using `git branch --show-current`
   - Verify branch is up to date with remote using `git status`

2. **Extract PR title**:
   - Use branch name pattern (e.g., "SCHED-1234-description") to create title
   - Format as "TICKET: Description" (e.g., "SCHED-5456: Clean up SCHED-4833-fix-duplicated-scheduled-hours flag")

3. **Verify branch state**:
   - Ensure branch tracks remote and is pushed
   - Check for uncommitted changes (should be clean working tree)

4. **Load PR template** (optional):
   - Get git root directory using `git rev-parse --show-toplevel`
   - Try to read `.github/PULL_REQUEST_TEMPLATE` from git root directory (use absolute path)
   - If template exists, use its content as PR body
   - If template doesn't exist, use empty body

5. **Create draft PR**:
   - If template content exists: `gh pr create --title "TITLE" --body "TEMPLATE_CONTENT" --draft`
   - If template content is empty: `gh pr create --title "TITLE" --body "" --draft`
   - Return the PR URL

## Example

For branch `SCHED-5456-h-SCHED-4833-fix-duplicated-scheduled-hours`:
- Title: "SCHED-5456: Clean up SCHED-4833-fix-duplicated-scheduled-hours flag"
- Body: Uses `.github/PULL_REQUEST_TEMPLATE` content with checklist and description sections (if template exists, otherwise empty)
- Creates draft PR at: https://github.com/AlayaCare/api.scheduler/pull/XXXX

## Important Notes

- **REQUIRES**: Branch must be pushed to remote before creating PR
- **REQUIRES**: Clean working tree (no uncommitted changes)
- **OPTIONAL**: `.github/PULL_REQUEST_TEMPLATE` file in git root - uses template as body if found, empty body if not
- Creates draft PR with title and body (populated from template if available)
- Uses GitHub CLI (`gh`) which must be authenticated
