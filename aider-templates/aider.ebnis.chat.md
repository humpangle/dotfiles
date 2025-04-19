t .aider.ebnis.chat
$HOME/dotfiles/aider-templates/aider.conf.yml
$HOME/.aider.conf.yml

aider \
--no-auto-commits


--edit-format editor-diff
--edit-format editor-whole
--copy-paste
--no-git
--model gemini-2.5-pro
--model ollama_chat/deepseek-r1:14b
--list-models gemini/
--list-models openai/


| tee .aider.ebnis.chat.out

-------------------------------------------------------------------------------
# In‑chat commands (https://aider.chat/docs/usage/commands.html#in-chat-commands)
/add
– add a file to chat

/ask
– pose a question to the model

/architect
– switch to architect edit format

/chat-mode
– toggle between chat and code modes

/code
– start a code‑edit block

/commit
– commit changes with a generated message

/copy
– copy the last assistant response to clipboard

/context
– display the repo map and context

/diff
– show differences between file versions

/drop
– remove the last message from history

/exit
– quit the Aider session

/git
– run a git command

/help
– show this list of in‑chat commands

/lint
– run linting on the relevant files

/ls
– list files in the repository

/map
– inspect or refresh the repo map

/map-refresh
– force a repo map refresh

/model
– show or switch the AI model

/multiline-mode
– toggle multi‑line input mode

/paste
– paste clipboard contents into the chat

/read-only
– list read‑only files added

/report
– generate a summary report

/reset
– reset the conversation context

/run
– execute code in an editor buffer

/save
– save the current chat to disk

/settings
– view or modify Aider settings

/test
– run tests after edits

/tokens
– display token usage statistics

/think-tokens
– show thinking‑tokens usage

/undo
– revert the last edit

/quit
– same as /exit

/edit
– switch to the default code editing mode

/editor
– show or set your preferred code editor

/editor-model
– assign a specific model to handle editor-based edits
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
"*SEARCH/REPLACE* instruction to llm to propose edit"
Please apply necessary changes taking into consideration "*SEARCH/REPLACE* instruction to llm to propose edit"

Whenever you propose edits to existing files, use only *SEARCH/REPLACE* blocks in this exact format:
#
1. Start with an opening fence and language tag, e.g.: ```python
2. On the next line, write the *FULL* file path exactly as provided by the user, with no asterisks, quotes, or escapes.
3. On the next line, write:
   <<<<<<< SEARCH
4. Then include a contiguous chunk of lines that *exactly match* the existing file content (character‑for‑character, including comments, quotes, JSON/XML markup, etc.) sufficient to uniquely locate the change.
5. On the next line, write: =======
6. Then include only the replacement lines you want the file to contain (again, no extra context beyond what’s needed for uniqueness).
7. On the next line, write:
   >>>>>>> REPLACE
8. Close with the matching fence: ```
#
Additional requirements:
#
- **Only replace the first occurrence** of the matching SEARCH block.
- **Keep blocks concise.** If you need to make multiple changes in one file, emit multiple small SEARCH/REPLACE blocks rather than one giant block.
- **Files must have been explicitly added to the chat.** Do not touch any other files.
- To **move** code within a file, emit two blocks: one with SEARCH matching the original location and an empty REPLACE to delete it, and another with SEARCH matching the insertion point (or an empty SEARCH if appending to a new file) and REPLACE containing the moved code.
- To **create** a new file, use its full path and an empty SEARCH section, then put the entire file contents under REPLACE.
- **Do not** include any narrative or commentary—just the raw SEARCH/REPLACE blocks.

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------

Suggest commit message

-------------------------------------------------------------------------------

#=======================================================================================================================
#=======================================================================================================================
