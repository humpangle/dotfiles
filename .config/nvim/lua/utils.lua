local utils = {}

function utils.ebnis_save_commit_buffer()
  local winnr = vim.api.nvim_win_get_number(0)
  if winnr ~= 1 then
    vim.cmd("write %")
    vim.cmd("quit")
    return
  end

  local max_tab_number =
    vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())
  local current_tab_number = vim.fn.tabpagenr("$")

  if max_tab_number == current_tab_number then
    vim.cmd("write %")
    -- Quit twice to return to previous tab
    vim.cmd("quit")
    vim.cmd("quit")
  else
    vim.cmd("write %")
    vim.cmd("quit")
    vim.cmd("tabprevious")
    vim.cmd("quit")
  end
end

function utils.split(parent_str, regex)
  local splits = {}
  local fpat = "(.-)" .. regex
  local last_end = 1
  local s, e, next_token = parent_str:find(fpat, 1)

  while s do
    if s ~= 1 or next_token ~= "" then
      table.insert(splits, next_token)
    end

    last_end = e + 1
    s, e, next_token = parent_str:find(fpat, last_end)
  end

  if last_end <= #parent_str then
    next_token = parent_str:sub(last_end)
    table.insert(splits, next_token)
  end

  return splits
end

function utils.get_file_name(num)
  local has_file_arg = type(num) == "string"
  local file_name = (has_file_arg and num) or vim.fn.expand("%:f")

  if vim.fn.empty(file_name) == 1 then
    return "[No Name]"
  end

  if num == 2 then
    return file_name
  end

  if has_file_arg then
    local path_segments_list = utils.split(file_name, "/+")
    local len = #path_segments_list
    local last_but_one_index = len - 1
    local tail = path_segments_list[len]

    local first_letters_of_path_segments_list = {}

    for i = 1, last_but_one_index, 1 do
      local next_path_segment = path_segments_list[i]

      local first_letter_of_next_path_segment =
        string.sub(next_path_segment, 1, 1)

      -- for dot file, we take the dot and next char
      if first_letter_of_next_path_segment == "." then
        first_letter_of_next_path_segment =
          string.sub(next_path_segment, 1, 2)
      end

      table.insert(
        first_letters_of_path_segments_list,
        first_letter_of_next_path_segment
      )
    end

    return table.concat(first_letters_of_path_segments_list, "/")
      .. "/"
      .. tail
  end

  return file_name
end

function utils.DeleteOrCloseBuffer(flag)
  if vim.fn.expand("%") == "Neotest Output Panel" then
    vim.cmd.echo(
      '"'
        .. "You may not delete Neotest Output Panel."
        .. "\\n"
        .. "Use <leader>nto to close."
        .. '"'
    )
    return
  end

  if vim.fn.expand("%:f") == "" then
    flag = "f"
  end

  local filetype = vim.bo.filetype

  if filetype == "netrw" then
    if vim.fn.tabpagenr() == 1 then
      return
    else
      vim.cmd("quit")
    end
  elseif flag == "f" then
    vim.cmd("bd!%")
  else
    vim.cmd("bd%")
  end
end

function utils.EbnisClearAllBuffer()
  -- Check if the current buffer is unnamed
  local bufferName = vim.api.nvim_buf_get_name(0)

  if bufferName == "" then
    -- If the buffer is unnamed, delete all lines
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  else
    -- If the buffer has a name, reload it and then delete all lines
    vim.cmd("e! %")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  end

  -- Enter insert mode
  vim.cmd("startinsert")
end

---@param buffer_name string
function utils.is_fugitive_buffer(buffer_name)
  if vim.startswith(buffer_name, "fugitive://") then
    return true
  end

  if vim.endswith(buffer_name, ".fugitiveblame") then
    return true
  end

  return false
end

---@param buffer_name string
function utils.is_dap_buffer(buffer_name)
  if vim.startswith(buffer_name, "DAP ") then
    return true
  end

  if vim.startswith(buffer_name, "[dap-repl-") then
    return true
  end

  return false
