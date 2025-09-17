local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.fzf() then
  return {}
end

local utils = require("utils")

local map_key = utils.map_key

-- Search file from root directory
map_key("n", "<leader>fW", ":Files!<CR>", { noremap = true })

-- Search file from current directory
map_key(
  "n",
  "<Leader>f.",
  ":Files! " .. vim.fn.expand("%:h") .. "/<CR>",
  { noremap = true }
)

-- Find open buffers
map_key("n", "<Leader>fb", function()
  utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
    vim.cmd("Buffers!")
  end)
end, { noremap = true })

-- Search buffers history
map_key("n", "<Leader>fh", ":History!<CR>", { noremap = true })

-- Search for text in current buffer
map_key("n", "<Leader>fl", ":BLines!<CR>", { noremap = true })

-- Search for text in loaded buffers
map_key("n", "<Leader>L", ":Lines!<CR>", { noremap = true })

-- Search for marks
map_key("n", "<Leader>fm", ":Marks!<CR>", { noremap = true })

-- Find filetypes
map_key("n", "<leader>ft", ":Filetypes!<CR>", { noremap = true })

-- Find windows
map_key("n", "<leader>fw", ":Windows!<CR>", { noremap = true })

-- Find color schemes
map_key("n", "<leader>fs", ":Colors!<CR>", { noremap = true })

-- Search commands: user defined, plugin defined, or native commands
map_key("n", "<Leader>C", ":Commands!<CR>", { noremap = true })

-- Search key mappings - find already mapped before defining new mappings
map_key("n", "<Leader>M", ":Maps!<CR>", { noremap = true })

-- Search in project - do not match filenames
map_key("n", "<Leader>f/", ":RgNf!<CR>", { noremap = true })

--  GIT
-- Files managed by git
map_key("n", "<Leader>fg", ":GFiles!<CR>", { noremap = true })

-- Search file from current directory with Git
map_key("n", "<Leader>f,", function()
  vim.cmd("GFiles! " .. vim.fn.expand("%:h") .. "/")
end, { noremap = true })

-- Git commits
-- keymap('n', '<leader>cm', ':Commits!<CR>', { noremap = true})

-- Git commits for the current buffer
map_key("n", "<leader>%c", ":BCommits!<CR>", { noremap = true })

-- fzf-checkout find git branch:
--   checkout = <CR>
--   rebase = <C-r>
--   delete = <C-d>
--   merge = <C-e>
--   track remote = <a-cr>
map_key("n", "<leader>cb", ":GBranches!<CR>", { noremap = true })

-- Search in project - match file names first
map_key("n", ",/", ":Rg!<CR>", { noremap = true })

-- Snippets (commented out since Snippets might not be directly related to fzf.vim or might need a specific plugin)
-- keymap('n', '<leader>sn', ':Snippets<CR>', { noremap = true})

-- Vim’s :help documentation
map_key("n", "<Leader>H", ":Helptags!<CR>", { noremap = true })

-- Fzf quickfix list
map_key("n", "<leader>fq", ":FzfQF!<CR>", { noremap = true })

-- Fzf location list
map_key("n", "<leader>FL", ":LocList!<CR>", { noremap = true })

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
