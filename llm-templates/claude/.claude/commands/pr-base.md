---
description: Find the base commit where a PR branch was created from
---

Find the base commit where PR $ARGUMENTS was created from. This is the parent commit of the first commit in the PR branch (the fork point).

Parse the arguments:
- If only a number is provided, that's the PR number and use `gh pr view` to determine the base branch
- If two arguments are provided (e.g., "6448 develop"), the first is the PR number and the second is the base branch to use

Steps:
1. Get the PR branch name using `gh pr view`
2. If no base branch was specified, get it from the PR's baseRefName
3. Find the first commit in the PR branch relative to the base branch
4. Get the parent of that first commit
5. Show the commit hash and commit message