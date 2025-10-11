# /pytest-inline-test-params

Add inline comments for each parameter value in all pytest.mark.parametrize test cases in the specified file.

**IMPORTANT**: Each parameter value must be on its own line with an inline comment indicating which parameter it represents. This makes tests much more readable and maintainable.

## Usage
```
/pytest-inline-test-params <test_file_path>
```

## Arguments

- `test_file_path`: Path to the Python test file containing pytest.mark.parametrize decorators

## Examples

### Example 1: Single-line tuples (must be expanded)
Given a test like:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (True, False, 20),
        (False, True, None),
    ]
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (
            True,  # p1
            False,  # p2
            20,  # p3
        ),
        (
            False,  # p1
            True,  # p2
            None,  # p3
        ),
    ]
)
```

### Example 2: Multi-line tuples without comments
Given a test like:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (
            "F",
            "2",
            6,
        ),
    ]
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (
            "F",  # p1
            "2",  # p2
            6,  # p3
        ),
    ]
)
```

### Example 3: Tuples with wrong comment placement
Given a test like:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (
            True,
            False,
            20,
        ),  # p1, p2, p3
    ]
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        (
            True,  # p1
            False,  # p2
            20,  # p3
        ),
    ]
)
```

### Example 4: Using pytest.param()
Given a test like:
```python
@pytest.mark.parametrize(
    "p1,p2,p3",
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
    "p1,p2,p3",
    [
        pytest.param(
            True,  # p1
            False,  # p2
            "value",  # p3
            id="test case 1"
        ),
    ]
)
```

### Example 5: Multiple test cases with comments
Given a test like:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        # no calendar events, employee unavailable
        (
            [],
            SETTING_EMPLOYEE_UNAVAILABLE,
            [(10, 20), (30, 40)],
            [True, True],
        ),
        # one calendar unavailability
        (
            [(5, 10, RRuleTypes.UNAVAILABILITY)],
            SETTING_EMPLOYEE_AVAILABLE,
            [(8, 15), (20, 30)],
            [True, False],
        ),
    ],
)
```

It will be transformed to:
```python
@pytest.mark.parametrize(
    "p1, p2, p3",
    [
        # no calendar events, employee unavailable
        (
            [],  # p1
            SETTING_EMPLOYEE_UNAVAILABLE,  # p2
            [True, True],  # p3
        ),
        # one calendar unavailability
        (
            [(5, 10, RRuleTypes.UNAVAILABILITY)],  # p1
            SETTING_EMPLOYEE_AVAILABLE,  # p2
            [True, False],  # p3
        ),
    ],
)
```

## Implementation Details

1. Read the test file specified by the user
2. Find all occurrences of `@pytest.mark.parametrize` decorators
3. For each parametrize decorator:
   - Extract the parameter names from the first argument (handling both string and list formats)
   - Find all test cases within the decorator (both `pytest.param()` calls and plain tuples/lists)
   - **For each test case, ensure each parameter value is on its own line with an inline comment**
   - Expand single-line tuples to multi-line format
   - Replace end-of-tuple comments with inline comments per parameter
   - For pytest.param calls, skip the `id` parameter
4. Apply all edits to the file
5. Run black formatter to ensure consistent formatting

The command handles:
- Multiple test functions in a single file
- Both `pytest.param()` and plain tuple test cases
- Different parametrize formats (comma-separated string or list)
- Preserving existing indentation
- Replacing existing inline comments if present
- Expanding single-line tuples to multi-line format
- Moving end-of-tuple comments to inline per-parameter comments
- Skipping the `id` parameter in pytest.param calls
- Multi-line parameter values (like dictionaries or long strings)
- Preserving descriptive comments before test cases (e.g., "# employee unavailable")
