local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local utils_status_ok1, s_utils = pcall(require, "settings-utils")
if not utils_status_ok1 then
  return
end

local plugin_enabled = require("plugins/plugin_enabled")

local python_interpreter = require("plugins/lsp_utils").get_python_path()
vim.g.python3_host_prog = python_interpreter

-- Disable Python2 support
vim.g.loaded_python_provider = false

-- Disable perl provider
vim.g.loaded_perl_provider = false

-- Disable ruby provider
vim.g.loaded_ruby_provider = false

-- Disable node provider
vim.g.loaded_node_provider = false

-- https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
-- Always show in tree view
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- Open file by default in new tab
-- vim.g.netrw_browse_split = 3
vim.g.netrw_list_hide = [[.*\.swp$,.*\.pyc]]

--[[
Keep the current directory and the browsing directory synced. This helps you avoid the move files error. --- I think
without this setting, if you try to move file from one directory to another, vim will error. This setting prevents
this error - setting always changing pwd, which breaks some plugins
--]]
-- vim.g.netrw_keepdir = 0

vim.g.netrw_banner = 0
-- Change the copy command. Mostly to enable recursive copy of directories.
vim.g.netrw_localcopydircmd = "cp -r"

-- Line numbering
vim.g.netrw_bufsettings = "noma nomod rnu nobl nowrap ro"

-- Highlight marked files in the same way search matches are. - seems to make
-- no difference.
-- hi! link netrwMarkFile Search

if not (plugin_enabled.has_termux() or plugin_enabled.is_small_screen()) then
  vim.opt.number = true
  vim.opt.relativenumber = true
end

vim.g.encoding = "utf8"

-- Draw column lines at
vim.opt.cc = "120,80"

vim.api.nvim_create_autocmd("BufRead", {
  pattern = {
    "*/.local/share/db_ui/**/*.md",
    "*_query-result--*.md",
    "term://*",
  },
  callback = function()
    vim.opt_local.wrap = false
  end,
})

-- Maximum lenght of a line of text. When doing automatic formatting, a line of texts will wrap at this column.
vim.opt.textwidth = 119

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = "unnamedplus"
-- vim.opt.clipboard = ""

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- I guess some plugins are changing tabstop/shiftwidth settings for markdown.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- converts tabs to white space
vim.opt.expandtab = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enable break indent
vim.opt.breakindent = true

-- persist undo history even when I quit vim
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir/"

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
-- Many plugins require update time shorter than default of 4000ms

-- "antoinemadec/FixCursorHold.nvim" plugin divorces the cursorholdevent (reason plugins need short updatetime) from
-- updatetime - so this setting override is no longer needed except if we remove the plugin.
-- vim.opt.updatetime = 100

-- Increase mapped sequence wait time (for those who type slowy)
-- Will not work well with which-key plugin (requires about 250)
vim.opt.timeoutlen = 5000

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

-- Preview substitutions live, as you type!
-- vim.opt.inccommand = "split"
vim.opt.inccommand = "nosplit"

-- Show which line your cursor is on
vim.opt.cursorline = true
-- vim.opt.cursorcolumn = true

-- Minimal number of screen lines to keep above and below the cursor.
-- I have a workflow with vim-dadbod-ui where I keep a split window with top window serving as column headers. This
-- setting prevents this workflow.
-- Use <C-e> to scroll past bottom of screen
vim.opt.scrolloff = 0 --  10

vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
-- Don't fold by default when opening a file.
vim.opt.foldenable = false
vim.opt.foldlevel = 2

