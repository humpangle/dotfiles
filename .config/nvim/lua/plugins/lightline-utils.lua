local function abbreviate_path(file_path)
  if string.match(file_path, "^term://") then
    -- It's a terminal buffer, we return the basename
    return vim.fn.fnamemodify(file_path, ":t")
  end

  local path_segments = {}
  for segment in string.gmatch(file_path, "[^/]+") do
    table.insert(path_segments, segment)
  end

  local abbreviated_parts = {}
  for index = 1, #path_segments - 1 do
    local part = path_segments[index]
    if string.match(part, "^%.") then
      -- If the part starts with a dot, include the dot and the next character
      table.insert(abbreviated_parts, string.sub(part, 1, 2))
    else
      -- Otherwise, we just the first character
      table.insert(abbreviated_parts, string.sub(part, 1, 1))
    end
  end

  -- The last part (basename) remain unchanged.
  table.insert(abbreviated_parts, path_segments[#path_segments])

  return table.concat(abbreviated_parts, "/")
end

local get_yaml_schema = function()
  local yaml_schema = require("plugins.yaml_lsp").get_yaml_schema()

  if yaml_schema ~= "" then
    yaml_schema = " " .. yaml_schema
  end

  return yaml_schema
end

function _G.FilenameLeft()
  local file_path = vim.fn.expand("%:f")
  local git_branch = vim.fn.FugitiveHead()

  if git_branch ~= "" then
    git_branch = git_branch .. " "
  end

  if file_path == "" then
    file_path = "[No Name]"
  else
    file_path = abbreviate_path(file_path)
  end

  local modified = vim.bo.modified and "+" or ""

  return git_branch .. file_path .. modified .. get_yaml_schema()
end

function _G.FilenameRight()
  local file_path = vim.fn.expand("%:f")

  if file_path == "" then
    file_path = "[No Name]"
  end

  local modified = vim.bo.modified and "+" or ""

  return file_path .. modified .. get_yaml_schema()
end

local function tab_modified(tab_num)
  local win_num = vim.fn.tabpagewinnr(tab_num)

  if vim.fn.gettabwinvar(tab_num, win_num, "&modified") == 1 then
    return "+"
  else
    return ""
  end
end

function _G.FilenameTab(tab_num)
  local buflist = vim.fn.tabpagebuflist(tab_num)
  local winnr = vim.fn.tabpagewinnr(tab_num)
  local filename = vim.fn.expand("#" .. buflist[winnr] .. ":f")

  if filename == "" then
    return "[No Name]"
  elseif
    string.match(filename, "^fugitive:/")
    and string.match(filename, "%.git//$")
  then
    return ".git"
  elseif string.match(filename, "NetrwTreeListing$") then
    return "N"
  end

  return vim.fn.expand("#" .. buflist[winnr] .. ":t") .. tab_modified(tab_num)
end
vim.cmd([[
  function! FilenameTab(tab_num) abort
    return luaeval('FilenameTab(_A)', a:tab_num)
  endfunction
]])
