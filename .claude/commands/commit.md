# /commit [JIRA-TICKET]

Create a git commit with staged.

## Usage

```
/commit SCHED-1234    # Provide JIRA ticket directly
/commit               # Auto-detect JIRA ticket
```

## Process

1. **Review staged changes**
   - Run `git diff --no-ext-diff --staged` to review what will be committed
   - Note: Will NOT stage any unstaged files - only commits what is already staged

2. **Determine JIRA ticket number**:
   - If provided as argument, use it directly
   - Otherwise, check in this order:
     - Environment variable: `echo $JIRA_TICKET_NUMBER`
     - Git branch name prefix (e.g., `feature/SCHED-1234-description` → `SCHED-1234`)

3. **Draft commit message**:
   - **Subject**: ~120 chars, no trailing period, starts with JIRA ticket # if available
   - **Body**: Multi-line explanation of why changes were made (wrap ~120 chars)
   - If no JIRA ticket found, omit the prefix

4. **Get user approval**:
   - Present the draft commit message to the user
   - Wait for explicit confirmation (Yes/yes/y to proceed, No/no/n to cancel)

5. **Execute commit**:
   - Only after user approval, run: `git commit -m "<subject>" -m "<body>"`

## Example

```
SCHED-4192 Add validation for visit scheduling conflicts

Implemented validation logic to prevent double-booking of caregivers
during overlapping visit times. This ensures proper resource allocation
and prevents scheduling conflicts that could impact care delivery.
```

## Important Notes

- **NEVER** stage changes unless explicitly instructed
- **NEVER** commit without user approval
- Only commits already staged changes