-- Reload a file if it is changed from outside vim
vim.opt.autoread = true
vim.opt.swapfile = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Incremental search, search as you type
vim.opt.incsearch = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
utils.map_key("n", "yoh", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Trim trailing whitespace and extra newlines at EOF for all files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Trim trailing whitespace
    vim.cmd([[silent! %s/\s\+$//e]])
    -- Remove extra newlines at the end of the file
    vim.cmd([[silent! %s/\n\+\%$//e]])
  end,
})

-- Ensure C and H files end with a newline
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.h" },
  callback = function()
    -- Append a newline at the end of the file if it doesn't exist
    vim.cmd([[silent! %s/\%$/\r/e]])
  end,
})

local filetypes_group =
  vim.api.nvim_create_augroup("filetypes", { clear = true })
-- Change filetype based on patterns
local patterns = {
  {
    pattern = "*.html.django",
    filetype = "htmldjango",
  },
  {
    pattern = {
      "*.eslintrc",
      "*.code-snippets",
      "*.code-workspace",
      ".babelrc",
    },
    filetype = "json",
  },
  {
    pattern = ".env*",
    filetype = "sh",
  },
  {
    pattern = ".env*.y*ml",
    filetype = "yaml",
  },
  {
    pattern = "*.psql",
    filetype = "sql",
  },
  {
    pattern = {
      "Dockerfile*",
      "*.docker",
    },
    filetype = "dockerfile",
  },
  {
    pattern = "*config",
    filetype = "gitconfig",
  },
  {
    pattern = {
      "rebar.config",
      "*/src/*.app.src",
    },
    filetype = "erlang",
  },
  {
    pattern = {
      "erlang_ls.config",
      "__dcy*",
    },
    filetype = "yaml",
  },
  {
    pattern = "*.service",
    filetype = "systemd",
  },
  {
    pattern = "*.log",
    filetype = "conf",
  },
  {
    pattern = {
      "*.doc",
      "*.docx",
    },
    cmd = "set ro",
  }, -- For setting readonly
  {
    pattern = {
      "*/playbooks/*.y*ml",
      "inventory.y*ml",
    },
    filetype = "yaml.ansible",
  },
}

for _, p in ipairs(patterns) do
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetypes_group,
    pattern = p.pattern,
    callback = function()
      if p.filetype then
        vim.bo.filetype = p.filetype
      elseif p.cmd then
        vim.cmd(p.cmd)
      end
    end,
  })
end

-- Map files from one type to another
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vifm",
  callback = function()
    vim.bo.filetype = "vim"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.bo.filetype = "json5"
  end,
})
-- END Map files from one type to another

-- Format paragraphs/lines to {textwidth} characters
utils.map_key("n", "<Leader>pp", "gqap", { noremap = true })
utils.map_key("x", "<Leader>pp", "gq", { noremap = true })

-- Save file
utils.map_key("n", "<Leader>ww", ":w<CR>", { noremap = true })
utils.map_key("n", "<Leader>wa", ":wa<CR>", { noremap = true })
utils.map_key("n", "<Leader>wq", ":wq<CR>", { noremap = true })
utils.map_key("n", "<Leader>w!", ":w!<CR>", { noremap = true })

-- Quit Vim
utils.map_key("i", "<C-Q>", "<esc>:q<CR>", { noremap = true })
utils.map_key("v", "<C-Q>", "<esc>", { noremap = true })
utils.map_key("n", "<Leader>qq", ":q<CR>", { noremap = true })
utils.map_key("n", "<Leader>qf", ":q!<CR>", { noremap = true })
utils.map_key("n", "<Leader>qa", ":qa<CR>", { noremap = true })
utils.map_key("n", "<Leader>qF", ":qa!<CR>", { noremap = true })
utils.map_key("n", "<Leader>qA", ":qa!<CR>", { noremap = true })

-- BETTER CODE INDENTATIONS IN VISUAL MODE.
utils.map_key("v", "<", "<gv", {})
utils.map_key("v", ">", ">gv", {})

-- Yank / Copy and paste from system clipboard (Might require xclip install)
utils.map_key("n", '"+yy', '0"+yg_', { noremap = true })
utils.map_key("v", "<Leader>Y", '"+y', { noremap = true })
utils.map_key("v", "<Leader>x", '"+x', { noremap = true })
utils.map_key("n", "<Leader>x", '"+x', { noremap = true })
utils.map_key("n", "<Leader>P", '"+P', { noremap = true })
utils.map_key("v", "<Leader>P", '"+P', { noremap = true })

