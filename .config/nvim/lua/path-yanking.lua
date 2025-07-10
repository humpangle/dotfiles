local utils = require("utils")

local function get_line_numbers_if_visual_mode()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return nil
  end

  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  if start_line == end_line then
    return tostring(start_line)
  end
  return tostring(start_line) .. "-" .. tostring(end_line)
end

local function append_line_numbers(path)
  local line_num = get_line_numbers_if_visual_mode()
  if not line_num then
    return path
  end
  return path .. ":" .. line_num
end

local function get_git_relative_path(include_dir_only)
  local git_root = utils.get_git_root()

  if not git_root then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return nil
  end

  local path = vim.fn.expand("%:p")
  local relative_path =
    vim.fn.resolve(path):gsub("^" .. vim.pesc(git_root) .. "/", "")

  if include_dir_only then
    return vim.fn.fnamemodify(relative_path, ":h")
  end

  return relative_path
end

local function yank_to_registers(path, register, description)
  vim.fn.setreg('"', path)
  vim.fn.setreg(register, path)

  if description then
    vim.notify(register .. " -> " .. description .. " = " .. path)
  else
    vim.cmd.echo("'" .. register .. " -> " .. path .. "'")
  end
end

local function yank_line_number_only(register)
  local line_numb = get_line_numbers_if_visual_mode() or ""
  vim.fn.setreg('"', line_numb)
  vim.fn.setreg(register, line_numb)
  vim.cmd.echo(
    "'" .. "+" .. " -> " .. "line number" .. " = " .. line_numb .. "'"
  )
end

-- Create a path yanking function based on count
local function create_path_yanker(register)
  return function()
    local count = vim.v.count1

    if count == 9 then
      yank_line_number_only(register)
      return
    end

    -- Git-relative paths
    if count == 62 or count == 64 then
      local path = get_git_relative_path(count == 64)
      if not path then
        return
      end

      path = append_line_numbers(path)
      local desc = count == 62 and "relative git root path"
        or "relative git root dir"
      yank_to_registers(path, register, desc)
      return
    end

    -- Standard file paths
    local path_configs = {
      [1] = { directive = "%:t", desc = "filename" },
      [2] = { directive = "%:.", desc = "relative" },
      [3] = { directive = "%:p", desc = "absolute" },
      [4] = { directive = "%:.:h", desc = "relative_dir" },
      [5] = { directive = "%:p:h", desc = "absolute_dir" },
    }

    local config = path_configs[count]
      or { directive = "%:p", desc = "absolute" }
    local file_path = vim.fn.expand(config.directive)
    file_path = append_line_numbers(file_path)
    yank_to_registers(file_path, register, config.desc)
  end
end

local doc =
  "1=name 2=rel 3=abs 4=rel_dir 5=abs_dir 62=git_rel_path 64=git_rel_dir 9/line-number-only"
utils.map_key({ "n", "x" }, "<localleader>yf", create_path_yanker("+"), {
  noremap = true,
  desc = "Yank path: " .. doc,
})
utils.map_key({ "n", "x" }, "<localleader>cf", create_path_yanker("a"), {
  noremap = true,
  desc = "Copy path to 'a': " .. doc,
})
