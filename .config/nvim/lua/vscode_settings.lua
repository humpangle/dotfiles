local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

local vscode = require("vscode-neovim")
local vcall = vscode.call
local no_re_map_silent_opts = { noremap = true, silent = true }
local no_re_map_opts = { noremap = true }

local PlenaryPath = require("plenary.path")

if vim.fn.has("win32") == 1 then
  vim.cmd("language en_US")
  vim.cmd("set fileformat=unix")
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true -- converts tabs to white space
vim.o.shiftwidth = 2 -- default indent = 2 spaces
vim.o.encoding = "utf8"
vim.o.cc = "120,80" -- column width
vim.o.incsearch = true -- Incremental search, search as you type
vim.o.ignorecase = true -- Make searching case insensitive
vim.o.smartcase = true -- ... unless the query has capital letters
vim.o.gdefault = true -- Use 'g' flag by default with :s/foo/bar/.
vim.o.hlsearch = true
-- vim.o.nohlsearch = true
-- :%s/term/sub will be highlighted as sub is typed
vim.o.inccommand = "nosplit"
-- vim.o.inccommand = 'split'

-- Tab Splits
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = "a"

vim.o.foldmethod = "indent"
vim.o.foldnestmax = 10
-- don't fold by default when opening a file.
vim.o.foldenable = false
vim.o.foldlevel = 2

-- reload a file if it is changed from outside vim
vim.o.autoread = true
vim.o.swapfile = false

-- persist undo history even when I quit vim
vim.o.undofile = true
vim.fn.mkdir(vim.fn.expand("$HOME/.vim/undodir"), "p")
vim.o.undodir = vim.fn.expand("$HOME/.vim/undodir/")

-- Paste text unmodified from other applications.
-- https://vim.fandom.com/wiki/Toggle_auto-indenting_for_code_paste
vim.o.paste = true

keymap("n", "<leader>fc", function()
  vcall("editor.action.formatDocument")
end, no_re_map_silent_opts)

-- format paragraphs/lines to 80 chars
keymap("n", "<Leader>pp", "gqap", no_re_map_silent_opts)

keymap("x", "<Leader>pp", "gqa", no_re_map_silent_opts)

-- ------------------------ Save file
keymap("n", "<Leader>ww", ":w<CR>", no_re_map_silent_opts)

keymap("n", "<Leader>wa", ":wa<CR>", no_re_map_silent_opts)

keymap("n", "<Leader>wq", ":wq<CR>", no_re_map_silent_opts)
-- ---------------------- END Save file

-- ---------------------- Quit vim
keymap("n", "<leader>qq", function()
  vcall("workbench.action.closeActiveEditor")
end, no_re_map_silent_opts)

keymap("n", "<leader>bd", function()
  vcall("workbench.action.closeActiveEditor")
end, no_re_map_silent_opts)

keymap("n", "<leader>qA", function()
  vcall("workbench.action.closeWindow")
end, no_re_map_silent_opts)

keymap("n", "<leader>qg", function()
  vcall("workbench.action.closeEditorsInGroup")
end, no_re_map_silent_opts)

keymap("n", "<leader>qG", function()
  vcall("workbench.action.closeEditorsInOtherGroups")
end, no_re_map_silent_opts)
-- ---------------------- END Quit vim

-- ---------------------- better code indentations in visual mode.
keymap("x", "<", "<gv", no_re_map_silent_opts)
keymap("x", ">", ">gv", no_re_map_silent_opts)
-- ---------------------- END better code indentations in visual mode.

-- ---------------------- Yank to system clipboard
keymap("n", '"+yy', '0"+yg_', no_re_map_silent_opts)
keymap("v", "<Leader>Y", '"+y', no_re_map_silent_opts)
keymap("v", "<Leader>x", '"+x', no_re_map_silent_opts)
keymap("n", "<Leader>x", '"+x', no_re_map_silent_opts)
keymap("n", "<Leader>P", '"+P', no_re_map_silent_opts)
keymap("v", "<Leader>P", '"+P', no_re_map_silent_opts)
-- ---------------------- END Yank to system clipboard

-- ---------------------- Yank all
keymap("n", "<Leader>y+", ':%y<bar>:let @+=@"<CR>', no_re_map_silent_opts)
keymap("n", "<Leader>YY", ':%y<bar>:let @+=@"<CR>', no_re_map_silent_opts)
keymap("n", "<Leader>ya", ':%y<bar>:let @a=@"<CR>', no_re_map_silent_opts)
-- Yank highlighted
keymap("n", ",yy", 'vgny<bar>:let @+=@"<CR> <bar>"', no_re_map_silent_opts)
-- Yank highlighted
keymap("n", ",cc", 'vgny<bar>:let @a=@"<CR> <bar>"', no_re_map_silent_opts)
-- ---------------------- END Yank all