-- Yank all
utils.map_key(
  "n",
  "<Leader>y+",
  '<cmd>%y<CR><cmd>let @+=@"<CR>',
  { noremap = true }
)
utils.map_key(
  "n",
  "<Leader>YY",
  '<cmd>%y<CR><cmd>let @+=@"<CR>',
  { noremap = true }
)
utils.map_key(
  "n",
  "<Leader>ya",
  '<cmd>%y<CR><cmd>let @a=@"<CR>',
  { noremap = true }
)

local function do_yanka_highlighted(register_flag)
  local register = nil

  return function()
    if register_flag == "letter" then
      register = utils.ord_to_char(vim.v.count)
    end

    register = register or register_flag

    -- Yank the currently highlighted texts to the unnamed register
    vim.api.nvim_command("normal! vgny")

    -- Copy the yanked text to the specified register
    vim.fn.setreg(register, vim.fn.getreg('"'))

    -- Without redrawing, nothing will be echoed
    vim.cmd({ cmd = "redraw", bang = true })

    -- Echo the contents of the clipboard
    local clipboard_contents = vim.fn.getreg(register)
    print(string.format("Register %s = %s", register, clipboard_contents))
  end
end

-- Yank highlighted to system clipboard / register a
utils.map_key("n", ",yy", do_yanka_highlighted("+"), { noremap = true })
utils.map_key("n", ",cc", do_yanka_highlighted("letter"), { noremap = true })

-- Move between windows in a tab
utils.map_key("n", "<Tab>", "<C-w>w", { noremap = false })

-- Tab operations
utils.map_key("n", "<Leader>tn", "<cmd>tabnew<CR>", { noremap = true })
utils.map_key("n", "<Leader>ts", "<cmd>tab split<cr>", { noremap = true })
utils.map_key("n", ",tc", ":tabclose<CR>", { noremap = true })
utils.map_key(
  "n",
  ",td",
  ":execute 'bwipeout! '.join(tabpagebuflist())<CR>",
  { noremap = true }
)

-- New split operations
utils.map_key("n", ",vn", ":vnew<CR>", { noremap = true })
utils.map_key("n", ",sn", ":new<CR>", { noremap = true })

-- Reorder tabs
utils.map_key("n", "<C-Left>", ":-tabmove<CR>", { noremap = true })
utils.map_key("n", "<M-Left>", ":-tabmove<CR>", { noremap = true })
utils.map_key("n", "<C-Right>", ":+tabmove<CR>", { noremap = true })
utils.map_key("n", "<M-Right>", ":+tabmove<CR>", { noremap = true })
-- -- This is what works on my macbook pro 3. I got the keys thus:
-- -- -- in nvim editor, enter insert mode, <c-v> and then <key> or combo.
utils.map_key("n", "<M-b>", ":-tabmove<CR>", { noremap = true })
utils.map_key("n", "<M-f>", ":+tabmove<CR>", { noremap = true })

-- Switch between last active and current tab
-- Initialize the global variable if it doesn't exist
if vim.g.lasttab == nil then
  vim.g.lasttab = 1
end

