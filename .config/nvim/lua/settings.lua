local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local utils_status_ok1, s_utils = pcall(require, "settings-utils")
if not utils_status_ok1 then
  return
end

local plugin_enabled = require("plugins/plugin_enabled")

local python_interpreter =
  require("plugins/lsp-extras/lsp_utils").get_python_path()
vim.g.python3_host_prog = python_interpreter

-- Disable Python2 support
vim.g.loaded_python_provider = false

-- Disable perl provider
vim.g.loaded_perl_provider = false

-- Disable ruby provider
vim.g.loaded_ruby_provider = false

-- Disable node provider
vim.g.loaded_node_provider = false

require("netrw-setup")

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
---@diagnostic disable: missing-fields
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

-- When a file is modified in vim, vim might replace the file (thus changing the inode - file metadata). Imagine that
-- file is opened by the `tee` command. If you now edit the file in vim and inode changes, `tee` will not be aware of
-- the new inode and will keep trying to write to the previous inode (which no longer exist). Thus `tee` will see the
-- file as deleted. `vim.bo.backupcopy = "yes"` instructs vim to always modify the file in place (thus never changing
-- the inode).
utils.map_key("n", "yoB", function()
  local count = vim.v.count

  if count == 0 then
    vim.bo.backupcopy = "yes"
  else
    vim.bo.backupcopy = ""
  end

  vim.cmd.echo('"vim.bo.backupcopy=' .. vim.bo.backupcopy .. '"')
end, { noremap = true, silent = false })

local cwd_spellfile = vim.fn.getcwd()
  .. "/"
  .. ".---scratch"
  .. "."
  .. vim.o.spelllang
  .. ".utf-8.add"
local default_spellfile = vim.fn.stdpath("config")
  .. "/spell/"
  .. vim.o.spelllang
  .. ".utf-8.add"

vim.opt.spellfile = cwd_spellfile .. "," .. default_spellfile

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
  {
    pattern = {
      "*.sql.md",
      "*.md.sql",
    },
    filetype = "sql",
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
    vim.bo.filetype = "jsonc"
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

local function do_yank_highlighted(register)
  return function()
    -- Yank the currently highlighted texts to the unnamed register
    -- vim.api.nvim_command("normal! vgny")

    -- is it necessary?
    -- vim.cmd({ cmd = "wshada", bang = true })
    -- Copy the yanked text to the specified register
    vim.fn.setreg(register, utils.get_visual_selection())
    vim.fn.setreg("/", utils.get_visual_selection())
    vim.fn.setreg('"', utils.get_visual_selection())

    -- Without redrawing, nothing will be echoed
    vim.cmd({ cmd = "redraw", bang = true })

    -- Echo the contents of the clipboard
    local clipboard_contents = vim.fn.getreg(register)
    print(string.format("Register %s = %s", register, clipboard_contents))
  end
end

-- Yank highlighted to system clipboard / register a
utils.map_key("n", ",yy", do_yank_highlighted("+"), { noremap = true })
utils.map_key("n", ",cc", do_yank_highlighted("+"), { noremap = true })

-- Move between windows in a tab
utils.map_key("n", "<Tab>", "<C-w>w", { noremap = false })

-- Tab operations
utils.map_key("n", "<Leader>ts", "<cmd>tab split<cr>", { noremap = true })
utils.map_key("n", ",tc", ":tabclose<CR>", { noremap = true })
utils.map_key(
  "n",
  ",td",
  ":execute 'bwipeout! '.join(tabpagebuflist())<CR>",
  { noremap = true }
)

-- New buffer operations
utils.map_key("n", ",bn", function()
  local count = vim.v.count

  if count == 2 then
    vim.cmd("vnew")
  elseif count == 3 then
    vim.cmd("tabnew")
  else
    vim.cmd("new")
  end
end, { noremap = true })

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
utils.map_key("n", ",.", function()
  local count = vim.v.count

  if count == 2 then
    vim.cmd("vsplit")
  elseif count == 3 then
    vim.cmd("tab split")
  end

  vim.cmd("edit ~/.bashrc")
end, { noremap = true, desc = "Open .bashrc" })

-- Edit init.vim:
utils.map_key("n", ",ec", ":tab split<CR>:e $MYVIMRC<CR>", { noremap = true })

-- Source init.vim:
utils.map_key("n", ",sc", ":so $MYVIMRC<CR>", { noremap = true })

-- Source Lua file and then source init.vim:
utils.map_key("n", ",ss", ":source %<CR>:so $MYVIMRC<CR>", { noremap = true })

-- Check file in ShellCheck:
utils.map_key("n", "<Leader>sc,", function()
  local filepath = vim.fn.expand("%")
  vim.cmd("!clear && shellcheck -x " .. filepath)
end, { noremap = true })

-- Copying File Paths and Names

local maybe_augment_line_number = function(file_path)
  local count_contains_1 = tostring(vim.v.count):find("1")
  if not count_contains_1 then
    return file_path
  end

  local line_number_str = tostring(vim.fn.line("."))
  return file_path .. "#L" .. line_number_str
end

-- value_getter_directive may be:
--   a filename modifier
--   the literal string `cwd`
local process_file_path_yanking = function(value_getter_directive, register)
  return function()
    local file_path
    if value_getter_directive == "cwd" then
      file_path = vim.fn.getcwd()
    else
      file_path = vim.fn.expand(value_getter_directive)
    end

    file_path = maybe_augment_line_number(file_path)

    vim.fn.setreg('"', file_path)
    vim.fn.setreg(register, file_path)

    if register == "+" then
      utils.clip_cmd_exec(file_path)
    end

    vim.cmd.echo(
      "'"
        .. register
        .. " -> "
        .. value_getter_directive
        .. " = "
        .. file_path
        .. "'"
    )
  end
end

-- relative file path
utils.map_key("n", ",yr", process_file_path_yanking("%:.", "+"))
utils.map_key("n", ",cr", process_file_path_yanking("%:.", '"'))
-- file name (not path)
utils.map_key("n", ",yn", process_file_path_yanking("%:t", "+"))
utils.map_key("n", ",cn", process_file_path_yanking("%:t", '"'))
-- file parent directory
utils.map_key("n", ",yd", function()
  local path_modifier = "%:.:h"

  local count_contains_9 = tostring(vim.v.count):find("9")
  if count_contains_9 then
    path_modifier = "%:p:h"
  end

  process_file_path_yanking(path_modifier, "+")()
end, { noremap = true })

utils.map_key("n", ",cd", function()
  local path_modifier = "%:.:h"

  local count_contains_9 = tostring(vim.v.count):find("9")
  if count_contains_9 then
    path_modifier = "%:p:h"
  end

  process_file_path_yanking(path_modifier, '"')()
end, { noremap = true })
-- absolute file path
utils.map_key("n", ",yf", process_file_path_yanking("%:p", "+"))
utils.map_key("n", ",cf", process_file_path_yanking("%:p", "+"))

-- Yank current working directory
utils.map_key("n", ",yw", process_file_path_yanking("cwd"))
-- Copy current working directory to register a
utils.map_key("n", ",cw", process_file_path_yanking("cwd", "+"))

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
utils.map_key({ "n", "x" }, "<leader>rc", function()
  local count = vim.v.count
  local cmd = "%s///g"

  if count == 1 then
    cmd = "%s//" .. utils.get_visual_selection() .. "/g"
  elseif count == 2 then
    cmd = cmd .. "c<left>"
  elseif count == 22 then
    cmd = "%s//" .. utils.get_visual_selection() .. "/gc<left>"
  end

  utils.write_to_command_mode(cmd .. "<left><left>")
end, { desc = "Replace highlighted text 1/no-confirm" })

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
-- utils.map_key('n', '<leader>bl', '<cmd>Vmessage ls<CR>', { noremap = true, silent = false })

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
  local count = vim.v.count

  if count == 0 then
    vim.cmd("e! %")
    vim.cmd("%delete_")
    vim.cmd("w!")
    return
  end

  -- Remove Contents of Current File and Enter Insert Mode
  utils.EbnisClearAllBuffer()
end, { noremap = true })

