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

function utils.map_lazy_key(mapping_str, command_to_map_to, opts, mode)
  mode = mode or "n"
  opts = opts or { desc = "" }

  -- We prepend the keymap (left) and mode to the description so when we search with description as search term, the
  -- keymap also shows up.
  opts.desc = mapping_str
    .. " "
    .. vim.inspect(mode)
    .. " "
    .. (opts.desc or "")

  -- https://lazy.folke.io/spec/lazy_loading#%EF%B8%8F-lazy-key-mappings
  local entry = {
    mapping_str,
    command_to_map_to,
    mode,
    opts,
  }

  for k, v in pairs(opts) do
    entry[k] = v
  end

  return entry
end

function utils.write_to_command_mode(string)
  -- Prepend ':' to enter command mode, don't append '<CR>' to avoid executing
  -- Use 't' flag in feedkeys to interpret keys as if typed by the user
  vim.fn.feedkeys(
    vim.api.nvim_replace_termcodes(":" .. string, true, false, true),
    "t"
  )
end

utils.get_git_root = function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  if git_root == nil or vim.fn.glob(git_root) == "" then
    return nil
  end

  return git_root
end

---Returns the relative path to the git root.
---@param abs_path string
---@return nil|string
function utils.relative_to_git_root(abs_path)
  local git_root = utils.get_git_root()

  if git_root == nil or git_root == "" then
    return nil
  end

  local relative_path =
    vim.fn.resolve(abs_path):gsub("^" .. vim.pesc(git_root) .. "/", "")

  return relative_path
end

utils.in_ssh = function()
  return utils.get_os_env_or_nil("SSH_CONNECTION") ~= nil
    or utils.get_os_env_or_nil("SSH_CLIENT") ~= nil
    or utils.get_os_env_or_nil("SSH_TTY") ~= nil
end

utils.read_register_plus = function(register, content)
  if (not utils.in_ssh()) or register ~= "+" then
    return vim.fn.getreg(register)
  else
    -- In SSH, we use osc52, but allow only write and not read
    return (content or "")
  end
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
  opts = opts or {}
  local buf_path = vim.fn.expand("%:f")
  local can_do = opts.force
    or buf_path:match("^term://")
    or buf_path:match("^fugitive://.+/%.git//")

  -- If no terminal buffer is currently focused this **hack** is not necessary.
  if not can_do then
    callback()
    return
  end

  local wipe_temp_buffer_after_exec_cb = opts.wipe or false

  local split_direction = opts.split or "new"

  vim.cmd(split_direction)
  -- if 1 == 1 then
  --   return
  -- end
  local b_num = vim.fn.bufnr()

  callback()

  if wipe_temp_buffer_after_exec_cb and b_num ~= nil then
    vim.cmd("bwipeout! " .. b_num)
  end
end

utils.create_slime_dir = function()
  local PlenaryPath = require("plenary.path")
  local slime_dir = vim.fn.getcwd() .. "/.___scratch"
  local slime_dir_obj = PlenaryPath:new(slime_dir)

  local timestamp = os.date("%FT%H-%M-%S")

  -- if there is a file (not directory) at this path, rename it so we can create a directory with same name below.
  if slime_dir_obj:is_file() then
    os.rename(slime_dir, slime_dir .. "--" .. timestamp)
  end

  vim.fn.mkdir(slime_dir, "p")

  return slime_dir
end

local go_to_file_strip_patterns = function(file_path)
  local patterns = {
    "^[ab]/", -- git prefix
  }

  for _, pattern in pairs(patterns) do
    if file_path:match(pattern) then
      file_path = file_path:gsub(pattern, "")
    end
  end

  return file_path
end

local go_to_file_strip_prefix_in_env = function(file_path)
  -- export NVIM_GO_TO_FILE_GF_STRIP_PREFIX=/some/path1/::other/part2
  local prefixes = utils.get_os_env_or_nil("NVIM_GO_TO_FILE_GF_STRIP_PREFIX")

  prefixes = (prefixes and (prefixes .. "::") or "")
    .. "fugitive://.+/.git//[%a%d]+/"
    .. "::"
    .. "octo://.+/RIGHT/"

  for _, prefix in pairs(vim.split(prefixes, "::")) do
    if prefix ~= "" then
      -- ensure exactly one slash between prefix and file_path
      local sep = prefix:sub(-1) == "/" and "" or "/"
      prefix = prefix .. sep

      local candidate = file_path:gsub(prefix, "")

      if
        vim.fn.filereadable(candidate) == 1
        or vim.fn.isdirectory(candidate) == 1
      then
        return candidate
      end
    end
  end

  return file_path
