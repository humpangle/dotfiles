#!/usr/bin/env python3
import sys
import re
import ast

from typing import Any, Sequence, Union


def escape(value: Any) -> str:
    """Escape and quote SQL values properly for MySQL."""
    if value is None:
        return "NULL"
    elif isinstance(value, str):
        # Basic escaping, might need enhancement for different SQL dialects or edge cases
        return "'" + value.replace("\\", "\\\\").replace("'", "''") + "'"
    elif isinstance(value, (int, float)):
        return str(value)
    # Consider adding support for bool, bytes, datetime, etc. if needed
    else:
        raise TypeError(f"Unsupported type for SQL parameter: {type(value)}")


def inline_parameters(sql_text: str) -> str:
    """
    Replaces '?' placeholders in SQL text with parameters found in a trailing comment.

    The parameters must be in a Python tuple or list literal format within
    a comment starting with '--' at the end of the SQL string.
    Example:
        SELECT * FROM users WHERE name = ? AND age = ?; -- ('Alice', 30)
    """
    # Clean trailing whitespace
    sql_text = sql_text.rstrip()

    # Regex to find a comment starting with '--' followed by a tuple or list literal
    # at the very end of the string.
    param_comment_pattern = r"--\s*(\(|\[).+(\)|\])\s*$"
    match = re.search(param_comment_pattern, sql_text)

    if not match:
        raise ValueError(
            "No parameter tuple/list found in a final comment "
            "(e.g., -- ('a', 1, None) or -- ['a', 1, None])"
        )

    param_comment = match.group(0)
    param_str = match.group(0).strip()[2:].strip()  # Extract the tuple/list part

    try:
        parameters = ast.literal_eval(param_str)
        if not isinstance(parameters, (list, tuple)):
            raise TypeError("Parameters must be a tuple or list.")
    except (ValueError, SyntaxError, TypeError) as e:
        raise ValueError(
            f"Could not parse parameters from comment: {param_str}. Error: {e}"
        )

    # Remove the parameter comment from the SQL body
    sql_body = sql_text[: -len(param_comment)].rstrip()

    param_index = 0
    parameters_len = len(parameters)

    def replacer(match_obj: re.Match) -> str:
        """Replaces the next '?' with an escaped parameter."""
        nonlocal param_index
        if param_index >= parameters_len:
            raise ValueError(
                f"More placeholders ('?') found than parameters provided ({parameters_len})."
            )
        try:
            value = escape(parameters[param_index])
        except TypeError as e:
            # Propagate type errors from escape function
            raise TypeError(f"Error escaping parameter at index {param_index}: {e}")

        param_index += 1
        return value

    # Use a more robust regex for '?' that avoids matching inside quotes or comments
    # This is a simplified version; a full SQL parser would be more robust.
    # It looks for '?' not preceded by a single quote (') or backslash (\).
    # This is NOT foolproof for complex SQL.
    # A truly robust solution often requires context-aware parsing.
    # For this script's likely use case (simple queries), this might suffice.
    # Consider using a dedicated SQL parsing library for complex cases.
    try:
        # We'll stick to the simple `re.sub` for now, assuming '?' aren't in literals/comments.
        # If that assumption is wrong, this needs a more complex replacement strategy.
        result = re.sub(r"\?", replacer, sql_body)
    except ValueError as e:
        # Catch errors from replacer (e.g., too many placeholders)
        raise e  # Re-raise the specific error

    if param_index < parameters_len:
        raise ValueError(
            f"Fewer placeholders ('?') found than parameters provided "
            f"({param_index} used, {parameters_len} provided)."
        )

    return result


def main() -> None:
    """
    Main entry point for the script. Parses arguments, reads SQL,
    inlines parameters, and prints the result or errors.
    """
    if "--help" in sys.argv or "-h" in sys.argv:
        print("Usage: inline_sql_params.py [optional-sql-file.sql]")
        print("Replaces '?' placeholders in SQL with parameters from a final comment.")
        print("Parameters must be in a Python tuple/list literal (e.g., -- ('a', 1)).")
        print("If no file is given, reads from stdin.")
        sys.exit(0)

    sql_text = ""
    if len(sys.argv) == 2:
        try:
            with open(sys.argv[1], "r", encoding="utf-8") as f:
                sql_text = f.read()
        except FileNotFoundError:
            print(f"[ERROR] File not found: {sys.argv[1]}", file=sys.stderr)
            sys.exit(1)
        except IOError as e:
            print(
                f"[ERROR] Could not read file: {sys.argv[1]}. Error: {e}",
                file=sys.stderr,
            )
            sys.exit(1)
    elif len(sys.argv) == 1:
        try:
            sql_text = sys.stdin.read()
        except Exception as e:
            print(f"[ERROR] Could not read from stdin. Error: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        print("[ERROR] Too many arguments.", file=sys.stderr)
        print("Usage: inline_sql_params.py [optional-sql-file.sql]", file=sys.stderr)
        sys.exit(1)

    if not sql_text.strip():
        print("[ERROR] Input SQL is empty.", file=sys.stderr)
        sys.exit(1)

    try:
        inlined_sql = inline_parameters(sql_text)
        print(inlined_sql)
    except (ValueError, TypeError) as e:
        print(f"[ERROR] {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
