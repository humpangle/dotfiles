local Vimg = vim.g

Vimg.slime_target = "tmux"
-- let g:slime_target = "neovim"

-- Vim slime will prompt you for some config the first time it is ran.
-- You will be presented with string of the form:
--     tmux_session:
-- after the semicolon, type `w.p`, where
--     w = window number
--     p = pane number
-- E.g. if terminal is on 6th window, 4th pane, and session is `dot` you
-- should have
--     dot:6.4
Vimg.slime_default_config = {
  socket_name = "default",
  target_pane = "dot:",
}
