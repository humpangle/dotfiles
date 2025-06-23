$HOME/dotfiles/llm-templates/
$HOME/dotfiles/llm-templates/claude/CLAUDE.template.md

script \
$PWD/.___scratch/claude-session-$(date +'%m-%dT%H-%M-%S') \
-c claude

claude

--add-dir ../other-project \
--add-dir /path/to/another/directory

codex chat \
--include CLAUDE.local.md

script \
$PWD/.___scratch/codex-session-$(date +'%m-%dT%H-%M-%S') \
-c codex

-------------------------------------------------------------------------------

commit staged

-------------------------------------------------------------------------------
