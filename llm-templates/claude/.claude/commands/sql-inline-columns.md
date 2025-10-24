---
name: sql-inline-columns
description: Inline SQL column names as comments next to their values
---

Convert SQL statements (INSERT, UPDATE, SELECT, etc.) to inline column names as comments next to their corresponding values, making the SQL more readable and maintainable.

The location should be in the format:
- path/to/file.sql                      - for the whole file
- path/to/file.sql:start_line-end_line  - for specific line range

When converting:
- Add column names as inline comments (`-- column_name`) after each value/expression
- Align comments for better readability
- Preserve the original column order from the statement
- Keep the same indentation and formatting
- Handle NULL values appropriately
- Maintain trailing commas on all lines except the last value/expression
- Support multiple SQL statement types:
  - INSERT: VALUES clause values
  - UPDATE: SET clause assignments
  - SELECT: column expressions in SELECT clause
  - Other statements with column references

Examples:

**INSERT Statement:**
```sql
-- Before
INSERT INTO tbl_schedule_rrules (
  rrule,
  start_at,
  end_at,
  guid,
  guid_to,
  type
) VALUES (
  'FREQ=DAILY;UNTIL=20251026T040000Z',
  '2025-10-24 08:00:00',
  '2025-10-26 04:00:00',
  NULL,
  3084,
  'mastering'
);

-- After
INSERT INTO tbl_schedule_rrules (
  rrule,
  start_at,
  end_at,
  guid,
  guid_to,
  type
) VALUES (
  'FREQ=DAILY;UNTIL=20251026T040000Z', -- rrule
  '2025-10-24 08:00:00', -- start_at
  '2025-10-26 04:00:00', -- end_at
  NULL, -- guid
  3084, -- guid_to
  'mastering' -- type
);
```

**UPDATE Statement:**
```sql
-- Before
UPDATE tbl_schedule_rrules SET
  rrule = 'FREQ=WEEKLY;UNTIL=20251231T040000Z',
  start_at = '2025-11-01 09:00:00',
  end_at = '2025-12-31 04:00:00',
  type = 'updated'
WHERE guid = 1234;

-- After
UPDATE tbl_schedule_rrules SET
  rrule = 'FREQ=WEEKLY;UNTIL=20251231T040000Z', -- rrule
  start_at = '2025-11-01 09:00:00', -- start_at
  end_at = '2025-12-31 04:00:00', -- end_at
  type = 'updated' -- type
WHERE guid = 1234;
```

**SELECT Statement:**
```sql
-- Before
SELECT
  rrule,
  start_at,
  end_at,
  guid,
  guid_to,
  type
FROM tbl_schedule_rrules
WHERE type = 'mastering';

-- After
SELECT
  rrule, -- rrule
  start_at, -- start_at
  end_at, -- end_at
  guid, -- guid
  guid_to, -- guid_to
  type -- type
FROM tbl_schedule_rrules
WHERE type = 'mastering';
```

Benefits:
- Makes it easy to verify that values match their intended columns
- Improves maintainability when columns are added/removed
- Helps catch copy-paste errors in multi-row inserts and complex updates
- Provides self-documentation for complex queries
- Particularly useful for statements with many columns
- Works across different SQL statement types (INSERT, UPDATE, SELECT, etc.)
- Reduces cognitive load when reviewing SQL code

Note: This pattern is especially valuable for SQL statements with 10+ columns where visual alignment between column definitions and values becomes difficult. It's particularly useful for data migration scripts, complex updates, and analytical queries.
