local u = require("utils.core")

Vimg.floaterm_keymap_toggle = "<F1>"
Vimg.floaterm_keymap_next = "<F2>"
Vimg.floaterm_keymap_prev = "<F3>"
Vimg.floaterm_keymap_new = "<F4>"
Vimg.floaterm_gitcommit = "floaterm"
Vimg.floaterm_autoinsert = 1
Vimg.floaterm_width = 0.5
Vimg.floaterm_height = 0.9
Vimg.floaterm_wintitle = 0
Vimg.floaterm_autoclose = 1
Vimg.floaterm_position = "topright"

u.map("n", "<leader>Fk", ":FloatermKill<CR>")
u.map("n", "<leader>FF", ":FloatermNew")
