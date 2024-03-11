local Vimg = vim.g
local Vimb = vim.b

Vimb.slime_target = "neovim"
-- let g:slime_target = "tmux"

-- Key to show slime config for the first time - <C-c><C-c>
-- Key to update slime config after starting - <C-c>v
-- Vim slime will prompt you for some config the first time it is ran.
-- You will be presented with string of the form:
--     tmux_session:
-- after the semicolon, type `w.p`, where
--     w = window number
--     p = pane number
-- E.g. if terminal is on 6th window, 4th pane, and session is `dot` you
-- should have
--     dot:6.4
Vimb.slime_default_config = {
  socket_name = "default",
  target_pane = "dot:",
  jobid = ""
}

-- Some REPLs can interfere with your text pasting. The
-- [bracketed-paste](https://cirw.in/blog/bracketed-paste) mode exists to allow
-- raw pasting.

Vimg.slime_bracketed_paste = 1

vim.keymap.set('n', ',sl', ":let b:slime_target=''<left>")
