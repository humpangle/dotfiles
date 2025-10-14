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

local function get_current_line_number()
  return tostring(vim.fn.line("."))
end

local function get_paragraph_line_range()
  -- Save current position
  local current_pos = vim.fn.getpos(".")

  -- Find paragraph start (search backwards for blank line or buffer start)
  vim.cmd("normal! {")
  local para_start = vim.fn.line(".")
  -- If we're on a blank line, move down to first non-blank
  if vim.fn.getline(para_start):match("^%s*$") then
    para_start = para_start + 1
  end

  -- Restore position and find paragraph end
  vim.fn.setpos(".", current_pos)
  vim.cmd("normal! }")
  local para_end = vim.fn.line(".")
  -- If we're on a blank line, move up to last non-blank
  if vim.fn.getline(para_end):match("^%s*$") then
    para_end = para_end - 1
  end

  -- Restore original position
  vim.fn.setpos(".", current_pos)

  if para_start == para_end then
    return tostring(para_start)
  end
  return tostring(para_start) .. "-" .. tostring(para_end)
end

local function append_line_numbers_by_mode(path, mode)
  local line_num

  if mode == "current" then
    line_num = get_current_line_number()
  elseif mode == "paragraph" then
    line_num = get_paragraph_line_range()
  else
    -- Default to existing visual mode logic
    line_num = get_line_numbers_if_visual_mode()
  end

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

    -- Handle counts ending in 1 or 2 (21, 31, 41, 51, 22, 32, 42, 52)
    if count >= 21 and count <= 59 then
      local ones_digit = count % 10
      local tens_digit = math.floor(count / 10)

      -- Check if this matches our pattern: tens digit 2-5, ones digit 1-2
      if
        tens_digit >= 2
        and tens_digit <= 5
        and (ones_digit == 1 or ones_digit == 2)
      then
        local line_mode = ones_digit == 1 and "current" or "paragraph"
        local base_count = tens_digit -- Use tens digit as base path type

        local path_configs = {
          [2] = { directive = "%:.", desc = "relative" },
          [3] = { directive = "%:p", desc = "absolute" },
          [4] = { directive = "%:.:h", desc = "relative_dir" },
          [5] = { directive = "%:p:h", desc = "absolute_dir" },
        }

        local config = path_configs[base_count]
        if config then
          local file_path = vim.fn.expand(config.directive)
          file_path =
            append_line_numbers_by_mode(file_path, line_mode)
          local full_desc = config.desc
            .. (ones_digit == 1 and "_line" or "_para")
          yank_to_registers(file_path, register, full_desc)
          return
        end
      end
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
  "1=name 2=rel 3=abs 4=rel_dir 5=abs_dir 21=rel+line 31=abs+line 41=rel_dir+line 51=abs_dir+line 22=rel+para 32=abs+para 42=rel_dir+para 52=abs_dir+para 62=git_rel_path 64=git_rel_dir 9=line-number-only"
utils.map_key({ "n", "x" }, "<localleader>yf", create_path_yanker("+"), {
  noremap = true,
  desc = "Yank path: " .. doc,
})
utils.map_key({ "n", "x" }, "<localleader>cf", create_path_yanker("a"), {
  noremap = true,
  desc = "Copy path to 'a': " .. doc,
})
