local u = require("utils.core")

Vim.g.python_host_prog = os.getenv("PYTHON2")
Vim.g.python3_host_prog = os.getenv("PYTHON3")
Vim.g.netrw_liststyle = 3

-- Global
u.opt("o", "incsearch", true)
u.opt("o", "ignorecase", true)
u.opt("o", "smartcase", true)
u.opt("o", "smarttab", true)
u.opt("o", "title", true)
u.opt("o", "backup", false)
u.opt("o", "writebackup", false)
u.opt("o", "clipboard", "unnamedplus")
u.opt("o", "showmode", false)
u.opt("o", "pumheight", 15)
u.opt("o", "showtabline", 2)
u.opt("o", "updatetime", 100)
u.opt("o", "scrolloff", 10)
u.opt("o", "cmdheight", 2)
u.opt("o", "termguicolors", true)
u.opt("o", "mouse", "a")
u.opt("o", "hidden", true)
u.opt("o", "splitbelow", true)
u.opt("o", "splitright", true)
u.opt("o", "completeopt", "menuone,noinsert,noselect")

-- Window
u.opt("w", "relativenumber", true)
u.opt("w", "number", true)
u.opt("w", "numberwidth", 1)
u.opt("w", "wrap", false)
u.opt("w", "cursorline", true)
u.opt("w", "conceallevel", 0)

-- Buffer
local indent = 2
u.opt("b", "tabstop", indent)
u.opt("b", "softtabstop", indent)
u.opt("b", "shiftwidth", indent)
u.opt("b", "expandtab", true)
u.opt("b", "autoindent", true)
u.opt("b", "smartindent", true)
u.opt("b", "swapfile", false)
u.opt("b", "undofile", true)
u.opt("b", "fileencoding", "utf-8")
u.opt("b", "syntax", "on")

-- Commands
Cmd("set shortmess+=c")
Cmd("set iskeyword+=-")
Cmd("set path+=.,**")
Cmd("filetype plugin on")