vim.api.nvim_create_autocmd("TabLeave", {
  pattern = "*",
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

utils.map_key("n", "<Leader>tl", function()
  -- ':exe "tabn " .. vim.g.lasttab<CR>',
  vim.cmd("tabn " .. vim.g.lasttab)
end, { noremap = true })
-- END Switch between last active and current tab

-- Resize window:
utils.map_key(
  "n",
  "<C-h>",
  ":vertical resize -2<CR>",
  { noremap = true, desc = "Window vertical resize to same side." }
)

utils.map_key(
  "n",
  "<C-l>",
  ":vertical resize +2<CR>",
  { noremap = true, desc = "Window vertical resize to opposite side." }
)

utils.map_key(
  "n",
  "<C-j>",
  ":resize -2<CR>",
  { noremap = true, desc = "Window resize to same side." }
)

utils.map_key(
  "n",
  "<C-k>",
  ":resize +2<CR>",
  { noremap = true, desc = "Window resize to opposite side." }
)

-- QuickFix and Location list:
utils.map_key("n", "yol", ":lclose<CR>", { noremap = true })
utils.map_key("n", "yoq", ":cclose<CR>", { noremap = true })

-- Force sync buffer content with external:
utils.map_key("n", "ff", ":e! %<CR>", { noremap = true })

-- Create the new directory you're already working in:
utils.map_key("n", ",md", ":!mkdir -p %:h<cr>:w %<CR>", { noremap = true })

-- Edit .bashrc file:
utils.map_key("n", ",.", ":tab split<CR>:e ~/.bashrc<CR>", { noremap = true })

-- Edit init.vim:
utils.map_key("n", ",ec", ":tab split<CR>:e $MYVIMRC<CR>", { noremap = true })

-- Source init.vim:
utils.map_key("n", ",sc", ":so $MYVIMRC<CR>", { noremap = true })

-- Source Lua file and then source init.vim:
utils.map_key("n", ",ss", ":source %<CR>:so $MYVIMRC<CR>", { noremap = true })

function NetrwVExplore(f)
  vim.cmd("Vexplore " .. vim.fn.expand("%:h"))
  if vim.fn.tabpagenr() == 1 then
    vim.cmd("only")
  elseif f == "n" then
    vim.cmd("1wincmd c")
  else
    vim.cmd("vertical resize +30")
  end
end

vim.cmd("command! Vexplore1 lua NetrwVExplore(1)")

function NetrwMapping()
  utils.map_key(
    "n",
    "fl",
    [[:echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>]],
    { buffer = true, noremap = true }
  )
end

vim.g.ebnis_netrw_loaded = 0

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if
      vim.g.ebnis_netrw_loaded == 0
      and vim.fn.expand("%") == "NetrwTreeListing"
    then
      vim.cmd("set ft=netrw")
      NetrwVExplore("n")
      NetrwMapping()
      vim.g.ebnis_netrw_loaded = 1
    end
  end,
})

-- Check file in ShellCheck:
utils.map_key("n", "<Leader>sc,", function()
  local filepath = vim.fn.expand("%")
  vim.cmd("!clear && shellcheck -x " .. filepath)
end, { noremap = true })

-- Copying File Paths and Names

-- value_getter_directive may be:
--   a filename modifier
--   the literal string `cwd`
local process_file_path_yanking = function(
  value_getter_directive,
  register_flag
)
  local register = nil

  return function()
    if register_flag == "letter" then
      register = utils.ord_to_char(vim.v.count)
    end

    register = register or "+"

    local fp
    if value_getter_directive == "cwd" then
      fp = vim.fn.getcwd()
    else
      fp = vim.fn.expand(value_getter_directive)
    end

    vim.fn.setreg('"', fp)
    vim.fn.setreg(register, fp)

    if register == "+" then
      utils.clip_cmd_exec(fp)
    end

    vim.cmd.echo(
      "'"
        .. register
        .. " -> "
        .. value_getter_directive
        .. " = "
        .. fp
        .. "'"
    )
  end
end

-- Yank relative file path
utils.map_key("n", ",yr", process_file_path_yanking("%:."))
-- Yank file name (not path)
utils.map_key("n", ",yn", process_file_path_yanking("%:t"))
-- Yank file parent directory
utils.map_key("n", ",yd", process_file_path_yanking("%:p:h"))
-- Yank absolute file path
utils.map_key("n", ",yf", process_file_path_yanking("%:p"))
-- Copy relative path
utils.map_key("n", ",cr", process_file_path_yanking("%", "letter"))
-- Copy absolute path
utils.map_key("n", ",cf", process_file_path_yanking("%:p", "letter"))
-- Copy file name
utils.map_key("n", ",cn", process_file_path_yanking("%:t", "letter"))

