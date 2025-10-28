# /explain-code

Provide a deep, intuitive explanation of a code section that helps you understand not just *what* the code does, but *why* it works that way and *how* to think about it.

## Usage

```
/explain-code <file_path>:<start_line>-<end_line>
/explain-code <file_path>:<line_number>
/explain-code @<file_path>:<start_line>-<end_line>
```

## Arguments

- `file_path`: Path to the file containing the code to explain
- `start_line`: Starting line number of the code section
- `end_line`: Ending line number of the code section
- `line_number`: Single line to explain (will expand to include context)

## Examples

```
/explain-code alaya/api/scheduler/v3/helpers/unavailability_helpers.py:137-167
/explain-code @src/components/Calendar.tsx:45-89
/explain-code lib/scheduler/conflict_checker.ex:120-150
/explain-code services/visit_service.go:234
```

## Output Format

The explanation will be written to `.___scratch/llm-outs/YYYYMMDD-HHMMSS-<description>.txt` and include:

### 1. **The Big Picture**
- What problem does this code solve?
- Why does this code exist?
- What's the business/user value?

### 2. **Core Intuition**
- A mental model or metaphor to understand the approach
- Visual analogies (e.g., "Think of it like painting on a canvas...")
- The key insight that makes everything click

### 3. **Step-by-Step Breakdown**
For each logical section:
- **What it does** (the mechanics)
- **Why it does it that way** (the reasoning)
- **Intuition** (how to think about it)
- Code snippets with line numbers

### 4. **Visual Examples**
- Concrete examples with sample data
- Before/after states
- Step-by-step execution traces
- ASCII diagrams or tables where helpful

### 5. **Key Design Decisions**
- Why this approach vs alternatives?
- What trade-offs were made?
- What patterns or principles are used?
- Edge cases and how they're handled

### 6. **Common Use Cases**
- Real-world scenarios where this code runs
- Example invocations with parameters
- Expected inputs and outputs

### 7. **Gotchas and Bugs**
- Potential issues or bugs in the code
- Edge cases that might not be handled
- Performance considerations
- Areas for improvement

## Implementation Guidelines

### Language-Agnostic Approach

The explanation should work for any programming language:

**Python:**
```python
# Focus on: list comprehensions, generators, decorators, context managers
# Explain: duck typing, EAFP vs LBYL, pythonic idioms
```

**JavaScript/TypeScript:**
```javascript
// Focus on: promises, async/await, closures, prototypes
// Explain: event loop, this binding, hoisting
```

**Go:**
```go
// Focus on: goroutines, channels, defer, interfaces
// Explain: concurrency patterns, error handling, composition
```

**Elixir:**
```elixir
# Focus on: pattern matching, pipelines, processes, OTP
# Explain: immutability, message passing, supervision trees
```

**Java:**
```java
// Focus on: streams, optionals, generics, annotations
// Explain: OOP principles, design patterns, memory management
```

### Explanation Depth Levels

Automatically adjust depth based on code complexity:

**Simple (5-15 lines):**
- Brief overview
- Key concept explanation
- One concrete example

**Medium (15-50 lines):**
- Detailed breakdown
- Multiple examples
- Design rationale
- Common use cases

**Complex (50+ lines):**
- Comprehensive analysis
- Visual diagrams
- Multiple examples
- Architecture context
- Performance implications
- Alternative approaches

### Visual Aids to Include

1. **State Transitions:**
```
Initial state: [A, B, C]
After step 1:  [A', B, C]
After step 2:  [A', B', C]
Final state:   [A', B', C']
```

2. **Data Flow:**
```
Input → [Transform 1] → [Transform 2] → Output
```

3. **Tree/Hierarchy:**
```
Parent
  ├─> Child 1
  │   ├─> Grandchild 1a
  │   └─> Grandchild 1b
  └─> Child 2
```

4. **Tables:**
```
┌──────────────┬──────────┬──────────┐
│ Parameter    │ Value    │ Result   │
├──────────────┼──────────┼──────────┤
│ with_cache=1 │ "hello"  │ ✅ Fast  │
│ with_cache=0 │ "hello"  │ ⚠️ Slow  │
└──────────────┴──────────┴──────────┘
```

5. **Timeline:**
```
T=0: Request arrives
T=1: Validate input
T=2: Query database
T=3: Transform result
T=4: Return response
```

### Context to Gather

Before explaining, gather:

