---
name: py-dict-convert
description: Convert dictionary literal to dict() constructor
---

Convert the dictionary literal at {{FILE_LOCATION}} to use `dict()` constructor syntax instead of curly braces `{}`.

The location should be in the format:
- path/to/file.py                      - for the whole file
- path/to/file.py:start_line-end_line  - for specific line range

When converting:
- Change from `{"key": value}` or `{key: value}` to `dict(key=value)`
- Remove quotes from keys when they become keyword arguments
- Keep the same indentation and formatting
- Preserve any conditional expressions or complex values
- Maintain the same variable assignment
- Convert nested dictionaries recursively

Example:
```python
# Before
data = {
    "name": "John",
    "age": 30,
    "metadata": {
        "id": 123,
        "active": True
    }
}

# After
data = dict(
    name="John",
    age=30,
    metadata=dict(
        id=123,
        active=True
    )
)
```

Note: This conversion works best for simple dictionaries with string keys that are valid Python identifiers.
