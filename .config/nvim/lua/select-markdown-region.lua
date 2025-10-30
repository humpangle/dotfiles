local map_key = require("utils").map_key

local function select_markdown_region(send_to_slime)
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
  while
    start_line <= end_line and vim.fn.getline(start_line):match("^%s*$")
  do
    start_line = start_line + 1
  end

  -- Trim trailing empty lines
  while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
    end_line = end_line - 1
  end

  -- Only process if we have valid content
  if start_line > end_line then
    return
  end

  -- Yank to system clipboard
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify(#lines .. " line(s) yanked to system clipboard")

  -- Select the region visually
  vim.cmd("normal! " .. start_line .. "G")
  vim.cmd("normal! V")
  vim.cmd("normal! " .. end_line .. "G")

  -- If send_to_slime is true, trigger vim-slime to send the selection
  if send_to_slime and vim.fn.exists(":SlimeSend") == 2 then
    local term_keys = vim.api.nvim_replace_termcodes(
      "<Plug>SlimeRegionSend",
      true,
      true,
      true
    )
    vim.api.nvim_feedkeys(
      term_keys,
      "m", -- "m" => allow remapping so <Plug> expands
      true -- Third argument (true) => do not escape CSI
    )
    vim.notify(#lines .. " line(s) sent to slime")
  end
end

map_key("n", "<localleader><localleader>", function()
  local count = vim.v.count
  -- If count == 0, send to slime; otherwise just select and yank
  select_markdown_region(count == 0)
end, {
  desc = "Select markdown region based on #=== delimiters (with count: send to slime)",
})
