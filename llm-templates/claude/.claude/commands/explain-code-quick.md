# /explain-code-quick

Quick, concise explanation of a code section. Less detailed than `/explain-code`, focused on the core intuition and key points.

## Usage

```
/explain-code-quick <file_path>:<start_line>-<end_line>
```

## Examples

```
/explain-code-quick scheduler.py:137-167
/explain-code-quick @Calendar.tsx:45-89
```

## Output Format

The explanation will be written to `.___scratch/llm-outs/YYYYMMDD-HHMMSS-<description>-quick.md (use emojis for visual scanning)` and include:

1. **One-sentence summary** - What does this code do?
2. **Core intuition** - The key mental model
3. **Key points** - 3-5 bullet points of important details
4. **One example** - Quick concrete example

## When to Use

- ✅ Quick understanding of unfamiliar code
- ✅ During code review for context
- ✅ When you just need the gist
- ✅ Time-sensitive situations

Use `/explain-code` (without -quick) for:
- 📚 Deep learning and documentation
- 🔍 Complex algorithms needing detailed breakdown
- 📖 Onboarding materials
- 🐛 Debugging complex issues

## Example Output

```
**Summary:** Finds the next scheduled visit for a patient.

**Intuition:** Think of it as querying a patient's calendar and asking "What's the next appointment?"

**Key Points:**
- Joins Visit with Service to filter by patient_id
- Filters for future visits only (start_at >= now)
- Orders by start time and returns the earliest
- Optional filters: exclude cancelled, limit to N days
- ⚠️ Bug on line 1435: always excludes cancelled when limit_days is set

**Example:**
Patient has visits on Tuesday, Wednesday, Next Monday
→ Returns Tuesday's visit (earliest future visit)
```

## Process

1. Read the specified code section
2. Identify the main purpose
3. Create a simple mental model
4. List 3-5 key points
5. Provide one concrete example
6. Output directly in chat (no file)
