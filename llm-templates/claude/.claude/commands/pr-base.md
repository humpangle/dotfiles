# /pr-base

Find the base commit where a pull request was created from. This is the parent commit of the first commit in the PR branch (the fork point).

## Usage

```
/pr-base <PR_NUMBER> [BASE_BRANCH]
```

## Arguments

- `PR_NUMBER` (required): The pull request number to analyze
- `BASE_BRANCH` (optional): The base branch to use. If not provided, uses the PR's base branch

## Examples

```
/pr-base 6448
/pr-base 6448 develop
```

## Implementation

1. **Parse arguments**:
   - If only a number is provided, that's the PR number and use `gh pr view` to determine the base branch
   - If two arguments are provided (e.g., "6448 develop"), the first is the PR number and the second is the base branch to use

2. **Get PR information**:
   - Get the PR branch name using `gh pr view`
   - If no base branch was specified, get it from the PR's baseRefName

3. **Find fork point**:
   - Find the first commit in the PR branch relative to the base branch
   - Get the parent of that first commit

4. **Display result**:
   - Show the commit hash and commit message