-- Yank current working directory
utils.map_key("n", ",yw", process_file_path_yanking("cwd"))
-- Copy current working directory to register a
utils.map_key("n", ",cw", process_file_path_yanking("cwd", "letter"))

--  Some plugins change my CWD to currently opened file - I change it back
-- Change CWD to the directory of the current file
utils.map_key("n", "<leader>cd", function()
  local cwd = vim.fn.expand("%:p:h")
  vim.cmd("cd " .. cwd)
  print("Current working directory changed to: " .. vim.fn.getcwd())
end)

-- Display the current working directory
utils.map_key("n", "<leader>wd", function()
  print("Current working directory is: " .. vim.fn.getcwd())
end)

-- Yank current line number
utils.map_key("n", ",yl", function()
  local line_number_str = tostring(vim.fn.line("."))

  vim.fn.setreg("+", line_number_str)

  vim.cmd.echo(
    "'"
      .. "+"
      .. " -> "
      .. "current line number"
      .. " = "
      .. line_number_str
      .. "'"
  )
end, { noremap = true, silent = true })

-- Find and replace in current buffer only
-- press * {shift 8) to search for word under cursor and key combo below to replace in entire file
-- utils.map_key({ "n", "x" }, "<leader>rr", ":%s///g<left><left>")
utils.map_key({ "n", "x" }, "<leader>rc", ":%s///gc<left><left><left>")

