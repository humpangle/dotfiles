$HOME/dotfiles/aider-templates/aider.ebnis.chat.md
$HOME/dotfiles/aider-templates/aider.conf.yml
$HOME/.aider.conf.yml
$DOTFILE_ROOT/aider-templates/.___scratch-models/open-ai

aider \
--list-models \
gemini/ > \
$DOTFILE_ROOT/aider-templates/.___scratch-models/gemini

aider \
--no-auto-commits \
--model gemini-2.5-pro \
--cache-prompts

--reasoning-effort high \


--edit-format editor-diff
--edit-format editor-whole
--copy-paste
--no-git
--cache-prompts

--chat-history-file .aider.chat.history.md
--chat-history-file .aider.chat.history-$(date +'%FT%H-%M-%S').md

--input-history-file .aider.input.history
--input-history-file .aider.input.history-$(date +'%FT%H-%M-%S')

--subtree-only
--aiderignore

| tee .aider.ebnis.chat.out

-------------------------------------------------------------------------------
# In‑chat commands (https://aider.chat/docs/usage/commands.html#in-chat-commands)
/add
– add a file to chat

/ask
– pose a question to the model

/architect

– switch to architect edit format

/editor-model

– assign a specific model to handle editor-based edits

/chat-mode
– toggle between chat and code modes

/code
– start a code‑edit block

/commit
– commit changes with a generated message

/copy
– copy the last assistant response to clipboard

/copy-context

- Copy the current chat context as markdown, suitable to paste into a web UI

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

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
"*SEARCH/REPLACE* instruction to llm to propose edit"

Apply changes taking into consideration "*SEARCH/REPLACE* instruction"

Update *SEARCH/REPLACE block* to add the new functions to `scripts/_ai`.

Apply *SEARCH/REPLACE block* only, exactly as pasted into the chat

Whenever you propose edits to existing files, use only *SEARCH/REPLACE* blocks in this exact format:
## *SEARCH/REPLACE block* Rules:
#
Every *SEARCH/REPLACE block* must use this format:
1. The opening fence and code language, eg: ```python
2. The *FULL* file path alone on a line, verbatim. No bold asterisks, no quotes around it, no escaping of characters, etc.
3. The start of search block: <<<<<<< SEARCH
4. A contiguous chunk of lines to search for in the existing source code
5. The dividing line: =======
6. The lines to replace into the source code
7. The end of the replace block: >>>>>>> REPLACE
8. The closing fence: ```
#
Use the *FULL* file path, as shown to you by the user.
#
Every *SEARCH* section must *EXACTLY MATCH* the existing file content, character for character, including all comments,
docstrings, etc. If the file contains code or other data wrapped/escaped in json/xml/quotes or other containers, you
need to propose edits to the literal contents of the file, including the container markup.
#
*SEARCH/REPLACE* blocks will *only* replace the first match occurrence.
Including multiple unique *SEARCH/REPLACE* blocks if needed.
Include enough lines in each SEARCH section to uniquely match each set of lines that need to change.
#
Keep *SEARCH/REPLACE* blocks concise.
Break large *SEARCH/REPLACE* blocks into a series of smaller blocks that each change a small portion of the file.
Include just the changing lines, and a few surrounding lines if needed for uniqueness.
Do not include long runs of unchanging lines in *SEARCH/REPLACE* blocks.
#
Only create *SEARCH/REPLACE* blocks for files that the user has added to the chat!
#
To move code within a file, use 2 *SEARCH/REPLACE* blocks: 1 to delete it from its current location, 1 to insert it in the new location.
#
Pay attention to which filenames the user wants you to edit, especially if they are asking you to create a new file.
#
If you want to put code in a new file, use a *SEARCH/REPLACE block* with:
- A new file path, including dir name if needed
- An empty `SEARCH` section
- The new file's contents in the `REPLACE` section
#
ONLY EVER RETURN CODE IN A *SEARCH/REPLACE BLOCK*!

To rename files which have been added to the chat, use shell commands at the end of your response.

If the user just says something like "ok" or "go ahead" or "do that" they probably want you to make SEARCH/REPLACE blocks for the code changes you just proposed.
The user will say when they've applied your edits. If they haven't explicitly confirmed the edits have been applied, they probably want proper SEARCH/REPLACE blocks.

Examples of when to suggest shell commands:

- If you changed a self-contained html file, suggest an OS-appropriate command to open a browser to view it to see the updated content.
- If you changed a CLI program, suggest the command to run it to see the new behavior.
- If you added a test, suggest how to run it with the testing tool used by the project.
- Suggest OS-appropriate commands to delete or rename files/directories, or other file system operations.
- If your code changes add new dependencies, suggest the command to install them.
- Etc.

-------------------------------------------------------------------------------
.aiderignore

# Ignore everything
/*
# Allow specific directories and their contents
#!foo/
# Allow nested files under these directories
#!foo/**

-------------------------------------------------------------------------------
