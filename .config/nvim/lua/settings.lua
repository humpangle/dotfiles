local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local utils_status_ok1, s_utils = pcall(require, "settings-utils")
if not utils_status_ok1 then
  return
end

local keymap = vim.keymap.set

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

vim.opt.number = true
vim.opt.relativenumber = true

vim.g.encoding = "utf8"

-- Draw column lines at
vim.opt.cc = "120,80"

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
vim.opt.updatetime = 100

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
vim.opt.scrolloff = 10

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
keymap("n", "yoh", "<cmd>nohlsearch<CR>")

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
  { pattern = "*.html.django", filetype = "htmldjango" },
  {
    pattern = {
      "*.eslintrc",
      "*.code-snippets",
      "*.code-workspace",
      ".babelrc",
    },
    filetype = "json",
  },
  { pattern = ".env*", filetype = "sh" },
  { pattern = ".env*.y*ml", filetype = "yaml" },
  { pattern = "*.psql", filetype = "sql" },
  { pattern = { "Dockerfile*", "*.docker" }, filetype = "dockerfile" },
  { pattern = "*config", filetype = "gitconfig" },
  {
    pattern = { "*.heex", "*.leex", "*.sface", "*.lexs" },
    filetype = "eelixir",
  },
  { pattern = { "rebar.config", "*/src/*.app.src" }, filetype = "erlang" },
  { pattern = { "erlang_ls.config", "__dcy*" }, filetype = "yaml" },
  { pattern = "*.service", filetype = "systemd" },
  { pattern = "*.log", filetype = "conf" },
  { pattern = { "*.doc", "*.docx" }, cmd = "set ro" }, -- For setting readonly
  {
    pattern = { "*/playbooks/*.y*ml", "inventory.y*ml" },
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
    vim.bo.filetype = "jsonc"
  end,
})
-- END Map files from one type to another

-- Force keymap `leader fc` to use Neoformat for certain file types
-- Might not be necessary when using LSP?
vim.api.nvim_create_autocmd("FileType", {
  group = filetypes_group,
  pattern = { "elixir", "eelixir", "sh" },
  callback = function()
    keymap(
      "n",
      "<leader>fc",
      ":Neoformat<CR>",
      { noremap = true, buffer = true }
    )
  end,
})

-- Format paragraphs/lines to {textwidth} characters
keymap("n", "<Leader>pp", "gqap", { noremap = true })
keymap("x", "<Leader>pp", "gq", { noremap = true })

-- Save file
keymap("n", "<Leader>ww", ":w<CR>", { noremap = true })
keymap("n", "<Leader>wa", ":wa<CR>", { noremap = true })
keymap("n", "<Leader>wq", ":wq<CR>", { noremap = true })
keymap("n", "<Leader>w!", ":w!<CR>", { noremap = true })

-- Quit Vim
keymap("i", "<C-Q>", "<esc>:q<CR>", { noremap = true })
keymap("v", "<C-Q>", "<esc>", { noremap = true })
keymap("n", "<Leader>qq", ":q<CR>", { noremap = true })
keymap("n", "<Leader>qf", ":q!<CR>", { noremap = true })
keymap("n", "<Leader>qa", ":qa<CR>", { noremap = true })
keymap("n", "<Leader>qF", ":qa!<CR>", { noremap = true })
keymap("n", "<Leader>qA", ":qa!<CR>", { noremap = true })

-- BETTER CODE INDENTATIONS IN VISUAL MODE.
keymap("v", "<", "<gv", {})
keymap("v", ">", ">gv", {})

-- Yank / Copy and paste from system clipboard (Might require xclip install)
keymap("n", '"+yy', '0"+yg_', { noremap = true })
keymap("v", "<Leader>Y", '"+y', { noremap = true })
keymap("v", "<Leader>x", '"+x', { noremap = true })
keymap("n", "<Leader>x", '"+x', { noremap = true })
keymap("n", "<Leader>P", '"+P', { noremap = true })
keymap("v", "<Leader>P", '"+P', { noremap = true })

-- Yank all
keymap("n", "<Leader>y+", '<cmd>%y<CR><cmd>let @+=@"<CR>', { noremap = true })
keymap("n", "<Leader>YY", '<cmd>%y<CR><cmd>let @+=@"<CR>', { noremap = true })
keymap("n", "<Leader>ya", '<cmd>%y<CR><cmd>let @a=@"<CR>', { noremap = true })