-- Search for the strings using `fzf`, press <tab> to select multiple (<s-tab> to deselect) and <cr> to populate QuickFix list
-- After searching for strings, press this mapping to do a project wide find and replace. It's similar to <leader>r
-- except this one applies to all matches across all files instead of just the current file.
utils.map_key(
  { "n", "x" },
  "<Leader>RR",
  [[:cfdo %s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

-- Redirect messages to current buffer
vim.api.nvim_create_user_command("Bmessage", function(input)
  s_utils.RedirMessages(input.args)
end, { nargs = "+", complete = "command" })

-- Redirect messages to new horizontal split buffer
vim.api.nvim_create_user_command("Wmessage", function(input)
  s_utils.RedirMessages(input.args, "new")
end, { nargs = "+", complete = "command" })

-- Redirect messages to buffer in newly created tab
vim.api.nvim_create_user_command("Tmessage", function(input)
  s_utils.RedirMessages(input.args, "tabnew")
end, { nargs = "+", complete = "command" })

-- Redirect messages to new vertical split buffer
vim.api.nvim_create_user_command("Vmessage", function(input)
  s_utils.RedirMessages(input.args, "vnew")
end, { nargs = "+", complete = "command" })

-- Go to Buffer Number
-- utils.map_key('n', '<leader>bl', '<cmd>VMessage ls<CR>', { noremap = true, silent = false })

-- Delete current buffer
utils.map_key("n", "<leader>bd", function()
  utils.DeleteOrCloseBuffer(1)
end, { noremap = true, silent = false })
-- Delete current buffer force
utils.map_key("n", "<leader>bD", function()
  utils.DeleteOrCloseBuffer("f")
end, { noremap = true, silent = false })

-- Wipe Current Buffer
utils.map_key("n", "<leader>bw", "<cmd>bw%<CR>", { noremap = true })

--  Remove Contents of Current File
utils.map_key("n", "d=", function()
  vim.cmd("e! %")
  vim.cmd("%delete_")
  vim.cmd("w!")
end, { noremap = true })

-- Remove Contents of Current File and Enter Insert Mode
utils.map_key("n", "c=", utils.EbnisClearAllBuffer, { noremap = true })

vim.api.nvim_create_user_command("DelDbUi", function()
  utils.DeleteAllBuffers("dbui")
end, {})

vim.api.nvim_create_user_command("DbUiDelete", function()
  utils.DeleteAllBuffers("dbui")
end, {})

-- Delete vim fugitive buffers
vim.api.nvim_create_user_command("DelFugitive", function()
  utils.DeleteAllBuffers("fugitive")
end, {})
vim.api.nvim_create_user_command("FugitiveDelete", function()
  utils.DeleteAllBuffers("fugitive")
end, {})

-- Delete all buffers
utils.map_key("n", "<leader>bA", function()
  utils.DeleteAllBuffers("a")
end, { noremap = true })

-- Delete all empty buffers
utils.map_key("n", "<leader>be", function()
  utils.DeleteAllBuffers("e")
end, { noremap = true })

-- Inserts the current date and time into the buffer
utils.map_key("n", ",tm", function()
  -- Get the current date and time in the desired format
  -- The `.. ""` is to silence the warning `Cannot assign `string|osdate` to `string`.  - `osdate` cannot match `string``
  local date_str = os.date("%Y-%m-%d %H:%M:%S") .. ""

  -- Get the current line number
  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- Insert the date string into the buffer at the line after the current line
  vim.api.nvim_buf_set_lines(0, line_num, line_num, false, { date_str })
end, { noremap = true })

-- Rename File
utils.map_key(
  "n",
  "<leader>bn",
  utils.RenameFile,
  { noremap = true, desc = "Buffer name = rename file <leader>bn" }
)

-- Delete file and folder
utils.map_key("n", ",rm", utils.DeleteFile(), { noremap = true })
utils.map_key("n", ",rd", utils.DeleteFile("d"), { noremap = true })

-- ----- TERMINAL

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier for people to discover. Otherwise,
-- you normally need to press <C-\><C-n>, which is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit
-- terminal mode

utils.map_key("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal in new tab/split
utils.map_key(
  "n",
  ",tt",
  ":tab split<bar>:term<CR>:echo &channel<CR>",
  { noremap = true }
)
utils.map_key(
  "n",
  ",tv",
  ":vertical split<bar>:term<CR>:echo &channel<CR>",
  { noremap = true }
)
utils.map_key(
  "n",
  ",ts",
  ":split<bar>:term<CR>:echo &channel<CR>",
  { noremap = true }
)

-- Delete all terminal buffers
utils.map_key("n", "<leader>bT", function()
  utils.DeleteAllBuffers("t")
end, { noremap = true })

utils.map_key("t", "<C-l>", utils.clear_terminal)

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    utils.map_key("n", "d=", utils.clear_terminal, {
      silent = true,
      desc = "Clear terminal. Supply count > 0 to enter insert mode.",
    }, 0)
  end,
})
-- END CLEAR THE TERMINAL

if plugin_enabled.has_termux() then
  -- Exit terminal mode
  vim.keymap.set(
    "t",
    "<C-k>",
    "<C-\\><C-n>",
    { desc = "Exit terminal mode in termux" }
  )
end

-- -----/END TERMINAL

-- Show the registers
utils.map_key("n", "<leader>re", ":reg<CR>", { noremap = true })
-- Dump vim register into a buffer in vertical split.
utils.map_key("n", "<localleader>re", ":VMessage reg<CR>", { noremap = true })

local function insert_current_datetime()
  local format_string = "%Y-%m-%d %H:%M:%S"

  if vim.v.count == 1 then
    format_string = "%s"
  end

  -- The `.. ""` is to silence the warning `Cannot assign `string|osdate` to `string`.  - `osdate` cannot match `string``
  local datetime = os.date(format_string) .. ""
  vim.api.nvim_put({ datetime }, "c", true, true)
end

utils.map_key("n", ",D", insert_current_datetime, {
  noremap = true,
  silent = true,
  desc = "Insert datetime. Count 1 for timestamp.",
})

utils.map_key(
  "i",
  "<C-r><C-d>",
  insert_current_datetime,
  { noremap = true, silent = true, desc = "Insert datetime" }
)