end

local is_deleteable_unlisted_buffer = function(b_name, buf_num)
  if b_name == "Neotest Output Panel" then
    return false
  end

  if b_name == "Neotest Summary" then
    return false
  end

  if vim.startswith(b_name, "neo-tree") then
    return false
  end

  if b_name == "" or b_name == "," then
    return true
  end

  return not vim.api.nvim_buf_get_option(buf_num, "buflisted")
end

function utils.DeleteAllBuffers(delete_flag)
  local normal_buffers = {}
  local terminal_buffers = {}
  local no_name_buffers = {}
  local dbui_buffers = {}
  local fugitive_buffers = {}
  local dap_buffers = {}

  for _, buf_num in ipairs(vim.api.nvim_list_bufs()) do
    local b_name = vim.fn.bufname(buf_num)

    if delete_flag == "dbui" and (string.match(b_name, ".dbout")) then
      -- or string.match(b_name, "share/db_ui/")
      table.insert(dbui_buffers, buf_num)
    elseif
      delete_flag == "fugitive" and utils.is_fugitive_buffer(b_name)
    then
      table.insert(fugitive_buffers, buf_num)
    elseif delete_flag == "dap" and utils.is_dap_buffer(b_name) then
      table.insert(dap_buffers, buf_num)
    elseif is_deleteable_unlisted_buffer(b_name, buf_num) then
      table.insert(no_name_buffers, buf_num)
    elseif string.match(b_name, "term://") then
      table.insert(terminal_buffers, buf_num)
    else
      table.insert(normal_buffers, buf_num)
    end
  end

  local index_ = 0

  local function wipeout_buffers(buffer_list)
    for _, buf_num in ipairs(buffer_list) do
      vim.api.nvim_buf_delete(buf_num, { force = true })
      index_ = index_ + 1
    end
  end

  -- all buffers
  if delete_flag == "a" then
    wipeout_buffers(no_name_buffers)
    wipeout_buffers(terminal_buffers)
    wipeout_buffers(normal_buffers)
    wipeout_buffers(fugitive_buffers)
  -- empty / no-name buffers
  elseif delete_flag == "e" then
    wipeout_buffers(no_name_buffers)
  -- terminal buffers
  elseif delete_flag == "t" then
    wipeout_buffers(terminal_buffers)
  -- dbui buffers
  elseif delete_flag == "dbui" then
    wipeout_buffers(dbui_buffers)
  elseif delete_flag == "fugitive" then
    wipeout_buffers(fugitive_buffers)
  elseif delete_flag == "dap" then
    wipeout_buffers(dap_buffers)
  end

  vim.cmd.echo("'" .. index_ .. " buffers wiped!'")
end

local function is_terminal_buffer()
  local buf_number = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf_number)

  if buf_name:match("^term://") then
    return true
  else
    return false
  end
end

function utils.RenameFile()
  local old_name = vim.api.nvim_buf_get_name(0) -- Get the current buffer's file name
  local new_name = vim.fn.input({
    prompt = "New file name: ",
    default = old_name,
    completion = "file",
  })

  if new_name ~= "" and new_name ~= old_name then
    local dirname = vim.fn.fnamemodify(new_name, ":p:h")

    -- Create the directory if it doesn't exist
    if not is_terminal_buffer() then
      os.execute("mkdir -p " .. vim.fn.shellescape(dirname))
    end

    -- Wrap in pcall because terminal buffers produce error which terminates rest of function.
    pcall(function()
      -- Save the buffer under the new name
      vim.cmd("saveas " .. vim.fn.fnameescape(new_name))
    end)

    -- Remove the old file
    if not is_terminal_buffer() then
      os.execute("rm " .. vim.fn.shellescape(old_name))
    end

    -- Refresh the screen
    vim.cmd("redraw!")

    -- Close the buffer that had the old file name
    vim.cmd("bdelete! " .. old_name)
  end
