local u = require("utils.core")

Vim.g.mapleader = " "

u.map("i", "jk", "<ESC>")
u.map("n", "ss", ":luafile %<CR>", {silent = false})

-- Check file in shellcheck
u.map("n", "<leader>sc", ":!clear && shellcheck -x %<CR>")

u.map("n", "ss", ":luafile %<CR>", {silent = false})

-- Format paragraph (selected or not) to 80 character lines.
u.map("n", "<Leader>g", "gqap")
u.map("x", "<Leader>g", "gqa")
-- Save file
u.map("n", "<Leader>ww", ":w<CR>")
u.map("n", "<Leader>wa", ":wa<CR>")
u.map("n", "<Leader>wq", ":wq<cr>")
-- when you need to make changes to a system file, you can override the
-- read-only permissions by typing :w!!, vim will ask for your sudo password
-- and save your changes
-- NOTE: you may need to install a utility such as `askpass` in order to input
-- password. On ubuntu, run:
-- sudo apt install ssh-askpass-gnome ssh-askpass -y && \
--  echo "export SUDO_ASKPASS=$(which ssh-askpass)" >> ~/.bashrc
u.map("c", "w!!", "w !sudo tee > /dev/null %", {noremap = false})

-- Quit vim
u.map("i", "<C-Q>", "<esc>:q<cr>")
u.map("v", "<C-Q>", "<esc>")
u.map("n", "<Leader>qq", ":q<cr>")
u.map("n", "<Leader>qf", ":q!<cr>")
u.map("n", "<Leader>qa", ":qa<cr>")
u.map("n", "<Leader>qF", ":qa!<cr>")

-- better code indentations in visual mode.
u.map("v", "<", "<gv")
u.map("v", ">", ">gv")

-- yank / Copy and paste from system clipboard (Might require xclip install)
u.map("v", "<Leader>Y", [["+y]], {noremap = false})
u.map("v", "<Leader>X", [["+y]], {noremap = false})
u.map("n", "<Leader>p", [["+p]], {noremap = false})
u.map("v", "<Leader>p", [["+p]], {noremap = false})
u.map("v", "<Leader>p", [["+p]], {noremap = false})
-- go to buffer number - use like so gb34
u.map("n", "gb", ":ls<CR>:b")
-- Move between windows in a tab
u.map("n", "<tab>", "<C-w>w")
u.map("n", "<c-h>", "<C-w>h")
u.map("n", "<c-j>", "<C-w>j")
u.map("n", "<c-k>", "<C-w>k")
u.map("n", "<c-l>", "<C-w>l")

-- mappings taken from unimpaired.vim
u.map("n", "[od", ":diffthis<cr>")
u.map("n", "]od", ":diffoff<cr>")

-- create the new directory am already working in
u.map("n", ",md", ":!mkdir -p %:h<cr><cr>")
u.map("n", ",rm", ":!trash-put %:p<cr>:bdelete!<cr>")
-- edit .bashrc file
u.map("n", ",.", ":e ~/.bashrc<CR>")
u.map("n", "<leader>nh", ":noh<CR>")
u.map("n", "<leader>ee", [[:Vexplore<CR>]])

local my_config_path = "~/.config/nvim-unstable/init.vim"
-- edit init.vim
u.map("n", ",ec", ":e " .. my_config_path .. "<CR>")
-- source init.vim
u.map("n", ",sc", ":so " .. my_config_path .. "<CR>")

-- TO MOVE LINES up/down
u.map("n", "<A-k>", ":m .-2<CR>==")
u.map("n", "<A-j>", ":m .+1<CR>==")
u.map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
u.map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
u.map("v", "<A-j>", ":m '>+1<CR>gv=gv")
u.map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- EMBEDDED TERMINAL TODO: complete from mappings.vim
u.map("t", "<C-h>", [[<C-\><C-N><C-w>h]])
u.map("t", "<C-j>", [[<C-\><C-N><C-w>j]])

-- COPY FILE PATH
-- yank relative File path
u.map("n", ",yr", [[:let @+=expand("%")<CR>]], {noremap = false})
-- yank file name / not path
u.map("n", ",yn", [[:let @+=expand("%:t")<CR>]], {noremap = false})
-- yank file parent directory
u.map("n", ",yd", [[:let @+=expand("%:p:h")<CR>]], {noremap = false})
-- yank absolute File path
u.map("n", ",yf", [[:let @+=expand("%:p")<CR>]], {noremap = false})
-- copy relative path
u.map("n", ",cr", [[:let @"=expand("%")<CR>]], {noremap = false})
-- copy absolute path
u.map("n", ",cf", [[:let @"=expand("%:p")<CR>]], {noremap = false})

-- toggle cursorcolumn
u.map("n", ",tc", ":set cursorline! cursorcolumn!<CR>")

-- toggle relative line number
u.map("n", ",tl", ":set invrelativenumber<CR>")

-- MANAGE BUFFERS
-- Delete all buffers
u.map("n", "<leader>ba", [[:lua require("utils.core").delete_buffers()<CR>]])
-- Delete empty buffers - not working
u.map("n", "<leader>be",
      [[:lua require("utils.core").delete_buffers("empty")<CR>]])
-- Delete current buffer
u.map("n", "<leader>bd", ":bd%<cr>")
-- Delete current buffer force
u.map("n", "<leader>b%", ":bd!%<cr>")
-- Wipe current buffer
u.map("n", "<leader>bw", ":bw%<cr>")

-- RESIZE WINDOW
u.map("n", "<c-left>", ":vertical resize -2<CR>")
u.map("n", "<c-right>", ":vertical resize +2<CR>")
u.map("n", "<c-up>", ":resize +2<CR>")
u.map("n", "<c-down>", ":resize -2<CR>")

-- START TOGGLE BACKGROUND COLOR
u.map("n", "tb", [[:lua require("utils.core").toggleBackground()<CR>]])
