# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# save tmux sessions
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   . $HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh
# fi
