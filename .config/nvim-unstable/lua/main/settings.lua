Vimg.python_host_prog = os.getenv("PYTHON2")
Vimg.python3_host_prog = os.getenv("PYTHON3")
Vimg.netrw_liststyle = 3

-- Global
Vimo.incsearch = true
Vimo.ignorecase = true
Vimo.smartcase = true
Vimo.smarttab = true
Vimo.title = true
Vimo.backup = false
Vimo.writebackup = false
Vimo.showmode = false
Vimo.pumheight = 15
Vimo.showtabline = 2
Vimo.updatetime = 100
Vimo.scrolloff = 10
Vimo.cmdheight = 2
Vimo.termguicolors = true
Vimo.mouse = "a"
Vimo.hidden = true
Vimo.splitbelow = true
Vimo.splitright = true
Vimo.completeopt = "menuone,noinsert,noselect"
Vimo.encoding = "utf8"
-- Use 'g' flag by default with :s/foo/bar/
Vimo.gdefault = true
Cmd("noswapfile")

-- SPELLING
--   ]s   [s = next/prev misspelled
--   zg = mark misspelled as good
Vimo.spelllang = "en"
-- Vimo.spell = true
Vimo.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.utf-8.add"

local indent_size = 2
-- Window
Vimo.relativenumber = true
Vimo.number = true
Vimo.numberwidth = 1
Vimo.wrap = false
Vimo.cursorline = true
Vimo.conceallevel = 0
Vimo.cc = "80" -- column widt
Vimo.foldmethod = "indent"
Vimo.foldnestmax = 10
-- don't fold by default when opening a file.
Cmd("set nofoldenable")
Vimo.foldlevel = indent_size

-- Buffer
Vimo.tabstop = indent_size
Vimo.softtabstop = indent_size
Vimo.shiftwidth = indent_size
Vimo.expandtab = true
Vimo.autoindent = true
Vimo.smartindent = true
Vimo.swapfile = false
Vimo.undofile = true
Vimo.fileencoding = "utf-8"
Cmd("syntax enable")
-- reload a file if it is changed from outside vim
Vimo.autoread = true

-- Commands
Cmd("set shortmess+=c")
Cmd("set iskeyword+=-")
Cmd("set path+=.,**")
Cmd("filetype plugin on")
