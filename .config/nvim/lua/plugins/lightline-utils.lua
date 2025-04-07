local is_term = function(filename)
  return filename:match("^term://")
end

local function abbreviate_path(file_path)
  if is_term(file_path) then
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
  local ok, yaml_lsp = pcall(require, "plugins.lsp-extras.yaml_lsp")

  if not ok then
    return ""
  end

  local yaml_schema = yaml_lsp.get_yaml_schema()

  if yaml_schema ~= "" then
    yaml_schema = " " .. yaml_schema
  end

  return yaml_schema
end

local get_terminal_name_suffix = function(channel)
  return "," .. channel -- .. "," .. vim.fn.jobpid(channel)
end

local compute_file_path = function(side)
  local left = side == "left"

  local file_path = vim.fn.expand("%:f")
  local file_path_original = file_path

  if file_path == "" then
    file_path = "[No Name]"
  elseif left then
    file_path = abbreviate_path(file_path)
  end

  if is_term(file_path_original) then
    return file_path .. get_terminal_name_suffix(vim.o.channel)
  end

  local git_branch = ""

  if left then
    git_branch = vim.fn.FugitiveHead()
  end

  if git_branch ~= "" then
    git_branch = git_branch .. " "
  end

  local modified = vim.bo.modified and "+" or ""

  return git_branch .. file_path .. modified .. get_yaml_schema()
end

function _G.FilenameLeft()
  return compute_file_path("left")
end

function _G.FilenameRight()
  return compute_file_path("right")
end

function _G.LightlineObsession()
  if vim.fn.exists(":Obsession") ~= 2 then
    return ""
  end

  -- Use the "DiffAdd" color if in a session
  local active_color_indicator = (vim.g.this_obsession == nil and "")
    or "%#diffadd#"

  local prefix = "$" -- This is the indicator that session is active.
  local session_file = vim.v.this_session

  if session_file == nil or session_file == "" then
    return prefix
  end

  -- This will indicate the session was started by vim prosession plugin. We can safely assume the session name is
  -- vim.g.prosession_dir .. working_directory.vim
  local vim_procession_indicator = "$"

  if string.find(session_file, vim.g.prosession_dir, 1, true) then
    return active_color_indicator .. prefix .. vim_procession_indicator
  end

  -- This means we started session manually - we simply show the session filename (minus directory) used to start
  -- session.
  return active_color_indicator .. prefix .. "C" -- session_file:match("([^/]+)$")
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
  local buf_list_for_tab = vim.fn.tabpagebuflist(tab_num)
  local current_win_num = vim.fn.tabpagewinnr(tab_num)
  local buf_num = buf_list_for_tab[current_win_num]
  local filename = vim.fn.expand("#" .. buf_num .. ":f")

  if filename == "" then
    return "[No Name]"
  elseif
    string.match(filename, "^fugitive:/")
    and string.match(filename, "%.git.*//$")
  then
    return "fgit" -- fugitive git
  elseif is_term(filename) then
    return vim.fn.expand("#" .. buf_num .. ":t")
      .. get_terminal_name_suffix(
        vim.api.nvim_buf_get_option(buf_num, "channel")
      )
  end

  local file_name_tail = vim.fn.expand("#" .. buf_num .. ":t")
  return file_name_tail .. tab_modified(tab_num)
end

vim.cmd([[
  function! FilenameTab(tab_num) abort
    return luaeval('FilenameTab(_A)', a:tab_num)
  endfunction
]])
