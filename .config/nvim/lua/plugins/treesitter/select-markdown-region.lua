local function select_markdown_region(send_to_slime)
  -- Only work in markdown files
  -- if vim.bo.filetype ~= "markdown" then
  --   return
  -- end

  local query_string =
    '((inline) @delimiter (#match? @delimiter "^[ ]*#=[=]{79,}[ ]*$"))'
  local parser = require("nvim-treesitter.parsers").get_parser()
  local ok, query =
    pcall(vim.treesitter.query.parse, parser:lang(), query_string)
  if not ok then
    return
  end

  local tree = parser:parse()[1]
  local delimiter_lines = {}

  -- Collect all delimiter line numbers
  for _, node in query:iter_captures(tree:root(), 0) do
    local start_row, _, _, _ = node:range()
    table.insert(delimiter_lines, start_row + 1) -- Convert to 1-based line number
  end

  -- Sort delimiter lines
  table.sort(delimiter_lines)

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
  vim.notify(#lines .. " lines yanked to system clipboard")

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
      true -- third arg (true) => do not escape CSI
    )
    vim.notify(#lines .. "lines sent to slime")
  end
end

return select_markdown_region