local function do_yanka_highlighted(register)
  return function()
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
keymap("n", ",yy", do_yanka_highlighted("+"), { noremap = true })
keymap("n", ",cc", do_yanka_highlighted("a"), { noremap = true })

-- Move between windows in a tab
keymap("n", "<Tab>", "<C-w>w", { noremap = false })
keymap("n", "<C-h>", "<C-w>h", { noremap = true })

-- Tab operations
keymap("n", "<Leader>tn", "<cmd>tabnew<CR>", { noremap = true })
keymap("n", "<Leader>ts", "<cmd>tab split<cr>", { noremap = true })
keymap("n", ",tc", ":tabclose<CR>", { noremap = true })
keymap(
  "n",
  ",td",
  ":execute 'bwipeout! '.join(tabpagebuflist())<CR>",
  { noremap = true }
)

-- New split operations
keymap("n", ",vn", ":vnew<CR>", { noremap = true })
keymap("n", ",sn", ":new<CR>", { noremap = true })

-- Terminal in new tab/split
keymap(
  "n",
  ",tt",
  ":tab split<bar>:term<CR>:echo &channel<CR>",
  { noremap = true }
)
keymap(
  "n",
  ",tv",
  ":vertical split<bar>:term<CR>:echo &channel<CR>",
  { noremap = true }
)
keymap("n", ",ts", ":split<bar>:term<CR>:echo &channel<CR>", { noremap = true })

-- Reorder tabs
keymap("n", "<A-Left>", ":-tabmove<CR>", { noremap = true })
keymap("n", "<A-Right>", ":+tabmove<CR>", { noremap = true })

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

