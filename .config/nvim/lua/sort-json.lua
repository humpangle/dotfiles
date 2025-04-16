local function sort_json_keys()
  local ok, json = pcall(vim.fn.json_decode, vim.api.nvim_get_current_buf())
  if not ok then
    vim.notify("Failed to parse JSON", vim.log.levels.ERROR)
    return
  end

  local function deep_sort(obj)
    if type(obj) ~= "table" then
      return obj
    end
    local sorted = {}
    for k, v in
      vim.iter(obj):sort(function(a, b)
        return a[1] < b[1]
      end)
    do
      sorted[k] = deep_sort(v)
    end
    return sorted
  end

  -- Read buffer contents
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")
  local ok, parsed = pcall(vim.json.decode, content)
  if not ok then
    vim.notify("Failed to parse JSON content", vim.log.levels.ERROR)
    return
  end

  -- Sort it recursively
  local sorted = deep_sort(parsed)

  -- Re-encode
  local formatted = vim.json.encode(sorted, { indent = true })

  -- Write back to buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted, "\n"))
  vim.notify("JSON keys sorted", vim.log.levels.INFO)
end

-- Optional keymap:
-- vim.keymap.set(
--   "n",
--   "<leader>js",
--   sort_json_keys,
--   { desc = "Sort JSON keys recursively" }
-- )

vim.api.nvim_create_user_command(
  "SortJsonKeys",
  sort_json_keys,
  { desc = "Recursively sort JSON keys in current buffer" }
)
