local Vimg = vim.g
local keymap = vim.api.nvim_set_keymap

-- Vimg.floaterm_keymap_toggle = '<F1>'
-- Vimg.floaterm_keymap_next   = '<F2>'
-- Vimg.floaterm_keymap_prev   = '<F3>'
-- Vimg.floaterm_keymap_new    = '<F4>'
Vimg.floaterm_autoinsert = 1
Vimg.floaterm_width = 0.99
Vimg.floaterm_height = 0.99
Vimg.floaterm_wintitle = 0
Vimg.floaterm_autoclose = 1
Vimg.floaterm_position = "topright"

if vim.fn.has("win32") == 1 then
  Vimg.floaterm_shell = "pwsh.exe"
else
  Vimg.floaterm_shell = os.getenv("SHELL")
end

keymap("n", "<Leader>tt", ":FloatermToggle<CR>", { noremap = true })
keymap("n", "<Leader>ff", ":FloatermNew --height=0.99 --width=0.99 --title=",
  { noremap = true })
keymap("n", ",FL", ":Floaterms<CR>", { noremap = true })
keymap("n", "<Leader>FK", ":FloatermKill!", { noremap = true })

keymap("n", "<Leader>vi", ":let @+=trim(execute(':pwd'))<bar>:FloatermNew vifm <CR>", { noremap = true })
keymap("n", "<Leader>vI", ":FloatermNew vifm <CR>", { noremap = true })

keymap("n", ",FU", ":FloatermUpdate --height=0.99 --width=0.99 --title",
  { noremap = true })

-- :FloatermUpdate
-- title=a
-- width=0.5
-- wintype='vsplit' | 'split' | 'float'