keymap("n", "<Leader>tl", function()
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
keymap("n", "yol", ":lclose<CR>", { noremap = true })
keymap("n", "yoq", ":cclose<CR>", { noremap = true })

-- Force sync buffer content with external:
keymap("n", "<Leader>%e", ":e! %<CR>", { noremap = true })

-- Create the new directory you're already working in:
keymap("n", ",md", ":!mkdir -p %:h<cr>:w %<CR>", { noremap = true })

-- Edit .bashrc file:
keymap("n", ",.", ":tab split<CR>:e ~/.bashrc<CR>", { noremap = true })

-- Edit init.vim:
keymap("n", ",ec", ":tab split<CR>:e $MYVIMRC<CR>", { noremap = true })

-- Source init.vim:
keymap("n", ",sc", ":so $MYVIMRC<CR>", { noremap = true })

-- Source Lua file and then source init.vim:
keymap("n", ",ss", ":source %<CR>:so $MYVIMRC<CR>", { noremap = true })

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
  keymap(
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
keymap("n", "<Leader>sc,", function()
  local filepath = vim.fn.expand("%")
  vim.cmd("!clear && shellcheck -x " .. filepath)
end, { noremap = true })

-- Copying File Paths and Names

local process_file_path_yanking = function(file_name_modifier, register)
  register = register or "+"

  return function()
    local fp = vim.fn.expand(file_name_modifier)
    vim.fn.setreg(register, fp)
    print(fp)
  end
end

-- Yank relative file path
keymap("n", ",yr", process_file_path_yanking("%:r"))
-- Yank file name (not path)
keymap("n", ",yn", process_file_path_yanking("%:t"))
-- Yank file parent directory
keymap("n", ",yd", process_file_path_yanking("%:p:h"))
-- Yank absolute file path
keymap("n", ",yf", process_file_path_yanking("%:p"))
-- Copy relative path
keymap("n", ",cr", process_file_path_yanking("%", "a"))
-- Copy absolute path
keymap("n", ",cf", process_file_path_yanking("%:p", "a"))
-- Copy file name
keymap("n", ",cn", process_file_path_yanking("%:t", "a"))

--  Some plugins change my CWD to currently opened file - I change it back
-- Change CWD to the directory of the current file
keymap("n", "<leader>cd", function()
  local cwd = vim.fn.expand("%:p:h")
  vim.cmd("cd " .. cwd)
  print("Current working directory changed to: " .. vim.fn.getcwd())
end)

-- Display the current working directory
keymap("n", "<leader>wd", function()
  print("Current working directory is: " .. vim.fn.getcwd())
end)

-- Find and replace in current buffer only
-- press * {shift 8) to search for word under cursor and key combo below to replace in entire file
keymap({ "n", "x" }, "<leader>rr", ":%s///g<left><left>")
keymap({ "n", "x" }, "<leader>rc", ":%s///gc<left><left><left>")

-- Search for the strings using `fzf`, press <tab> to select multiple (<s-tab> to deselect) and <cr> to populate QuickFix list
-- After searching for strings, press this mapping to do a project wide find and replace. It's similar to <leader>r
-- except this one applies to all matches across all files instead of just the current file.
keymap(
  { "n", "x" },
  "<Leader>RR",
  [[:cfdo %s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]]
)

-- Redirect messages to current buffer
vim.api.nvim_create_user_command("BufMessage", function(input)
  s_utils.RedirMessages(input.args, "")
end, { nargs = "+", complete = "command" })

-- Redirect messages to new horizontal split buffer
vim.api.nvim_create_user_command("WinMessage", function(input)
  s_utils.RedirMessages(input.args, "new")
end, { nargs = "+", complete = "command" })

-- Redirect messages to buffer in newly created tab
vim.api.nvim_create_user_command("TabMessage", function(input)
  s_utils.RedirMessages(input.args, "tabnew")
end, { nargs = "+", complete = "command" })

-- Redirect messages to new vertical split buffer
vim.api.nvim_create_user_command("VMessage", function(input)
  s_utils.RedirMessages(input.args, "vnew")
end, { nargs = "+", complete = "command" })

-- Go to Buffer Number
-- keymap('n', '<leader>bl', '<cmd>VMessage ls<CR>', { noremap = true, silent = false })

-- Delete current buffer
keymap("n", "<leader>bd", function()
  utils.DeleteOrCloseBuffer(1)
end, { noremap = true, silent = false })
-- Delete current buffer force
keymap("n", "<leader>bD", function()
  utils.DeleteOrCloseBuffer("f")
end, { noremap = true, silent = false })

-- Wipe Current Buffer
keymap("n", "<leader>bw", "<cmd>bw%<CR>", { noremap = true })

--  Remove Contents of Current File
keymap("n", "d=", function()
  vim.cmd("e! %")
  vim.cmd("%delete_")
  vim.cmd("w!")
end, { noremap = true })

-- Remove Contents of Current File and Enter Insert Mode
keymap("n", "c=", utils.EbnisClearAllBuffer, { noremap = true })

vim.api.nvim_create_user_command("DeleteDbUi", function()
  utils.DeleteAllBuffers("dbui")
end, {})

-- Delete all buffers
keymap("n", "<leader>bA", function()
  utils.DeleteAllBuffers("a")
end, { noremap = true })

-- Delete all empty buffers
keymap("n", "<leader>be", function()
  utils.DeleteAllBuffers("e")
end, { noremap = true })

-- Delete all terminal buffers
keymap("n", "<leader>bT", function()
  utils.DeleteAllBuffers("t")
end, { noremap = true })

-- Inserts the current date and time into the buffer
keymap("n", ",tm", function()
  -- Get the current date and time in the desired format
  local date_str = os.date("%Y-%m-%d %H:%M:%S")

  -- Get the current line number
  local line_num = vim.api.nvim_win_get_cursor(0)[1]

  -- Insert the date string into the buffer at the line after the current line
  vim.api.nvim_buf_set_lines(0, line_num, line_num, false, { date_str })
end, { noremap = true })

-- Rename File
keymap(
  "n",
  "<leader>bn",
  utils.RenameFile,
  { noremap = true, desc = "Buffer name = rename file <leader>bn" }
)

-- Delete file and folder
keymap("n", ",rm", utils.DeleteFile(), { noremap = true })
keymap("n", ",rd", utils.DeleteFile("d"), { noremap = true })

-- CLEAR THE TERMINAL
local term_clear = function()
  vim.fn.feedkeys("", "n") -- control-L
  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb
end
keymap("t", "<C-l>", term_clear)
-- END CLEAR THE TERMINAL

-- Show the registers
keymap("n", "<leader>re", ":reg<CR>", { noremap = true })
-- Dump vim register into a buffer in vertical split.
keymap("n", "<localleader>re", ":VMessage reg<CR>", { noremap = true })
