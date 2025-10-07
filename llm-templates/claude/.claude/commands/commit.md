# /commit

Create a git commit with staged.

## Usage

```
/commit
```

## Process

1. **Review staged changes**
   - Run `git diff --no-ext-diff --staged` to review what will be committed
   - Note: Will NOT stage any unstaged files - only commits what is already staged

2. **Draft commit message**:
   - **Subject**: ~120 chars, no trailing period
   - **Body**: Multi-line explanation of why changes were made (wrap ~120 chars)

3. **Get user approval**:
   - Present the draft commit message to the user
   - Wait for explicit confirmation (Yes/yes/y to proceed, No/no/n to cancel)

4. **Execute commit**:
   - Only after user approval, run: `git commit -m "<subject>" -m "<body>"`

## Example

```
Add validation for visit scheduling conflicts

Implemented validation logic to prevent double-booking of caregivers during overlapping visit times. This ensures
proper resource allocation and prevents scheduling conflicts that could impact care delivery.
```

## Important Notes

- **NEVER** stage changes unless explicitly instructed
- **NEVER** commit without user approval
- Only commits already staged changes