end

function utils.DeleteFile(which)
  return function()
    which = which or "f"
    local to_delete

    if which == "d" then
      to_delete = vim.fn.expand("%:p:h")
    else
      to_delete = vim.fn.expand("%")
    end

    if to_delete == "" or to_delete:match("^term://") then
      vim.cmd("bdelete!")
      print("DELETED " .. to_delete .. " !")
      return
    end

    local delete_prompt = "N"

    if vim.v.count == 1 then
      delete_prompt = "y"
    else
      delete_prompt =
        vim.fn.input('Sure to delete: "' .. to_delete .. '"? (y/N) ')
    end

    if delete_prompt:lower() == "y" then
      if which == "d" then
        os.execute("rm -rf " .. vim.fn.shellescape(to_delete))
        vim.cmd("bdelete!")
      else
        os.remove(to_delete)
        vim.cmd("bdelete!")
        print("File deleted.")
      end
    else
      vim.cmd("redraw!")
    end
  end
end

function utils.map_key(mode, mapping_str, command_to_map_to, opts, bufnr)
  opts = opts or { desc = "" }

  if bufnr ~= nil then
    opts.buffer = bufnr
  end

  -- We prepend the keymap (left) and mode to the description so when we search with description as search term, the
  -- keymap also shows up.
  opts.desc = mapping_str
    .. " "
    .. vim.inspect(mode)
    .. " "
    .. (opts.desc or "")

  vim.keymap.set(mode, mapping_str, command_to_map_to, opts)
end

function utils.write_to_command_mode(string)
  -- Prepend ':' to enter command mode, don't append '<CR>' to avoid executing
  -- Use 't' flag in feedkeys to interpret keys as if typed by the user
  vim.fn.feedkeys(
    vim.api.nvim_replace_termcodes(":" .. string, true, false, true),
    "t"
  )
end

utils.get_cmd_string = function()
  if utils.get_os_env_or_nil("__COPY_PROGRAM__") == nil then
    return nil
  end

  -- First attempt to read from cache.
  local cmd = vim.g.___clip_cmd_string__

  if cmd ~= nil then
    return cmd
  end

  local result = nil
  local nc_flag = ""

  -- Ubuntu OS requires the -N flag to the netcat nc executable.
  local handle = io.popen(
    "grep -q 'ubuntu' /etc/os-release &>/dev/null && echo 'yes' || echo 'no'"
  )

  if handle then
    result = handle:read("*a"):gsub("%s+", "")
    handle:close()
  end

  if result == "yes" then
    nc_flag = "-N"
  end

  cmd = "nc " .. nc_flag .. " localhost 8378"

  -- Cache the value for future read
  vim.g.___clip_cmd_string__ = cmd

  return cmd
end

utils.clip_cmd_exec = function(reg_value)
  local cmd = utils.get_cmd_string()

  if cmd == nil then
    return
  end

  vim.fn.system(cmd, reg_value)
  return cmd
end

utils.ord_to_char = function(ord)
  if ord < 1 or ord > 26 then
    ord = 26
  end

  return string.char(ord + 96)
end

utils.os_env_not_empty = function(env_var_string)
  local val = os.getenv(env_var_string)
  return val ~= nil and string.gsub(val, "^%s*(.-)%s*$", "%1") ~= ""
end

-- Returns nil if environment variable is not set or is empty.
-- Returns the value of the environment variable otherwise.
utils.get_os_env_or_nil = function(env_var_string)
  local val = os.getenv(env_var_string)

  -- environment variable is not set at all
  if val == nil then
    return nil
  end

  --  environment variable is set to an empty string
  if string.gsub(val, "^%s*(.-)%s*$", "%1") == "" then
    return nil
  end

  return val
end

