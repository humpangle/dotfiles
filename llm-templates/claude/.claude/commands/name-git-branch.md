---
description: Generate a git branch name from a Jira ticket number
tags: [git, jira, branch]
---

# Git Branch Name Generator

Given a Jira ticket number (e.g., SCHED-5559) or a Jira issue URL (e.g., https://alayacare.atlassian.net/browse/SCHED-5559), generate a properly formatted git branch name.

## Input Formats

This command supports two input formats:

### Format 1: Ticket Number/URL Only (Fetch from Jira)
- Input: Just the ticket number or URL
- Examples: `SCHED-5559` or `https://alayacare.atlassian.net/browse/SCHED-5559`
- The command will fetch the issue title from Jira and use it to construct the branch name

### Format 2: Ticket Number/URL + Custom Description
- Input: Ticket number/URL followed by a description string
- Examples:
  - `SCHED-5559 'Clean some Expired flags'`
  - `https://alayacare.atlassian.net/browse/SCHED-5559 'Clean some Expired flags'`
- The command will use the supplied description instead of fetching from Jira

## Instructions

1. **Determine the input format**:
   - Check if the user provided one argument (ticket number/URL only) or two arguments (ticket number/URL + description)
   - If two arguments are provided, the second argument is the custom description

2. **Extract the ticket number from the first argument**:
   - If the input is a URL (contains `atlassian.net/browse/` or similar), extract the ticket number from the URL
   - The ticket number is typically the last part of the URL path (e.g., `SCHED-5559` from `https://alayacare.atlassian.net/browse/SCHED-5559`)
   - If the input is already just a ticket number, use it as-is

3. **Get the description**:
   - **If a custom description was provided (Format 2)**: Use the supplied description directly
   - **If no description was provided (Format 1)**:
     - Use the **Atlassian-getAccessibleAtlassianResources** tool to get the cloud ID
     - Use the **Atlassian-getJiraIssue** tool with the cloud ID and ticket number to fetch the Jira ticket details
     - Extract the ticket title from the `fields.summary` field in the response

4. **Convert the description/title to a git-friendly branch name**:
   - Convert to lowercase
   - Replace spaces with hyphens
   - Remove special characters (keep only letters, numbers, and hyphens)
   - Remove consecutive hyphens

5. **Format the branch name as**: `{TICKET-NUMBER}-{formatted-description}`

6. **IMPORTANT**: Ensure the final branch name is **no longer than 60 ASCII characters**
   - If the branch name exceeds 60 characters, truncate the description portion (not the ticket number)
   - Ensure the truncation doesn't end with a hyphen
   - The ticket number must always be included in full

7. Check if the `copy` executable exists using `which copy`

8. If the `copy` executable exists, copy the generated branch name to the system clipboard using `echo "{branch-name}" | copy`

9. Output the generated branch name and indicate whether it was copied to clipboard

## MCP Tools to Use

- `Atlassian-getAccessibleAtlassianResources`: Get the Atlassian cloud ID
- `Atlassian-getJiraIssue`: Fetch the Jira issue details using cloudId and issueIdOrKey parameters

## Examples

### Example 1: Ticket Number Only (Fetch from Jira)

Input: `SCHED-5559`

Process:
- No custom description provided, so fetch from Jira
- Fetch ticket details
- Title: "Master projection job behaves abnormally in NVD"
- Convert: "master-projection-job-behaves-abnormally-in-nvd"
- Combine: "SCHED-5559-master-projection-job-behaves-abnormally-in-nvd"
- Check length: 60 characters (exactly at limit, OK!)

Output: `SCHED-5559-master-projection-job-behaves-abnormally-in-nvd`

### Example 2: Jira URL Only (Fetch from Jira)

Input: `https://alayacare.atlassian.net/browse/SCHED-5559`

Process:
- Extract ticket number: "SCHED-5559"
- No custom description provided, so fetch from Jira
- Fetch ticket details
- Title: "Master projection job behaves abnormally in NVD"
- Convert: "master-projection-job-behaves-abnormally-in-nvd"
- Combine: "SCHED-5559-master-projection-job-behaves-abnormally-in-nvd"
- Check length: 60 characters (exactly at limit, OK!)

Output: `SCHED-5559-master-projection-job-behaves-abnormally-in-nvd`

### Example 3: Ticket Number + Custom Description

Input: `SCHED-5559 'Clean some Expired flags'`

Process:
- Extract ticket number: "SCHED-5559"
- Custom description provided: "Clean some Expired flags"
- Skip Jira fetch, use custom description
- Convert: "clean-some-expired-flags"
- Combine: "SCHED-5559-clean-some-expired-flags"
- Check length: 35 characters (OK!)

Output: `SCHED-5559-clean-some-expired-flags`

### Example 4: Jira URL + Custom Description

Input: `https://alayacare.atlassian.net/browse/SCHED-5559 'Clean some Expired flags'`

Process:
- Extract ticket number: "SCHED-5559"
- Custom description provided: "Clean some Expired flags"
- Skip Jira fetch, use custom description
- Convert: "clean-some-expired-flags"
- Combine: "SCHED-5559-clean-some-expired-flags"
- Check length: 35 characters (OK!)

Output: `SCHED-5559-clean-some-expired-flags`

### Example 5: Truncation with Fetched Title

Input: `SCHED-1234`

Process:
- No custom description provided, so fetch from Jira
- Title: "This is a very long ticket title that needs to be truncated because it exceeds the character limit"
- Convert: "this-is-a-very-long-ticket-title-that-needs-to-be-truncated-because-it-exceeds-the-character-limit"
- Combine: "SCHED-1234-this-is-a-very-long-ticket-title-that-needs-to-be-truncated-because-it-exceeds-the-character-limit" (too long!)
- Truncate to 60 chars: "SCHED-1234-this-is-a-very-long-ticket-title-that-needs-to"

Output: `SCHED-1234-this-is-a-very-long-ticket-title-that-needs-to`

## Usage

The user will provide either:

**Format 1 (Fetch from Jira)**:
- A Jira ticket number (e.g., "SCHED-5559"), or
- A Jira issue URL (e.g., "https://alayacare.atlassian.net/browse/SCHED-5559")

**Format 2 (Custom Description)**:
- A Jira ticket number + description (e.g., "SCHED-5559 'Clean some Expired flags'"), or
- A Jira issue URL + description (e.g., "https://alayacare.atlassian.net/browse/SCHED-5559 'Clean some Expired flags'")

Generate and display the git branch name following the format above.
