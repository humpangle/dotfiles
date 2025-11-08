vim = vim
local map_key = require("utils").map_key

local function configure_slime_for_tmux(count)
  -- Check if we're in a tmux session
  local tmux_env = vim.fn.system("echo $TMUX"):gsub("%s+", "")
  if tmux_env == "" then
    vim.notify("Not in a tmux session", vim.log.levels.WARN)
    return nil
  end

  -- Get current tmux window index
  local current_window = vim.fn.system("tmux display-message -p '#I'"):gsub("%s+", "")
  local current_window_num = tonumber(current_window)
  if not current_window_num then
    vim.notify("Failed to get current tmux window", vim.log.levels.ERROR)
    return nil
  end

  -- Get tmux session name
  local session_name = vim.fn.system("tmux display-message -p '#S'"):gsub("%s+", "")

  -- Calculate target window (next window) and pane
  local target_window = current_window_num + 1
  local target_pane = count

  -- Configure slime for tmux
  vim.b.slime_target = "tmux"
  vim.b.slime_config = {
    socket_name = "default",
    target_pane = string.format("%s:%d.%d", session_name, target_window, target_pane),
  }

  -- Return target info for notification
  return {
    session = session_name,
    window = target_window,
    pane = target_pane,
  }
end

local function create_kitty_tab_with_cwd()
  local nvim_cwd = vim.fn.getcwd()

  local create_kitty_tab_cmd =
    string.format("kitty @ launch --type=tab --cwd='%s' --tab-title='.' --location=neighbor", nvim_cwd)
  local result = vim.fn.system(create_kitty_tab_cmd):gsub("%s+", "")

  if vim.v.shell_error == 0 then
    vim.print(string.format("Created Kitty tab next to current in %s", nvim_cwd))
    return true
  else
    vim.notify("Failed to create Kitty tab: " .. result, vim.log.levels.ERROR)
    return false
  end
end

local function create_tmux_window_with_cwd()
  local nvim_cwd = vim.fn.getcwd()
  local current_window = vim.fn.system("tmux display-message -p '#I'"):gsub("%s+", "")
  local create_tmux_window_cmd = string.format("tmux new-window -a -c '%s' -P -F '#{window_id}'", nvim_cwd)
  local new_window_id = vim.fn.system(create_tmux_window_cmd):gsub("%s+", "")

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to create tmux window: " .. new_window_id, vim.log.levels.ERROR)
    return false
  end

  local config_cmd = string.format("tmux rename-window -t '%s' ''", new_window_id)
  local result = vim.fn.system(config_cmd)

  if vim.v.shell_error == 0 then
    vim.print(string.format("Created tmux window next to #%s in %s", current_window, nvim_cwd))
    return true
  else
    vim.notify("Failed to configure tmux pane: " .. result, vim.log.levels.ERROR)
    return false
  end
end

local function create_terminal_window_with_cwd()
  local kitty_pid = vim.fn.system("echo $KITTY_PID"):gsub("%s+", "")
  if kitty_pid ~= "" then
    return create_kitty_tab_with_cwd()
  end

  local tmux_env = vim.fn.system("echo $TMUX"):gsub("%s+", "")
  if tmux_env ~= "" then
    return create_tmux_window_with_cwd()
  end

  vim.notify("Not in a tmux session or Kitty terminal", vim.log.levels.WARN)
  return false
end

