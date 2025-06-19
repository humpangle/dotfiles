$HOME/dotfiles/llm-templates/
$HOME/dotfiles/llm-templates/CLAUDE.template.md

claude

-------------------------------------------------------------------------------

commit staged

<details>
<summary><code>⫸ Prompt: Inspect, draft, and commit</code></summary>
  I’ve already staged some changes.
  Do the following in one go:
  1. Run `git diff --no-ext-diff --staged`.
  2. Generate a descriptive, sentence‑case commit message with a brief subject line and a body explaining why the change was made.
  3. Commit the staged changes using that message (i.e. run `git commit -m "<subject>" -m "<body>"`).
  Use the style:
  - Subject max ~120 chars, sentence case (no period at end).
  - Body wraps at ~120 chars, explains rationale.
</details>

-------------------------------------------------------------------------------

<details>
<summary><code>⫸ Prompt #1: Draft commit message</code></summary>
  I’ve staged some changes.
  Run `git diff --no-ext-diff --staged` and propose a concise, sentence‑case commit message:
  - One‑line subject (~120 chars, no trailing period).
  - Multi‑line body (wrap ~120 chars) explaining why.
</details>

<details>
<summary><code>⫸ Prompt #2: Commit with approved message</code></summary>
  Commit the staged changes with the message we just finalized.
  Run: git commit -m "<subject>" -m "<body>"
</details>