utils.clear_terminal = function()
  local current_mode = vim.fn.mode()

  if current_mode == "n" then
    -- Enter terminal-insert mode with control-L
    vim.fn.feedkeys("a", "n") -- a-control-L
  else
    vim.fn.feedkeys("", "n") -- control-L
  end

  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb

  if current_mode == "n" and vim.v.count == 0 then
    -- Return to terminal-normal mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true),
      "t",
      true
    )
  end
end

utils.file_exists_and_not_empty = function(file_path)
  local file = io.open(file_path, "r")
  if file then
    local size = file:seek("end")
    file:close()
    return size > 0
  else
    return false
  end
end

--[[

Fix for nvim error "Cant't re-enter normal mode from terminal mode" when executing a normal mode command when a
terminal buffer is in focus.

The chosen fix is to create an empty buffer to take focus away from the terminal buffer. This temporary buffer should
be wiped or not depending on what happens after returning from the command.

If the error does not occur when returning from the command, pass true for the `wipe_temp_buffer_before_exec_cb`
parameter. Default is not to wipe the temporary buffer (for commands that trigger the error when returning).

Example Usage:

```lua
handle_cant_re_enter_normal_mode_from_terminal_mode(function()
  vim.cmd("echo 'whatever'")
end)
```

```lua
handle_cant_re_enter_normal_mode_from_terminal_mode(function()
  vim.cmd("echo 'whatever'")
end, true)
```

--]]
utils.handle_cant_re_enter_normal_mode_from_terminal_mode = function(
  callback,
  opts
)
  local buf_path = vim.fn.expand("%:f")

  -- If no terminal buffer is currently focused this **hack** is not necessary.
  if
    not (
      buf_path:match("^term://")
      or buf_path:match("^fugitive://.+/%.git//")
    )
  then
    callback()
    return
  end

  opts = opts or {}

  local wipe_temp_buffer_before_exec_cb = opts.wipe or false

  local split_direction = opts.split or "new"

  vim.cmd(split_direction)
  local b_num = vim.fn.bufnr()

  callback()

  if wipe_temp_buffer_before_exec_cb and b_num ~= nil then
    vim.cmd("bwipeout! " .. b_num)
  end
end

utils.create_slime_dir = function()
  local PlenaryPath = require("plenary.path")
  local slime_dir = vim.fn.getcwd() .. "/.___scratch"
  local slime_dir_obj = PlenaryPath:new(slime_dir)

  local timestamp = os.date("%s")

  -- if there is a file (not directory) at this path, rename it so we can create a directory with same name below.
  if slime_dir_obj:is_file() then
    os.rename(slime_dir, slime_dir .. "--" .. timestamp)
  end

  vim.fn.mkdir(slime_dir, "p")

  return slime_dir
end

local go_to_file_strip_git_diff = function(file_path)
  local git_diff_prefix_pattern = "^[ab]/"

  if file_path:match(git_diff_prefix_pattern) then
    return file_path:gsub(git_diff_prefix_pattern, "")
  end

  return file_path
end

local go_to_file_strip_prefix = function(file_path)
  local prefix = utils.get_os_env_or_nil("NVIM_GO_TO_FILE_GF_STRIP_PREFIX")

  if prefix == nil then
    return file_path
  end

  return file_path:gsub(prefix, "")
end

utils.go_to_file = function()
  local cword_file_path = vim.fn.expand("<cWORD>")

  local file_path, line =
    cword_file_path:match([=[^['"]?(.-)['"]?[>]?:?(%d*)[:',"]?$]=])

  if not file_path or file_path == "" then
    print("invalid file: " .. cword_file_path)
    return
  end

  if vim.fn.glob(file_path) == "" then
    file_path = go_to_file_strip_git_diff(file_path)
    file_path = go_to_file_strip_prefix(file_path)
  end

  local count = vim.v.count

  if count == 1 then
    vim.cmd("split")
  elseif count == 2 then
    vim.cmd("vsplit")
  elseif count == 3 then
    vim.cmd("tab split")
  end

  vim.cmd("edit " .. file_path)
  if file_path and line then
    vim.fn.cursor(line, 1)
  end
end

return utils
