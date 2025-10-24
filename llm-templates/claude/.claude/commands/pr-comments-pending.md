# /pr-comments-pending

Fetch draft/pending review comments from a GitHub pull request that reviewers have written but not officially submitted yet.

## Usage

```
/pr-comments-pending [PR_NUMBER]
```

## Arguments

- `PR_NUMBER` (required): The PR number to fetch pending comments from

## Examples

```
/pr-comments-pending 6692
```

## Implementation

Use the GitHub GraphQL API to fetch pending review comments:

```bash
gh api graphql -f query='
query {
  repository(owner: "AlayaCare", name: "api.scheduler") {
    pullRequest(number: PR_NUMBER) {
      reviews(first: 10, states: PENDING) {
        nodes {
          author {
            login
          }
          state
          body
          comments(first: 50) {
            nodes {
              path
              position
              body
              diffHunk
              originalPosition
              line
            }
          }
        }
      }
    }
  }
}'
```

Replace `PR_NUMBER` with the actual PR number.

## Understanding the Response

The GraphQL query returns:
- **reviews.nodes**: Array of pending reviews
  - **author.login**: Username of the reviewer
  - **state**: Will be "PENDING" for draft reviews
  - **body**: Overall review comment (usually empty for pending)
  - **comments.nodes**: Array of inline code review comments
    - **path**: File path where comment was made
    - **line**: Line number in the new version
    - **body**: The comment text
    - **diffHunk**: Context showing the code change
    - **position**: Position in the diff
    - **originalPosition**: Position in the original diff

## Key Differences from Regular Comments

1. **Regular PR comments** (submitted reviews):
   - Fetched via: `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments`
   - Visible to everyone immediately
   - Part of the official review record

2. **Pending comments** (draft reviews):
   - Only accessible via GraphQL with `states: PENDING`
   - Not visible to PR author until reviewer clicks "Submit review"
   - Can be edited or deleted by reviewer before submission
   - May only be visible to the reviewer themselves (depending on permissions)

## Notes

- Pending comments are **draft comments** that reviewers write during their review process
- They become visible only after the reviewer clicks "Submit review" or "Approve/Request changes"
- You may need appropriate repository permissions to view pending reviews from other users
- The reviewer can still edit, delete, or add more comments before submitting
- Use this when you want to check if there are any draft comments waiting to be submitted

## Related Commands

- `/pr-review` - Full PR review workflow
- Use `gh pr view PR_NUMBER --json reviews,comments` for submitted comments only
