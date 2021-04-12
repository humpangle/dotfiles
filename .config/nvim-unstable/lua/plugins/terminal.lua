require"toggleterm".setup {
    size = 20,
    open_mapping = [[<a-t>]],
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal",
}

-- Floaterm
Vim.g.floaterm_keymap_toggle = "<F1>"
Vim.g.floaterm_keymap_next = "<F2>"
Vim.g.floaterm_keymap_prev = "<F3>"
Vim.g.floaterm_keymap_new = "<F4>"
Vim.g.floaterm_title = ""

Vim.g.floaterm_gitcommit = "floaterm"
Vim.g.floaterm_autoinsert = 1
Vim.g.floaterm_width = 0.8
Vim.g.floaterm_height = 0.8
Vim.g.floaterm_wintitle = 0
Vim.g.floaterm_autoclose = 1
Vim.g.floaterm_opener = "edit"
