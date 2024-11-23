local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.netrw() then
  -- disable netrw at the very start of your init.lua
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- silent E117: Unknown function: netrw#LocalBrowseCheck
  vim.cmd([[
    autocmd! FileExplorer *
  ]])

  return
end

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
  local utils = require("utils")

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