end

local go_to_file_prepend_prefix_in_env = function(file_path)
  -- export NVIM_GO_TO_FILE_GF_PREPEND_PREFIX=/some/path1/::other/part2
  local prefixes =
    utils.get_os_env_or_nil("NVIM_GO_TO_FILE_GF_PREPEND_PREFIX")

  if not prefixes then
    return file_path
  end

  for _, prefix in ipairs(vim.split(prefixes, "::", { plain = true })) do
    if prefix ~= "" then
      -- ensure exactly one slash between prefix and file_path
      local sep = prefix:sub(-1) == "/" and "" or "/"
      local candidate = prefix .. sep .. file_path

      -- check file exists
      if
        vim.fn.filereadable(candidate) == 1
        or vim.fn.isdirectory(candidate) == 1
      then
        return candidate
      end
    end
  end

  return file_path
end

local extract_line_number = function(cfile)
  local line_text = vim.fn.getline(".")
  local line_number = nil
  local last_path_index = cfile:match("([^/]+)$")

  local patterns = {
    "line%s*(%d+)", -- file_path whatever text line 168
    "%d+%%%s+(%d+)", -- file_path 80% 12
    ":(%d+):%d+", -- file_path:67:45
    "[:|](%d+)", -- file_path:67 / file_path|478 (used in vim loclist)
  }

  for _, pattern in pairs(patterns) do
    line_number = line_text:match(last_path_index .. ".-" .. pattern)

    if line_number ~= nil then
      return line_number
    end
  end

  return line_number
end

utils.go_to_file = function()
  local count = vim.v.count
  local split_num = "" .. count
  local file_path = nil
  local line_number = nil
  local cfile = nil

  -- Get file_path
  if count >= 20 then
    split_num = split_num:match("^%d(%d)$")
    file_path = vim.fn.expand("%:.")
  else
    cfile = vim.fn.expand("<cfile>")

    if not cfile or cfile == "" then
      print("invalid file: " .. cfile)
      return
    end

    local cfile1 = nil

    cfile1, line_number = cfile:match("^(.+)#L?(%d+)$")

    if cfile1 ~= nil then
      file_path = cfile1
    else
      file_path = cfile
    end
  end

  -- Apply file_path transformations
  if vim.fn.glob(file_path) == "" then
    file_path = go_to_file_strip_prefix_in_env(file_path)
    file_path = go_to_file_strip_patterns(file_path)
    file_path = go_to_file_prepend_prefix_in_env(file_path)
  end

  -- If file_path does not exist, we will try again by pre-pending git root (perhaps cwd is not git root but file_path
  -- is relative to git root)
  if vim.fn.glob(file_path) == "" then
    local git_root = utils.get_git_root()
    if git_root then
      file_path = git_root .. "/" .. file_path:gsub("^/", "")
    end
  end

  if vim.fn.glob(file_path) == "" then
    if split_num == "9" then
      vim.fn.setreg("a", file_path)
    end

    print("invalid file: " .. file_path)
    return
  end

  if cfile and (vim.fn.isdirectory(cfile) == 0) then
    line_number = line_number or extract_line_number(cfile)
  end

  -- Yank absolute path.
  if split_num == "9" then
    local abs_path = vim.fn.fnamemodify(file_path, ":p")
    vim.fn.setreg("+", abs_path)
    print(abs_path)
    return
  elseif split_num == "1" then
    vim.cmd("split")
  elseif split_num == "2" then
    vim.cmd("vsplit")
  elseif split_num == "3" then
    vim.cmd("tab split")
  end

  vim.cmd("edit " .. file_path)

  if line_number then
    vim.fn.cursor(line_number, 1)
  end
