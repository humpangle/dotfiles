---
name: py-dict-convert
description: Convert dictionary literal to dict() constructor
---

Convert the dictionary literal at {{FILE_LOCATION}} to use `dict()` constructor syntax instead of curly braces `{}`.

The location should be in the format: `path/to/file.py:start_line-end_line`

When converting:
- Change from `{key: value}` to `dict(key=value)`
- Keep the same indentation and formatting
- Preserve any conditional expressions or complex values
- Maintain the same variable assignment
