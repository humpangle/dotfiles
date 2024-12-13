local function replace_placeholders_with_bind_params()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- The last line contains the bind parameters
  local last_line = lines[#lines]
  -- Remove leading '--' and optional parentheses
  local params_str = last_line:gsub("^%s*%-%-%s*", ""):gsub("%((.*)%)", "%1")

  -- Split parameters into a table by commas
  local params = {}
  for param in params_str:gmatch("[^,]+") do
    param = param:match("^%s*(.-)%s*$") -- Trim spaces
    table.insert(params, param)
  end

  -- Replace '?' in the SQL with corresponding parameters
  local param_index = 1
  for i, line in ipairs(lines) do
    if not line:match("^%s*%-%-") then -- Ignore comment lines
      lines[i] = line:gsub("%?", function()
        local replacement = params[param_index] or "?"
        param_index = param_index + 1

        -- Add quotes for string literals
        if replacement:match("^'.*'$") or tonumber(replacement) then
          return replacement
        else
          return string.format("'%s'", replacement)
        end
      end)
    end
  end

  -- Echo the modified lines joined by newlines
  -- local x = table.concat(lines, "\n")
  -- vim.cmd.echo('"' .. x .. '"')
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  -- s_utils.RedirMessages('echo "' .. x .. '"', "vnew")
end

-- Bind the function to a command for easier usage
vim.api.nvim_create_user_command(
  "ReplaceSqlPlaceholders",
  replace_placeholders_with_bind_params,
  {}
)