end

utils.get_visual_selection = function()
  local visually_selected_text = vim.fn.getreg("/")

  if visually_selected_text == nil then
    return ""
  end

  local text = visually_selected_text:match("^\\<(.-)\\>$")
    or visually_selected_text

  return text:gsub("\\%.", "."):gsub("\\/", "/")
end

local SPLIT_DIRECTIONS = {
  s = "split",
  v = "vsplit",
  t = "tab split",
}

utils.split_direction = function(text)
  return SPLIT_DIRECTIONS[text] or "split"
end

utils.write_to_out_file = function()
  local filename = utils.create_slime_dir() .. "/O-" .. os.date("%FT%H-%M-%S")

  local readonly = vim.bo.readonly
  -- local buftype = vim.bo.buftype

  vim.bo.readonly = false
  vim.bo.buftype = ""

  pcall(function()
    vim.cmd("saveas! " .. vim.fn.fnameescape(filename))
  end)

  vim.bo.readonly = readonly
  -- vim.bo.buftype = buftype
end

utils.get_session_file = function()
  local suffix = utils.get_os_env_or_nil("NVIM_SESSION_NAME_SUFFIX")

  if suffix then
    return "session-" .. suffix
  end

  return "session"
end

-- Replaces /, \, :, and other problematic characters with '-'
function utils.sanitize_filename(name)
  local use_clip = false

  -- If no name passed in, pull from the '+' register
  if name == nil then
    name = vim.fn.getreg("+") or ""
    use_clip = true
  end

  local escaped_name = name:gsub('[/\\:*?"<>|]', "-")

  if use_clip then
    vim.fn.setreg("+", escaped_name)
  end

  return escaped_name
end

--- Escape a string for use in a Vim regex and (optionally) update the '+' register.
---
--- If `text` is `nil`, reads from the '+' register, escapes that, writes it back,
--- and returns the escaped result. Otherwise just escapes and returns `text`.
---
---@param text? string
---@return string escaped_text
function utils.escape_register_plus(text)
  local use_clip = false

  -- If no text passed in, pull from the '+' register
  if text == nil then
    text = vim.fn.getreg("+") or ""
    use_clip = true
  end

  local escaped_text = vim.fn.escape(text, "/.*$^~[]")

  if use_clip then
    vim.fn.setreg("+", escaped_text)
  end

  return escaped_text
end

function utils.tab_split_if_multiple_windows()
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.cmd("tab split")
  end
end

function utils.set_fzf_lua_nvim_listen_address()
  local prefix = "/tmp/fzf-lua-EBNIS-"

  -- For some fzf-lua commands, I get:
  -- nvim: Failed $NVIM_LISTEN_ADDRESS: address already in use
  -- This is the fix I found:

  vim.env.NVIM_LISTEN_ADDRESS = prefix .. os.time()
end

utils.mason_install_path = vim.fn.stdpath("data") .. "/mason/packages"

---Strip the current working directory from a file path
---@param filename string
---@return string
function utils.strip_cwd(filename)
  local pattern = "^"
    .. vim.pesc(vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h") .. "/")
  local stripped = filename:gsub(pattern, "")
  return stripped
end

---Create fzf key mapping
---@param fzf_key_map_options table
---@param config table
function utils.create_fzf_key_maps(fzf_key_map_options, config)
  local keymap_count = vim.v.count
  local fzf_lua = require("fzf-lua")

  -- Format options for display
  local items = {}
  for i, option in ipairs(fzf_key_map_options) do
    if keymap_count == option.count then
      option.action()
      return
    end
    table.insert(items, string.format("%d. %s", i, option.description))
  end

  local prompt = config.prompt or "Select"
  local header = config.header or prompt

  utils.set_fzf_lua_nvim_listen_address()

  fzf_lua.fzf_exec(items, {
    prompt = prompt .. " Options> ",
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["shift-tab"] = "up",
      },
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local selection = selected[1]
        -- Extract option index from selection
        local index = tonumber(selection:match("^(%d+)%."))
        if index and fzf_key_map_options[index] then
          fzf_key_map_options[index].action()
        end
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--header"] = header,
    },
  })
end

return utils
