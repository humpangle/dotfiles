local u = require("utils.core")


Vim.g.mapleader = " "

-- Basics
u.map("n", "<leader>w", ":update<CR>")
u.map("n", "<leader>q", ":bdelete<CR>")
u.map("n", "<C-w>", ":bdelete<CR>")
u.map("i", "jk", "<ESC>")
u.map("n", "Q", "<Nop>")
u.map("n", "ss", ":luafile %<CR>", {silent = false})
u.map("n", "nh", ":noh<CR>")

-- Check file in shellcheck
u.map("n", "<leader>sc", ":!clear && shellcheck -x %<CR>")

-- Resize windows
u.map("n", "<S-k>", ":resize -2<CR>")
u.map("n", "<S-j>", ":resize +2<CR>")
u.map("n", "<S-h>", ":vertical resize -2<CR>")
u.map("n", "<S-l>", ":vertical resize +2<CR>")

-- Floaterm
u.map("n", "<leader>tk", ":FloatermKill<CR>")

-- Undotree
u.map("n", "<leader>u", ":UndotreeToggle<CR>")

-- Git
u.map("n", "<leader>gg", ":FloatermNew lazygit<CR>")
u.map("n", "<leader>gf", ":Telescope git_files<CR>")
u.map("n", "<leader>gc", ":Telescope git_commits<CR>")
u.map("n", "<leader>gb", ":Telescope git_branches<CR>")
u.map("n", "<leader>gs", ":Telescope git_status<CR>")

-- buffer navigation
u.map("n", "<TAB>", ":bn<CR>")
u.map("n", "<S-TAB>", ":bp<CR>")

-- File manager
u.map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- LSP
-- u.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
-- u.map("n", "gd", ":Telescope lsp_definitions<CR>")
-- u.map("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>")
-- u.map("n", "gr", ":Telescope lsp_references<CR>")
-- u.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
-- u.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
-- u.map("n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>")
-- u.map("n", "<c-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
-- u.map("n", "<c-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")

-- MY MAPPINGS

u.map("n", "ss", ":luafile %<CR>", {silent = false})

-- Remap esc
u.map("i", "jk", "<esc>")
u.map("i", "kj", "<esc>")
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
u.map("v", "<Leader>Y", "\"+y", {noremap = false})
u.map("v", "<Leader>X", "\"+y", {noremap = false})
u.map("n", "<Leader>p", "\"+p", {noremap = false})
u.map("v", "<Leader>p", "\"+p", {noremap = false})
u.map("v", "<Leader>p", "\"+p", {noremap = false})
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
u.map("n", "nh", ":noh<CR>")

local myConfigPath = "~/.config/nvim/init.vim"
-- edit init.vim
u.map("n", ",ec", ":execute e " .. myConfigPath .. "<CR>")
-- source init.vim
u.map("n", ",sc", ":execute so " .. myConfigPath .. "<CR>")

-- TO MOVE LINES up/down
u.map("n", "<A-k>", ":m .-2<CR>==")
u.map("n", "<A-j>", ":m .+1<CR>==")
u.map("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
u.map("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
u.map("v", "<A-j>", ":m '>+1<CR>gv=gv")
u.map("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- EMBEDDED TERMINAL TODO: complete from mappings.vim
u.map("t", "<C-h>", "<C-\\><C-N><C-w>h")
u.map("t", "<C-j>", "<C-\\><C-N><C-w>j")

-- COPY FILE PATH
-- yank relative File path
u.map("n", ",yr", ":let @+=expand(\"%\")<CR>", {noremap = true})
-- yank file name / not path
u.map("n", ",yn", ":let @+=expand(\"%:t\")<CR>", {noremap = true})
-- yank file parent directory
u.map("n", ",yd", ":let @+=expand(\"%:p:h\")<CR>", {noremap = true})
-- yank absolute File path
u.map("n", ",yf", ":let @+=expand(\"%:p\")<CR>", {noremap = true})
-- copy relative path
u.map("n", ",cr", ":let @\"=expand(\"%\")<CR>", {noremap = true})
-- copy absolute path
u.map("n", ",cf", ":let @\"=expand(\"%:p\")<CR>", {noremap = true})

-- toggle cursorcolumn
u.map("n", ",tc", ":set cursorline! cursorcolumn!<CR>")

-- toggle relative line number
u.map("n", ",tl", ":set invrelativenumber<CR>")

-- MANAGE BUFFERS
-- Delete all buffers
-- u.map("n", "<leader>ba", ":call DeleteAllBuffers()<cr>")
-- Delete current buffer
u.map("n", "<leader>bd", ":bd%<cr>")
-- Delete current buffer force
u.map("n", "<leader>b%", ":bd!%<cr>")
-- Wipe current buffer
u.map("n", "<leader>bw", ":bw%<cr>")

-- RESIZE WINDOW
u.map("n", "<A-h>", ":vertical resize -2<CR>")
u.map("n", "<A-l>", ":vertical resize +2<CR>")
u.map("n", "<A-u>", ":resize +2<CR>")
u.map("n", "<A-m>", ":resize -2<CR>")
