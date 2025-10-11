# /pytest-modernize-parametrize

Convert pytest.mark.parametrize decorators to use modern argnames/argvalues/pytest.param() pattern.

## Usage

```
/pytest-modernize-parametrize <test_file_path>
/pytest-modernize-parametrize <test_file_path> <start_line>-<end_line>
/pytest-modernize-parametrize <test_file_path:start_line-end_line>
```

## Arguments

- `test_file_path`: Path to the Python test file containing pytest.mark.parametrize decorators
- `start_line-end_line` (optional): Line range to apply conversion
  - Can be specified as separate argument: `<test_file_path> 187-278`
  - Or combined with path using colon: `<test_file_path:187-278>`

## What It Does

Converts the old pytest.mark.parametrize format:

```python
@pytest.mark.parametrize(
    "param1, param2, param3",
    [
        (value1, value2, value3),
        (value4, value5, value6),
    ],
    ids=("test_id_1", "test_id_2"),
)
```

To the modern format:

```python
@pytest.mark.parametrize(
    argnames=(
        "param1",
        "param2",
        "param3",
    ),
    argvalues=(
        pytest.param(
            value1,  # param1
            value2,  # param2
            value3,  # param3
            id="test_id_1",
        ),
        pytest.param(
            value4,  # param1
            value5,  # param2
            value6,  # param3
            id="test_id_2",
        ),
    ),
)
```

## Benefits

1. **Explicit naming**: `argnames` and `argvalues` make the decorator structure clearer
2. **Type safety**: IDEs and type checkers better understand the structure
3. **Better test IDs**: Each test case has its ID right next to its data
4. **Maintainability**: Easier to add/remove/modify individual test cases
5. **Inline comments**: Each parameter value can have its own comment

## Examples

### Example 1: Convert entire file

```
/pytest-modernize-parametrize tests/test_my_feature.py
```

This will find all `@pytest.mark.parametrize` decorators in the file and convert them.

### Example 2: Convert specific decorator (separate arguments)

```
/pytest-modernize-parametrize tests/test_my_feature.py 45-89
```

This will only convert the `@pytest.mark.parametrize` decorator within lines 45-89.

### Example 3: Convert specific decorator (colon syntax)

```
/pytest-modernize-parametrize alaya/api/scheduler/v3/capabilities/recurrences/create/plugins/tests/test_recurrence_create_visits_plugin.py:187-278
```

This will only convert the `@pytest.mark.parametrize` decorator within lines 187-278. The colon syntax is convenient when copying line references from editors or git diffs.

### Example 4: Before and After

**Before:**
```python
@pytest.mark.parametrize(
    "employee_unavailable, facility_unavailable, expected_result",
    [
        (False, False, True),
        (True, False, False),
        (False, True, False),
    ],
    ids=(
        "all_available",
        "employee_unavailable",
        "facility_unavailable",
    ),
)
def test_validate_availability(employee_unavailable, facility_unavailable, expected_result):
    ...
```

**After:**
```python
@pytest.mark.parametrize(
    argnames=(
        "employee_unavailable",
        "facility_unavailable",
        "expected_result",
    ),
    argvalues=(
        pytest.param(
            False,  # employee_unavailable
            False,  # facility_unavailable
            True,  # expected_result
            id="all_available",
        ),
        pytest.param(
            True,  # employee_unavailable
            False,  # facility_unavailable
            False,  # expected_result
            id="employee_unavailable",
        ),
        pytest.param(
            False,  # employee_unavailable
            True,  # facility_unavailable
            False,  # expected_result
            id="facility_unavailable",
        ),
    ),
)
def test_validate_availability(employee_unavailable, facility_unavailable, expected_result):
    ...
```

## Implementation Steps

1. **Parse arguments**:
   - Check if argument contains `:` to detect `file_path:line_range` format
   - If colon present, split into file path and line range
   - Otherwise, treat as separate arguments: file path and optional line range
2. **Parse the file** (or line range if specified)
3. **Locate @pytest.mark.parametrize decorators**:
   - If line range specified, only process decorators starting within that range
   - If no line range, process all decorators in the file
4. **For each decorator, extract**:
   - Parameter names (from first argument)
   - Test case values (from second argument - list/tuple)
   - Test IDs (from `ids=` keyword argument if present)
5. **Convert structure**:
   - Split comma-separated parameter string into tuple of individual strings
   - Convert each tuple/list test case into `pytest.param()` call
   - Move corresponding ID from `ids` tuple into each `pytest.param(id=...)`
   - Add inline comments for each parameter value
   - Preserve any existing comments (e.g., "# employee unavailable")
6. **Replace the old decorator** with the new format
7. **Run black formatter** to ensure consistent formatting
8. **Run relevant tests** to verify the conversion didn't break anything

## Conversion Rules

### Parameter Names
- **From**: `"param1, param2, param3"` (comma-separated string)
- **To**: `argnames=("param1", "param2", "param3",)` (tuple of strings)
- **Note**: Remove spaces, each parameter on its own line

### Test Cases
- **From**: List/tuple of tuples: `[(val1, val2), (val3, val4)]`
- **To**: Tuple of pytest.param: `argvalues=(pytest.param(val1, val2, id="..."), ...)`
- **Note**: Each value gets inline comment indicating which parameter

### Test IDs
- **From**: Separate `ids=(...)` keyword argument
- **To**: `id="..."` inside each `pytest.param()`
- **Note**: Match IDs to test cases by position

### Inline Comments
- Add inline comment after each parameter value
- Format: `value,  # parameter_name`
- Preserves readability and makes test data self-documenting

## Edge Cases to Handle

1. **Multi-line string parameters**: Keep them on multiple lines
2. **Complex data structures**: Lists, dicts, etc. - preserve formatting
3. **Existing inline comments**: Preserve or replace with parameter name
4. **Descriptive comments**: Keep comments like "# test case for X" above pytest.param
5. **No IDs provided**: Generate IDs or omit `id=` parameter
6. **Mixed tuple/list syntax**: Handle both `[]` and `()` for test cases

## Important Notes

- **ALWAYS** run the test suite after conversion to verify correctness
- **ALWAYS** run black formatter after conversion for consistent style
- **PRESERVE** all existing functionality - this is a pure refactoring
- **MAINTAIN** inline comments for parameter values
- If a decorator is already in the new format, skip it (idempotent)

## Validation

After conversion, verify:
1. All tests still pass (or fail in the same way as before)
2. Test IDs are correctly assigned
3. Parameter names match function signature
4. Code is properly formatted
5. No syntax errors introduced