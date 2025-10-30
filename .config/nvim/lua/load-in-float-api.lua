local m = {}

--- Opens a file in a floating window with customizable options
--- @param filepath string|nil Path to the file to open (defaults to current file if nil or empty)
--- @param opts table|nil Optional configuration table with the following fields:
---   • width: number (default: 0.9) - Width of floating window as fraction of screen width (0.0-1.0)
---   • height: number (default: 0.9) - Height of floating window as fraction of screen height (0.0-1.0)
---   • border: string (default: "rounded") - Border style: "none", "single", "double", "rounded", "solid", "shadow"
---   • show_title: boolean (default: true) - Whether to show the filename as window title
---   • buf_hidden: string (default: "hide") - Buffer behavior when window closes:
---       - "hide": buffer stays around when window closes
---       - "wipe": buffer is completely removed when window closes
---       - "delete": buffer is deleted when window closes
---       - "unload": buffer is unloaded when window closes
---       - "": standard buffer behavior
---   • cursor_at_end: boolean (default: false) - Position cursor at the last line of the file
---   • close_on_save: boolean (default: false) - Automatically close the float after saving (BufWritePost)
---   • close_keys: table (default: { any = "<C-q>" }) - Key mappings to close the float:
---       - normal: string - Key mapping for normal mode only
---       - any: string - Key mapping for all modes (normal, insert, visual, select)
---   • check_autocmd: boolean (default: false) - Use noautocmd when loading buffer to avoid ReadPre autocommand issues
--- @return number|nil win Window handle of the floating window, or nil on error
--- @return number|nil buf Buffer handle of the file buffer, or nil on error
function m.load_in_float(filepath, opts)
  opts = opts or {}
  if not filepath or filepath == "" then
    filepath = vim.fn.expand("%:p")
  end

  -- Normalize the filepath to absolute path for comparison
  filepath = vim.fn.fnamemodify(filepath, ":p")

  -- Error handling: check if file is readable (if it exists)
  if
    vim.fn.filereadable(filepath) == 0
    and vim.fn.isdirectory(filepath) == 1
  then
    vim.notify("Cannot edit directory: " .. filepath, vim.log.levels.ERROR)
    return nil, nil
  end

  -- Check if file is already open in a floating window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_config = vim.api.nvim_win_get_config(win)
    if win_config.relative ~= "" then -- It's a floating window
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name == filepath then
        -- File is already open in this floating window, focus on it
        vim.api.nvim_set_current_win(win)
        return win, buf
      end
    end
  end

  -- Store previous window for focus restoration
  local prev_win = vim.api.nvim_get_current_win()

  -- File-backed buffer so :w writes to disk
  local buf = vim.fn.bufadd(filepath)

  -- Pass `check_autocmd` for situations where the float complains about autocommand
  if opts.check_autocmd then
    -- Load buffer with noautocmd to avoid ReadPre autocommand issues
    local ok, _ = pcall(function()
      vim.cmd("noautocmd call bufload(" .. buf .. ")")
    end)

    if not ok then
      -- Fallback: try without noautocmd
      vim.fn.bufload(buf)
    end
  else
    vim.fn.bufload(buf)
  end

  -- Geometry
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor((opts.width or 0.9) * ui.width)
  local height = math.floor((opts.height or 0.9) * ui.height)
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = opts.border or "rounded",
    title = opts.show_title ~= false and vim.fn.fnamemodify(filepath, ":.")
      or nil,
    title_pos = "center",
    noautocmd = true,
  })

  -- Look & behavior
  vim.wo[win].number = true
  vim.wo[win].relativenumber = true
  vim.wo[win].signcolumn = "yes"
  vim.wo[win].winhl = "NormalFloat:NormalFloat,FloatBorder:FloatBorder"

  -- • Default (no option): bufhidden = "hide" - buffer stays around when window closes
  -- • Wipe buffer: bufhidden = "wipe" - buffer is completely removed when window closes
  -- • Delete buffer: bufhidden = "delete" - buffer is deleted when window closes
  -- • Unload buffer: bufhidden = "unload" - buffer is unloaded when window closes
  -- • No special behavior: bufhidden = "" - standard buffer behavior
  vim.bo[buf].bufhidden = opts.buf_hidden or "hide"

  vim.bo[buf].modifiable = true
  vim.bo[buf].readonly = false

  -- Position cursor at the last line (if enabled)
  if opts.cursor_at_end == true then
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(win) then
        local line_count = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_win_set_cursor(win, { line_count, 0 })
      end
    end)
  end

  -- Close helpers (no <Esc> binding)
  local function close_win()
    if vim.api.nvim_win_is_valid(win) then
      -- Save before close if buffer is modified
      if vim.bo[buf].modified then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent! write")
        end)
      end
      vim.api.nvim_win_close(win, false)
    end
  end

  -- Focus restoration: return to previous window when float closes
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(prev_win) then
        vim.api.nvim_set_current_win(prev_win)
      end
    end,
  })

  -- Auto-close on save (optional)
  if opts.close_on_save then
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,
      once = true,
      callback = close_win,
    })
  end

  -- Defaults: <C-q> in any mode
  local close_keys = opts.close_keys or { any = "<C-q>" }
  if close_keys.normal then
    vim.keymap.set(
      "n",
      close_keys.normal,
      close_win,
      { buffer = buf, silent = true, nowait = true, desc = "Close float" }
    )
  end
  if close_keys.any then
    vim.keymap.set(
      { "n", "i", "v", "x" },
      close_keys.any,
      close_win,
      { buffer = buf, silent = true, desc = "Close float" }
    )
  end

  -- You can always use :q or :close too
  return win, buf
end

return m