--  Remove Contents of Current File, save file and enter normal mode
keymap("n", "d=", "ggdG<bar>:w<CR>", { noremap = true })

-- Remove Contents of Current File and Enter Insert Mode
keymap("n", "c=", "ggcG", { noremap = true })

-- ------------------------ Copy file path

local convert_to_unix_path = function(file_path)
  local modified_path = file_path:gsub("^/(%a):", function(drive_letter)
    return "/" .. drive_letter:lower()
  end)

  return modified_path
end

-- Yank relative file path
keymap("n", ",yr", function()
  vcall("copyRelativeFilePath")
  local path = convert_to_unix_path(vim.fn.getreg("+"))
  vim.fn.setreg("+", path)
  print(path)
end, no_re_map_opts)

-- Yank absolute file path
keymap("n", ",yf", function()
  vcall("copyFilePath")
  local path = convert_to_unix_path(vim.fn.getreg("+"))
  vim.fn.setreg("+", path)
  print(path)
end, no_re_map_opts)

-- Yank file directory path.
keymap("n", ",yd", function()
  -- Copy absolute file path into register + .
  vcall("copyFilePath")

  -- Copy file path from register + into local variable.
  local absolute_file_path = convert_to_unix_path(vim.fn.getreg("+"))

  -- Get parent path.
  local path = PlenaryPath:new(absolute_file_path)
  local parent_path = path:parent()

  -- Copy parent path into + register.
  -- vim.fn.setreg("+", parent_path) -- This does not work.
  vim.cmd("let @+=" .. '"' .. parent_path .. '"')

  print(vim.fn.getreg("+"))
end, no_re_map_opts)

-- Yank file name.
keymap("n", ",yn", function()
  -- Copy absolute file path into register + .
  vcall("copyFilePath")

  -- Copy file path from register + into local variable.
  local absolute_file_path = vim.fn.getreg("+")

  -- Get filename.
  local filename = vim.fn.fnamemodify(absolute_file_path, ":t")

  -- Copy filename into + register.
  vim.cmd("let @+=" .. '"' .. filename .. '"')

  print(vim.fn.getreg("+"))
end, no_re_map_opts)
-- ------------------------ END Copy file path

-- ---------------------- Dump vim register into a buffer in vertical split.
keymap("n", "<leader>re", ":reg<CR>", no_re_map_silent_opts)

keymap("n", ",o", function()
  vcall("editor.action.organizeImports")
end, no_re_map_silent_opts)

-- Rename variable
keymap("n", "<leader>rn", function()
  vcall("editor.action.rename")
end, no_re_map_silent_opts)

-- ------------------------ Go to problem
keymap("n", "]d", function()
  vcall("editor.action.marker.next")
end, no_re_map_silent_opts)

keymap("n", "[d", function()
  vcall("editor.action.marker.prev")
end, no_re_map_silent_opts)
-- ------------------------ END Go to problem

keymap("n", "gr", function()
  vcall("editor.action.referenceSearch.trigger")
end, no_re_map_silent_opts)

keymap("x", "gr", function()
  vcall("editor.action.referenceSearch.trigger")
end, no_re_map_silent_opts)

-- ------------------------ Folds
keymap("n", "zM", function()
  vcall("editor.foldAll")
end, no_re_map_silent_opts)

keymap("n", "zR", function()
  vcall("editor.unfoldAll")
end, no_re_map_silent_opts)
-- ------------------------ END Folds

keymap(
  "n",
  ",ec",
  ":Edit " .. vim.fn.expand("$MYVIMRC") .. "<CR>",
  no_re_map_silent_opts
)

keymap("n", "<leader>ca", function()
  vcall("editor.action.quickFix")
end, no_re_map_silent_opts)

local function insert_current_datetime()
  -- The `.. ""` is to silence the warning `Cannot assign `string|osdate` to `string`.  - `osdate` cannot match `string``
  local datetime = os.date("%Y-%m-%d %H:%M:%S") .. ""
  vim.api.nvim_put({ datetime }, "c", true, true)
end

keymap(
  "n",
  "<leader>D",
  insert_current_datetime,
  { noremap = true, silent = true, desc = "Insert datetime" }
)

keymap(
  "i",
  "<C-r><C-d>",
  insert_current_datetime,
  { noremap = true, silent = true, desc = "Insert datetime" }
)
