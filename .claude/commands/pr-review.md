# /pr-review

Review a pull request by analyzing changes, understanding the issue being fixed, and verifying that review comments have been addressed.

## Usage

```
/pr-review [PR_NUMBER] [ISSUE_FILE]
```

## Arguments

- `PR_NUMBER` (optional): The PR number to review. If not provided, reviews the current branch's PR.
- `ISSUE_FILE` (optional): Path to an issue summary file (e.g., `.___scratch/issues/*/issue.xml`). If not provided, the review will be based on PR description and code changes alone.

## Examples

```
/pr-review
/pr-review 6409
/pr-review 6409 .___scratch/issues/SEV-8029-gold-von-missing-visits-for-clients/SEV-8029.xml
```

## Implementation

1. **Determine the PR and fork point:**
   - If PR number is provided, use `gh pr view` to get PR details
   - Use `/pr-base` to find the fork point commit
   - If no PR number, assume we're on a PR branch and get its info

2. **Understand the issue (if issue file provided):**
   - Read and analyze the issue summary file
   - Extract key problem description and expected solution

3. **Review the changes:**
   - List all changed files using `git diff fork-point..HEAD --name-only`
   - Analyze key changes in modified files
   - Check implementation against issue requirements

4. **Check review comments:**
   - Use `/pr-comments` to fetch all PR comments
   - Verify each comment has been addressed in the code
   - Look for any unresolved discussions

5. **Provide summary:**
   - Issue understanding (if applicable)
   - Implementation review
   - Status of review comments
   - Any remaining concerns or recommendations

## Notes

- The command uses feature flags and release flags if present in the codebase
- It checks for proper error handling and edge cases
- Reviews test coverage for the changes
- Considers backward compatibility when applicable