1. **Function/method signature and docstring**
2. **Surrounding context** (10-20 lines before/after)
3. **Related types/classes** (data structures used)
4. **Test files** (to understand expected behavior)
5. **Usage examples** (where this code is called)
6. **Related documentation** (README, comments)

### Explanation Structure Template

```markdown
# Explanation: <function_name>() - Lines <start>-<end>

## The Big Picture: What Problem Does This Solve?

[Business context and user value]

## The Core Intuition: [Metaphor/Mental Model]

[The key insight that makes everything click]

## Step-by-Step Breakdown

### Step 1: [Name] (lines X-Y)
```[language]
[code snippet]
```

**Intuition:** [How to think about this step]

**Why this way?** [Design rationale]

**Example:**
```
[Concrete example with data]
```

[Repeat for each step]

## Visual Example: Full Walkthrough

[Complete example with state transitions]

## Key Design Decisions

1. **Why [approach]?**
   - [Reasoning]
   
2. **Trade-offs:**
   - Pros: [benefits]
   - Cons: [drawbacks]

## Common Use Cases

### Use Case 1: [Name]
```[language]
[example code]
```
[Explanation]

## Gotchas and Edge Cases

- ⚠️ [Potential issue]
- 🐛 [Bug found]
- 💡 [Improvement suggestion]

## Summary

[One-paragraph summary of the key takeaway]
```

## Process

1. **Read the code section**
   - Get the specified lines
   - Read surrounding context (±20 lines)
   - Identify the function/class/module

2. **Gather context**
   - Find related tests
   - Search for usage examples
   - Check for documentation
   - Identify data structures used

3. **Analyze the code**
   - Identify the main purpose
   - Break down into logical steps
   - Find the key algorithm or pattern
   - Note design decisions

4. **Create mental model**
   - Develop an intuitive metaphor
   - Think of visual representations
   - Consider real-world analogies

5. **Write explanation**
   - Start with big picture
   - Provide core intuition
   - Break down step-by-step
   - Include visual examples
   - Document design decisions
   - List use cases
   - Note gotchas

6. **Save to file**
   - Create `.___scratch/llm-outs/` if needed
   - Use timestamp: `YYYYMMDD-HHMMSS-<description>.txt`
   - Include all sections
   - Format for readability

## Quality Checklist

Before finalizing, ensure the explanation:

- ✅ Answers "What problem does this solve?"
- ✅ Provides an intuitive mental model
- ✅ Includes concrete examples with data
- ✅ Explains design decisions and trade-offs
- ✅ Shows visual representations
- ✅ Covers common use cases
- ✅ Notes potential issues or bugs
- ✅ Is understandable to someone new to the codebase
- ✅ Uses language-appropriate terminology
- ✅ Includes code snippets with line numbers

## Important Notes

- **Always write output to file** in `.___scratch/llm-outs/`
- **Never assume knowledge** - explain like teaching a colleague
- **Use metaphors and analogies** - make abstract concepts concrete
- **Show, don't just tell** - include examples and visual aids
- **Be language-aware** - use idioms and patterns specific to the language
- **Find the "aha!" moment** - the key insight that makes it all make sense
- **Balance depth and clarity** - comprehensive but not overwhelming
- **Highlight gotchas** - point out non-obvious behavior or bugs

## Example Invocations

### Python - Complex Algorithm
```
/explain-code alaya/api/scheduler/v3/helpers/unavailability_helpers.py:137-167
```
Output: Explains interval tree manipulation with canvas painting metaphor

### JavaScript - React Component
```
/explain-code @src/components/VisitCalendar.tsx:89-145
```
Output: Explains state management and rendering logic with UI flow diagrams

### Go - Concurrency Pattern
```
/explain-code services/scheduler/worker_pool.go:45-98
```
Output: Explains goroutine coordination with assembly line metaphor

### Elixir - GenServer
```
/explain-code lib/scheduler/conflict_checker.ex:120-180
```
Output: Explains process message handling with mailbox metaphor

### Java - Design Pattern
```
/explain-code src/main/java/scheduler/VisitFactory.java:67-112
```
Output: Explains factory pattern with object creation flow

## Tips for Best Results

1. **Specify exact line ranges** - more precise = better explanation
2. **Include context** - if confused, expand the range by ±10 lines
3. **Ask follow-up questions** - "Can you explain the X part more?"
4. **Request specific focus** - "Focus on the performance implications"
5. **Compare alternatives** - "Why this approach vs using a simple loop?"
