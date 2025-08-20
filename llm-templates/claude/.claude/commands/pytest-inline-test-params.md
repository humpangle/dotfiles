# Inline Test Parameters

Add inline comments for each parameter value in all pytest.mark.parametrize test cases in the specified file.

## Usage
```
/pytest-inline-test-params <test_file_path>
```

## Description
This command will:
1. Find all test functions that use `@pytest.mark.parametrize` 
2. Extract the parameter names from the parametrize decorator
3. Add inline comments after each parameter value indicating which parameter it represents
4. Replace any existing inline comments with the latest parameter names

## Examples

### Example 1: Using pytest.param()
Given a test like:
```python
@pytest.mark.parametrize(
    "param1,param2,param3",
    [
        pytest.param(
            True,
            False,
            "value",
            id="test case 1"
        ),
    ]
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "param1,param2,param3",
    [
        pytest.param(
            True,  # param1
            False,  # param2
            "value",  # param3
            id="test case 1"
        ),
    ]
)
```

### Example 2: Using tuples
Given a test like:
```python
@pytest.mark.parametrize(
    "rrule_str, projection_start_at, visit_duration",
    [
        (
            "DTSTART:20240101T000000Z\nRRULE:FREQ=DAILY",
            "2024-01-01T00:00:00Z",
            60,
        ),
    ]
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "rrule_str, projection_start_at, visit_duration",
    [
        (
            "DTSTART:20240101T000000Z\nRRULE:FREQ=DAILY",  # rrule_str
            "2024-01-01T00:00:00Z",  # projection_start_at
            60,  # visit_duration
        ),
    ]
)
```

## Implementation

1. Read the test file specified by the user
2. Find all occurrences of `@pytest.mark.parametrize` decorators
3. For each parametrize decorator:
   - Extract the parameter names from the first argument (handling both string and list formats)
   - Find all test cases within the decorator (both `pytest.param()` calls and plain tuples)
   - For each test case, add or update inline comments after each value
   - For pytest.param calls, skip the `id` parameter
4. Apply all edits to the file

The command handles:
- Multiple test functions in a single file
- Both `pytest.param()` and plain tuple test cases
- Different parametrize formats (comma-separated string or list)
- Preserving existing indentation
- Replacing existing inline comments if present
- Skipping the `id` parameter in pytest.param calls
- Multi-line parameter values (like dictionaries or long strings)