local function select_markdown_region()
  -- Only work in markdown files
  -- if vim.bo.filetype ~= "markdown" then
  --   return
  -- end

  -- Get all lines in the buffer and scan for delimiters
  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local delimiter_lines = {}

  -- Scan for delimiter lines using direct pattern matching
  -- Pattern: optional spaces, #, one or more =, optional spaces
  -- Must have at least 70 equals signs to be considered a delimiter
  for line_num, line_content in ipairs(all_lines) do
    local trimmed = line_content:match("^[ ]*(.-)[ ]*$")
    if trimmed and trimmed:match("^#=+$") and #trimmed >= 71 then
      table.insert(delimiter_lines, line_num)
    end
  end

  -- Delimiter_lines is already in order since we iterate sequentially

  -- Get current cursor line
  local cursor_line = vim.fn.line(".")

  -- Find delimiters before and after cursor
  local delimiter_before = nil
  local delimiter_after = nil

  for _, line_num in ipairs(delimiter_lines) do
    if line_num < cursor_line then
      delimiter_before = line_num
    elseif line_num > cursor_line then
      delimiter_after = delimiter_after or line_num
    elseif line_num == cursor_line then
      -- Cursor is on a delimiter line
      -- Treat it as if cursor is just before this delimiter
      delimiter_after = line_num
    end
  end

  local start_line, end_line

  -- Determine region type and set selection bounds
  if not delimiter_before and delimiter_after then
    -- Type 1: No delimiter before, delimiter after (exclude delimiter)
    start_line = 1
    end_line = delimiter_after - 1
  elseif delimiter_before and delimiter_after then
    -- Type 2: Delimiter before and after (exclude both delimiters)
    start_line = delimiter_before + 1
    end_line = delimiter_after - 1
  elseif delimiter_before and not delimiter_after then
    -- Type 3: Delimiter before, no delimiter after (exclude delimiter)
    start_line = delimiter_before + 1
    end_line = vim.fn.line("$")
  else
    -- Type 4: No delimiters around cursor - select current paragraph
    -- Find empty lines before and after cursor
    start_line = cursor_line
    end_line = cursor_line

    -- Search backward for empty line or beginning of file
    while start_line > 1 do
      if vim.fn.getline(start_line - 1):match("^%s*$") then
        break
      end
      start_line = start_line - 1
    end

    -- Search forward for empty line or end of file
    local last_line = vim.fn.line("$")
    while end_line < last_line do
      if vim.fn.getline(end_line + 1):match("^%s*$") then
        break
      end
      end_line = end_line + 1
    end
  end

  -- Trim leading empty lines
  while start_line <= end_line and vim.fn.getline(start_line):match("^%s*$") do
    start_line = start_line + 1
  end

  -- Trim trailing empty lines
  while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
    end_line = end_line - 1
  end

  -- Only process if we have valid content
  if start_line > end_line then
    return nil
  end

  -- Get lines from buffer
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  return {
    lines = lines,
    start_line = start_line,
    end_line = end_line,
  }
end

local function process_region(send_to_slime, tmux_target)
  local region = select_markdown_region()
  if not region then
    return
  end

  local lines = region.lines
  local start_line = region.start_line
  local end_line = region.end_line

  -- Yank to system clipboard
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify(#lines .. " line(s) yanked to system clipboard")

  -- Select the region visually
  vim.cmd("normal! " .. start_line .. "G")
  vim.cmd("normal! V")
  vim.cmd("normal! " .. end_line .. "G")

  -- If send_to_slime is true, trigger vim-slime to send the selection
  if send_to_slime and vim.fn.exists(":SlimeSend") == 2 then
    local term_keys = vim.api.nvim_replace_termcodes("<Plug>SlimeRegionSend", true, true, true)
    vim.api.nvim_feedkeys(
      term_keys,
      "m", -- "m" => allow remapping so <Plug> expands
      true -- Third argument (true) => do not escape CSI
    )
    if tmux_target then
      vim.notify(
        string.format(
          "%d line(s) sent to tmux %s:%d.%d",
          #lines,
          tmux_target.session,
          tmux_target.window,
          tmux_target.pane
        )
      )
    else
      vim.notify(#lines .. " line(s) sent to slime")
    end
  end
end

map_key("n", "<localleader><localleader>", function()
  local count = vim.v.count1

  if count == 11 then
    -- Count 11: Create terminal window/tab next to current and cd to neovim's CWD (Kitty/tmux)
    create_terminal_window_with_cwd()
    return
  end

  if count == 9 then
    -- Count 9: Just select and yank to clipboard
    process_region(false, nil)
    return
  end

  if count <= 8 then
    -- Count 0-8: Send to tmux via slime
    local tmux_target = configure_slime_for_tmux(count)
    if tmux_target then
      process_region(true, tmux_target)
      return
    end
  end

  -- Invalid count: Just yank
  vim.notify("Count must be between 0 and 11", vim.log.levels.WARN)
  process_region(false, nil)
end, {
  desc = table.concat({
    "Select markdown region",
    "count 0-8: send to tmux pane",
    "count 9: clipboard only",
    "count 11: create window/tab (Kitty/tmux)",
  }, "/"),
})
