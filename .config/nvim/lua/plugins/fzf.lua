local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.fzf() then
  return {}
end

local utils = require("utils")

local map_key = utils.map_key

-- Search file from current directory
map_key(
  "n",
  "<Leader>f.",
  ":Files! " .. vim.fn.expand("%:h") .. "/<CR>",
  { noremap = true }
)

-- Search buffers history
map_key("n", "<Leader>fh", ":History!<CR>", { noremap = true })

-- Search for text in loaded buffers
map_key("n", "<Leader>L", ":Lines!<CR>", { noremap = true })

-- Search for marks
map_key("n", "<Leader>fm", ":Marks!<CR>", { noremap = true })

-- Find filetypes
map_key("n", "<leader>ft", ":Filetypes!<CR>", { noremap = true })

-- Search in project - do not match filenames
map_key("n", "<Leader>f/", function()
  vim.o.background = "dark"
  vim.cmd("RgNf!")
end, { noremap = true })

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

vim.api.nvim_create_user_command("RgNf", function(opts)
  local rg =
    "rg --hidden --column --line-number --no-heading --color=always --smart-case --glob !{.git} --glob !{yarn.lock} -- "
  local query = vim.fn.shellescape(opts.args or "")
  local cmd = rg .. query

  -- fzf options: delimiter matches rg's "file:line:col:…" format
  local spec = vim.fn["fzf#vim#with_preview"]({
    options = table.concat({
      "--delimiter :",
      "--nth 4..",
      -- Show a live preview of the file; highlight the matched line with bat; fallback to sed
      [[--preview 'bash -lc "bat --style=numbers --color=always --plain --highlight-line {2} --line-range :500 {1} 2>/dev/null || sed -n \"1,500p\" {1}"']],
      -- Layout + bindings
      "--preview-window=right,60%,border-left,wrap,follow",
      "--bind=?:toggle-preview,alt-j:preview-down,alt-k:preview-up,alt-h:half-page-up,alt-l:half-page-down",
    }, " "),
  }, "right:60%:hidden") -- start hidden; press ? to toggle

  vim.fn["fzf#vim#grep"](cmd, 1, spec, opts.bang and 1 or 0)
end, { bang = true, nargs = "*" })

vim.g.fzf_preview_window = { "right,50%", "?" }
vim.g.fzf_vim = vim.g.fzf_vim or {}
vim.g.fzf_vim.preview_window = { "right,50%", "?" }

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
