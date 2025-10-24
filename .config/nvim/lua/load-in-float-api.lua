local m = {}

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
  vim.fn.bufload(buf)

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
  vim.bo[buf].bufhidden = opts.buf_hidden or ""

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
