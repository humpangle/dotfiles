# /explain-component-feature-flow

Generate a comprehensive, beginner-friendly explanation of how a feature works from end-to-end, including all components, data flow, and user interactions.

## Usage

```
/explain-component-feature-flow @<component_file> [@<related_file>...] [--focus=<aspect>]
```

## Arguments

- `component_file`: Main component or module file(s) that power the feature (required)
- `related_file`: Additional related files (tests, helpers, etc.) (optional)
- `--focus`: Specific aspect to emphasize: `architecture`, `data-flow`, `user-journey`, `validation`, `all` (default: `all`)

## Examples

```
/explain-component-feature-flow @web/js/vue-components/common/rrule/rrule-generator.vue @web/js/vue-components/common/rrule/rrule-generator.test.js
/explain-component-feature-flow @src/components/Calendar.tsx @src/hooks/useCalendar.ts --focus=data-flow
/explain-component-feature-flow @lib/scheduler/visit_creator.ex @lib/scheduler/recurrence.ex --focus=user-journey
/explain-component-feature-flow @services/visit/handler.go @services/visit/validator.go --focus=validation
```

## Output Format

The explanation will be written to `.___scratch/llm-outs/YYYYMMDD-HHMMSS-<feature-name>-comprehensive-guide.md` and include:

### 1. **What is This Feature?**
- High-level overview for complete beginners
- Real-world analogy or metaphor
- Why this feature exists (business value)
- Quick example of what it does

### 2. **Core Concepts**
- Key terminology explained simply
- Fundamental principles
- Industry standards (if applicable)
- Visual diagrams of core concepts

### 3. **Component Architecture**
- Component/module structure
- Visual diagram of UI (if applicable)
- Key props/inputs and outputs
- Configuration options
- Integration points

### 4. **Data Flow Architecture**
- The big picture diagram
- Step-by-step flow from user action to result
- Initialization phase
- User interaction phase
- Validation phase
- Processing phase
- Output/broadcast phase

### 5. **User Journey**
- Real-world scenario walkthrough
- Step-by-step user actions
- What the system does at each step
- UI updates and feedback
- Final result

### 6. **Technical Deep Dive**
- Design patterns used
- State management
- Key algorithms or logic
- Performance considerations
- Error handling

### 7. **Validation Logic**
- Validation layers
- Field-level validation
- Cross-field validation
- Business logic validation
- Error messages and UX

### 8. **Real-World Examples**
- Simple use case
- Complex use case
- Edge case handling
- Template or reusable patterns (if applicable)

### 9. **Common Pitfalls & Edge Cases**
- Known issues and solutions
- Timezone/date handling
- Boundary conditions
- Performance gotchas
- User error scenarios
- How the system handles each

### 10. **Summary**
- Key takeaways
- Mental model recap
- Further reading/references

## Implementation Guidelines

### Beginner-Friendly Approach

**Always assume the reader is new to:**
- The codebase
- The domain/business logic
- The specific technology stack
- Industry standards being used

**Use these techniques:**
1. **Analogies:** Compare to everyday concepts
   - "Think of it like setting a recurring alarm on your phone"
   - "It's like a recipe that tells the computer..."

2. **Visual Aids:** Include ASCII diagrams
   ```
   ???????????????
   ?   User      ?
   ???????????????
          ? clicks button
          ?
   ???????????????
   ?  Component  ?
   ???????????????
   ```

3. **Examples First:** Show concrete examples before abstractions
   ```
   Example: "every Monday and Wednesday at 2 PM"
   Abstract: FREQ=WEEKLY;BYDAY=MO,WE;...
   ```

4. **Progressive Disclosure:** Start simple, add complexity gradually
   - Level 1: What it does
   - Level 2: How it does it
   - Level 3: Why it does it that way

### Structure Template

```markdown
# [Feature Name] - Complete Beginner's Guide

**Generated:** YYYY-MM-DD HH:MM:SS

---

## ?? What is This Feature?

[Analogy-based explanation]

---

## ?? Table of Contents

[Auto-generated from sections]

---

## ?? Core Concepts

### [Concept 1]

**Simple Explanation:** [Everyday language]

**Technical Definition:** [Precise definition]

**Example:** [Concrete example]

### [Concept 2]

[...]

---

## ?? [Component Name] Component

[Visual diagram of UI or structure]

### Component Structure

```
[ASCII diagram showing layout]
```

### Key Props (Inputs)

| Prop | Type | Purpose | Example |
|------|------|---------|---------|
| ... | ... | ... | ... |

### Key Outputs (Events)

| Event | Payload | When Fired | Purpose |
|-------|---------|------------|---------|
| ... | ... | ... | ... |

---

## ?? Data Flow Architecture

### The Big Picture

```
[ASCII diagram of full flow]
```

### Step-by-Step Flow

#### 1. **Initialization Phase**

[Code example]

**What happens:**
- [Bullet points]

#### 2. **User Interaction Phase**

[Code example]

**What happens:**
- [Bullet points]

[Continue for each phase]

---

## ?? User Journey

### Scenario
[Real-world scenario description]

### Step 1: [Action]
User [does something]

**System Action:**
```[language]
[code showing what happens]
```

**UI Updates:**
- [What user sees]

[Continue for each step]

---

## ?? Technical Deep Dive

### [Pattern/Concept 1]

[Explanation with code examples]

**Why?** [Rationale]

### [Pattern/Concept 2]

[...]

---

## ? Validation Logic

### Validation Layers

#### Layer 1: Field-Level Validation

```[language]
[code example]
```

#### Layer 2: Cross-Field Validation

[...]

### Validation Messages

[Examples of error messages and when they appear]

### Validation Triggers

[When and how validation runs]

---

## ?? Real-World Examples

### Example 1: [Simple Case]

**Scenario:** [Description]

**User Input:**
- [Inputs]

**Generated Output:**
```
[Output]
```

**Result:** [What happens]

---

### Example 2: [Complex Case]

[...]

---

## ?? Common Pitfalls & Edge Cases

### 1. [Issue Name]

**Problem:** [Description]

**Why:** [Root cause]

**Solution:**
```[language]
[code showing fix]
```

**Result:** [Outcome]

[Continue for each pitfall]

---

## ?? Summary

[Comprehensive summary paragraph]

**Key Takeaway:** [One-sentence essence]

---

## ?? Further Reading

- [Relevant documentation links]
- [Standards or specifications]
- [Related libraries or tools]

---

**Document Version:** 1.0
**Last Updated:** YYYY-MM-DD
**Author:** AI Assistant
```

