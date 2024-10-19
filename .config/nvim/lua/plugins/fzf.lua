local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.fzf() then
  return {}
end

local utils = require("utils")

local keymap = utils.map_key

-- Search file from root directory
keymap("n", "<leader>fW", ":Files!<CR>", { noremap = true })

-- Search file from current directory
keymap(
  "n",
  "<Leader>f.",
  ":Files! " .. vim.fn.expand("%:h") .. "/<CR>",
  { noremap = true }
)

-- Find open buffers
keymap("n", "<Leader>fb", function()
  utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
    vim.cmd("Buffers!")
  end)
end, { noremap = true })

-- Search buffers history
keymap("n", "<Leader>fh", ":History!<CR>", { noremap = true })

-- Search for text in current buffer
keymap("n", "<Leader>fl", ":BLines!<CR>", { noremap = true })

-- Search for text in loaded buffers
keymap("n", "<Leader>L", ":Lines!<CR>", { noremap = true })

-- Search for marks
keymap("n", "<Leader>fm", ":Marks!<CR>", { noremap = true })

-- Find filetypes
keymap("n", "<leader>ft", ":Filetypes!<CR>", { noremap = true })

-- Find windows
keymap("n", "<leader>fw", ":Windows!<CR>", { noremap = true })

-- Find color schemes
keymap("n", "<leader>fs", ":Colors!<CR>", { noremap = true })

-- Search commands: user defined, plugin defined, or native commands
keymap("n", "<Leader>C", ":Commands!<CR>", { noremap = true })

-- Search key mappings - find already mapped before defining new mappings
keymap("n", "<Leader>M", ":Maps!<CR>", { noremap = true })

-- Search in project - do not match filenames
keymap("n", "<Leader>/", ":RgNf!<CR>", { noremap = true })

--  GIT
-- Files managed by git
keymap("n", "<Leader>fg", ":GFiles!<CR>", { noremap = true })

-- Search file from current directory with Git
keymap("n", "<Leader>f,", function()
  vim.cmd("GFiles! " .. vim.fn.expand("%:h") .. "/")
end, { noremap = true })

-- Git commits
-- keymap('n', '<leader>cm', ':Commits!<CR>', { noremap = true})

-- Git commits for the current buffer
keymap("n", "<leader>%c", ":BCommits!<CR>", { noremap = true })

-- fzf-checkout find git branch:
--   checkout = <CR>
--   rebase = <C-r>
--   delete = <C-d>
--   merge = <C-e>
--   track remote = <a-cr>
keymap("n", "<leader>cb", ":GBranches!<CR>", { noremap = true })

-- Search in project - match file names first
keymap("n", ",/", ":Rg!<CR>", { noremap = true })

-- Snippets (commented out since Snippets might not be directly related to fzf.vim or might need a specific plugin)
-- keymap('n', '<leader>sn', ':Snippets<CR>', { noremap = true})

-- Vim’s :help documentation
keymap("n", "<Leader>H", ":Helptags!<CR>", { noremap = true })

-- Fzf quickfix list
keymap("n", "<leader>fq", ":FzfQF!<CR>", { noremap = true })

-- Fzf location list
keymap("n", "<leader>FL", ":LocList!<CR>", { noremap = true })

-- Translation to lua does not work.
vim.cmd([[
  command! -bang -nargs=* RgNf
    \ call fzf#vim#grep(
    \   'rg --hidden --column --line-number --no-heading --color=always --smart-case --glob !{.git} --glob !{yarn.lock} -- '.shellescape(<q-args>), 1,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
    \   <bang>0
    \ )
]])

vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-/" }

local function format_qf_line(line)
  local parts = vim.split(line, ":")
  return {
    filename = parts[1],
    lnum = parts[2],
    col = parts[3],
    text = table.concat(vim.list_slice(parts, 4), ":"),
  }
end

local function fzf_to_qf(filtered_list)
  local list = vim.tbl_map(format_qf_line, filtered_list)
  if #list > 0 then
    vim.fn.setqflist({}, " ", { title = "Search Results", items = list })
    vim.cmd("copen")
  end
end

vim.api.nvim_create_user_command("FzfQF", function()
  vim.fn["fzf#run"]({
    source = vim.fn.map(vim.fn.getqflist(), "v:val"),
    down = "20",
    ["sink*"] = fzf_to_qf,
    options = '--reverse --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all --prompt "quickfix> "',
  })
end, { bang = true })