utils.map_key("n", "<leader>be", function()
  local count = vim.v.count

  if count == 0 then
    -- Delete all empty buffers
    utils.DeleteAllBuffers("e")
    return
  end

  if count == 1 then
    utils.DeleteAllBuffers("fugitive")
    return
  end

  if count == 2 then
    -- delete all
    utils.DeleteAllBuffers("a")
    return
  end

  if count == 3 then
    utils.DeleteAllBuffers("dap")
    return
  end

  if count == 4 then
    utils.DeleteAllBuffers("octo")
    return
  end
end, { noremap = true, desc = "0/empty 1/fugitive 2/all 3/dap 4/octo" })

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

local function send_to_term_with_slime(split_direction)
  local current_buf = vim.api.nvim_get_current_buf()

  -- Yank current paragraph
  vim.cmd("normal! yip")
  local paragraph = vim.fn.getreg('"')

  vim.cmd(utils.split_direction(split_direction))
  vim.cmd("term")

  vim.b[current_buf].slime_config = {
    jobid = vim.b.terminal_job_id, -- neovim terminal job id
  }
  vim.b[current_buf].slime_target = "neovim"

  -- Switch back to the original buffer to make slime work
  if split_direction == "t" then
    vim.cmd.normal({ "gT" })
  else
    vim.cmd.wincmd("p")
  end

  vim.fn["slime#send"](paragraph)
end

-- Terminal in new tab/split
utils.map_key("n", ",tt", function()
  local count = vim.v.count

  if count == 2 then
    vim.cmd("vertical split")
  elseif count == 3 then
    vim.cmd("tab split")
  elseif count == 9 then
    send_to_term_with_slime()
    return
  elseif count == 92 then
    send_to_term_with_slime("v")
    return
  elseif count == 93 then
    send_to_term_with_slime("t")
    return
  else
    vim.cmd("split")
  end

  vim.cmd("term")
end, { noremap = true, desc = "terminal 0=s 1=v 2=t" })

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
utils.map_key("n", "<leader>re", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("reg")
    return
  end

  if count == 1 then
    vim.cmd("Wmessage reg")
    return
  end

  if count == 2 then
    vim.cmd("Vmessage reg")
    return
  end

  if count == 3 then
    vim.cmd("Tmessage reg")
    return
  end
end, { noremap = true, desc = "Registers" })

local function insert_current_datetime()
  local format_string = "%Y-%m-%dT%H-%M-%S"

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

utils.map_key({ "n", "x" }, "<leader>WW", utils.write_to_out_file, {
  noremap = true,
  silent = true,
  desc = "Save file to scratch file.",
})

utils.map_key("n", "gf", utils.go_to_file, { desc = "Go to file and line" })

vim.api.nvim_create_user_command("SortJson", function()
  vim.cmd("%!jq --sort-keys .")
end, { desc = "Sort Json Keys" })

require("settings.diagnostics")