## Process

1. **Analyze the feature**
   - Read all provided files
   - Identify the main component/module
   - Find related files (tests, helpers, integrations)
   - Search for usage examples in the codebase

2. **Understand the domain**
   - What problem does this solve?
   - Who are the users?
   - What's the business context?
   - What industry standards apply?

3. **Map the flow**
   - Trace user interactions
   - Follow data transformations
   - Identify validation points
   - Track state changes
   - Note integration points

4. **Create visual aids**
   - UI layout diagrams
   - Data flow diagrams
   - State transition diagrams
   - Sequence diagrams
   - Tables for complex data

5. **Develop analogies**
   - Find everyday comparisons
   - Create mental models
   - Simplify complex concepts
   - Make abstract concrete

6. **Write examples**
   - Simple use case
   - Complex use case
   - Edge cases
   - Error scenarios
   - Real data examples

7. **Document pitfalls**
   - Common mistakes
   - Edge cases
   - Performance issues
   - Timezone/date issues
   - Browser/environment issues

8. **Generate output**
   - Create `.___scratch/llm-outs/` if needed
   - Use timestamp: `YYYYMMDD-HHMMSS-<feature>-comprehensive-guide.md`
   - Include all sections
   - Format with markdown
   - Add emojis for visual scanning

## Context to Gather

Before writing, gather:

1. **Component/Module Files**
   - Main implementation
   - Tests (understand expected behavior)
   - Type definitions (understand data structures)
   - Styles (understand UI)

2. **Related Code**
   - Helper functions/utilities
   - Validation logic
   - State management
   - API integrations
   - Parent/child components

3. **Usage Examples**
   - Where is this used?
   - How is it configured?
   - What are common patterns?
   - What are edge cases?

4. **Documentation**
   - README files
   - Code comments
   - API documentation
   - Design documents

5. **Domain Knowledge**
   - Business requirements
   - Industry standards
   - User workflows
   - Common terminology

## Focus Options

### `--focus=architecture`
Emphasize:
- Component structure
- Design patterns
- Integration points
- Module boundaries
- Dependency flow

### `--focus=data-flow`
Emphasize:
- Data transformations
- State management
- Event flow
- API calls
- Data validation

### `--focus=user-journey`
Emphasize:
- User interactions
- UI updates
- Feedback mechanisms
- Error handling
- Success paths

### `--focus=validation`
Emphasize:
- Validation rules
- Error messages
- Edge cases
- Input sanitization
- Business logic checks

### `--focus=all` (default)
Balanced coverage of all aspects

## Quality Checklist

Before finalizing, ensure:

- ? Starts with a simple, relatable analogy
- ? Explains "why" not just "what"
- ? Includes visual diagrams (ASCII art)
- ? Has concrete examples with real data
- ? Shows complete user journey
- ? Explains technical implementation
- ? Documents validation logic
- ? Covers common pitfalls
- ? Provides real-world examples
- ? Includes summary and key takeaways
- ? Is understandable to a complete beginner
- ? Uses intuitive language and metaphors
- ? Has clear section hierarchy
- ? Includes code examples with context
- ? Shows both simple and complex cases

## Important Notes

- **Always write output to file** in `.___scratch/llm-outs/`
- **Use timestamp in filename** for versioning
- **Assume zero prior knowledge** of the codebase
- **Use analogies liberally** to explain complex concepts
- **Show, don't just tell** with examples and diagrams
- **Balance breadth and depth** - comprehensive but digestible
- **Make it scannable** with emojis, headers, and formatting
- **Include a table of contents** for easy navigation
- **End with actionable takeaways** and further reading

## Example Invocations

### Vue Component Feature
```
/explain-component-feature-flow @web/js/vue-components/common/rrule/rrule-generator.vue @web/js/vue-components/common/rrule/rrule-generator.test.js
```
Output: Complete guide to RRule recurrence feature with user journey, validation, and examples

### React Hook Pattern
```
/explain-component-feature-flow @src/hooks/useScheduler.ts @src/components/SchedulerView.tsx --focus=data-flow
```
Output: Data flow explanation of scheduler hook with state management and side effects

### Backend Service
```
/explain-component-feature-flow @services/visit/creator.go @services/visit/validator.go @services/visit/types.go --focus=architecture
```
Output: Architecture overview of visit creation service with validation pipeline

### Full Stack Feature
```
/explain-component-feature-flow @api/scheduler/views.py @frontend/components/Scheduler.tsx @api/scheduler/serializers.py
```
Output: End-to-end feature explanation from API to UI

## Tips for Best Results

1. **Include test files** - they show expected behavior and edge cases
2. **Add helper files** - they reveal supporting logic and utilities
3. **Specify focus** if you want emphasis on a particular aspect
4. **Ask follow-ups** like "Can you expand on the validation section?"
5. **Request specific examples** like "Show an example with timezone handling"
6. **Compare approaches** like "Why this pattern vs alternatives?"
