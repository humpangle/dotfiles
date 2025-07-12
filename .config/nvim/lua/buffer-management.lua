local M = {}

M.lazy_doc_path = vim.fn.stdpath("state") .. "/lazy/readme/doc"

function M.is_fugitive_buffer(buffer_name)
  if vim.startswith(buffer_name, "fugitive://") then
    return true
  end

  if vim.endswith(buffer_name, ".fugitiveblame") then
    return true
  end

  return false
end

---@param buffer_name string
function M.is_dap_buffer(buffer_name)
  if vim.startswith(buffer_name, "DAP ") then
    return true
  end

  if vim.startswith(buffer_name, "[dap-") then
    return true
  end

  return false
end

---@param buffer_name string
function M.is_octo_buffer(buffer_name)
  if vim.startswith(buffer_name, "octo://") then
    return true
  end

  if vim.startswith(buffer_name, "OctoChangedFiles") then
    return true
  end

  return false
end

---@param buf_num number
---@param buffer_name string
---@return (boolean) True if the buffer is a CodeCompanion buffer, false otherwise.
function M.is_codecompanion_buffer(buf_num, buffer_name)
  local filetype = vim.bo[buf_num].filetype
  if vim.startswith(filetype, "codecompanion") then
    return true
  end

  if buffer_name then
    local fname = vim.fn.fnamemodify(buffer_name, ":t")
    if fname:match("^%[CodeCompanion%]%s+%d+$") then
      return true
    end
  end
  return false
end

---@param buf_num? integer
function M.is_avante_buffer(buf_num)
  local filetype = buf_num and vim.bo[buf_num].filetype or vim.bo.filetype
  if vim.startswith(filetype, "Avante") then
    return true
  end
  return false
end

---@param buf_name string
function M.is_lazy_doc_buffer(buf_name)
  if vim.startswith(buf_name, M.lazy_doc_path) then
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

  if vim.startswith(b_name, "octo://") then
    return false
  end

  local filetype = vim.bo[buf_num].filetype

  if filetype == "octo_panel" then
    return false
  end

  if filetype == "qf" then
    return false
  end

  if M.is_avante_buffer(buf_num) then
    return false
  end

  if M.is_lazy_doc_buffer(b_name) then
    return false
  end

  if b_name == "" or b_name == "," then
    return true
  end

  return not vim.bo[buf_num].buflisted
end

local function notify(message, opts, level)
  opts = opts or {}
  level = level or vim.log.levels.INFO

  if opts.delay_notify then
    vim.defer_fn(function()
      vim.notify(message, level)
    end, 500)
  else
    vim.notify(message, level)
  end
end

local function delete_un_windowed_buffers(opts)
  local count = 0
  for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1, bufloaded = 0 })) do
    if vim.tbl_isempty(buf.windows) then
      vim.api.nvim_buf_delete(buf.bufnr, { force = true })
      count = count + 1
    end
  end

  notify(count .. " buffers wiped with flag un-windowed " .. "!", opts)
end

function M.delete_all_buffers(delete_flag, opts)
  if delete_flag == "unwindowed" then
    delete_un_windowed_buffers(opts)
    return
  end

  -- local normal_buffers = {}
  local terminal_buffers = {}
  local no_name_buffers = {}
  local dbui_buffers = {}
  local fugitive_buffers = {}
  local dap_buffers = {}
  local octo_buffers = {} -- octo github pr/issues/review plugin
  local avante_buffers = {}
  local codecompanion_buffers = {}

  for _, buf_num in ipairs(vim.api.nvim_list_bufs()) do
    local b_name = vim.fn.bufname(buf_num)

    if string.match(b_name, ".dbout") then
      -- or string.match(b_name, "share/db_ui/")
      table.insert(dbui_buffers, buf_num)
    elseif M.is_fugitive_buffer(b_name) then
      table.insert(fugitive_buffers, buf_num)
    elseif M.is_dap_buffer(b_name) then
      table.insert(dap_buffers, buf_num)
    elseif M.is_octo_buffer(b_name) then
      table.insert(octo_buffers, buf_num)
    elseif M.is_avante_buffer(buf_num) then
      table.insert(avante_buffers, buf_num)
    elseif M.is_codecompanion_buffer(buf_num, b_name) then
      table.insert(codecompanion_buffers, buf_num)
    elseif is_deleteable_unlisted_buffer(b_name, buf_num) then
      table.insert(no_name_buffers, buf_num)
    elseif string.match(b_name, "term://") then
      table.insert(terminal_buffers, buf_num)
    end
  end

  local count = 0

  local function wipeout_buffers(buffer_list)
    for _, buf_num in ipairs(buffer_list) do
      vim.api.nvim_buf_delete(buf_num, { force = true })
      count = count + 1
    end
  end

  -- all buffers
  if delete_flag == "a" then
    wipeout_buffers(no_name_buffers)
    -- wipeout_buffers(terminal_buffers)
    -- wipeout_buffers(normal_buffers)
    wipeout_buffers(fugitive_buffers)
    wipeout_buffers(dap_buffers)
    wipeout_buffers(octo_buffers)
    wipeout_buffers(avante_buffers)
    wipeout_buffers(codecompanion_buffers)
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
  elseif delete_flag == "octo" then
    wipeout_buffers(octo_buffers)
  elseif delete_flag == "avante" then
    wipeout_buffers(avante_buffers)
  elseif delete_flag == "codecompanion" then
    wipeout_buffers(codecompanion_buffers)
  else
    notify(
      "Unknown delete FLAG " .. delete_flag,
      opts,
      vim.log.levels.ERROR
    )
    return
  end

  notify(count .. " buffers wiped with flag " .. delete_flag .. "!", opts)
end

function M.delete_buffers_keymap()
  require("utils").map_key("n", "<leader>be", function()
    local count = vim.v.count

    if count == 0 then
      -- Delete all empty buffers
      require("buffer-management").delete_all_buffers("e")
      return
    end

    if count == 1 then
      require("buffer-management").delete_all_buffers("fugitive")
      return
    end

    if count == 2 then
      local answer = vim.fn.input("Delete all buffers? (Yes/No): ")
      if answer == "Yes" then
        require("buffer-management").delete_all_buffers("a")
      else
        vim.notify(
          "Not deleting ALL buffers - too destructive!",
          vim.log.levels.WARN
        )
      end
      return
    end

    local fzf_lua = require("fzf-lua")

    local deletion_options = {
      {
        description = "DAP",
        type = "dap",
      },
      {
        description = "Octo",
        type = "octo",
      },
      {
        description = "CodeCompanion",
        type = "codecompanion",
      },
      {
        description = "Avante",
        type = "avante",
      },
      {
        description = "Terminal",
        type = "t",
      },
      {
        description = "DB DadBod UI",
        type = "dbui",
      },
      {
        description = "UnWindowed",
        type = "unwindowed",
      },
    }

    -- Format options for display
    local items = {}
    for i, option in ipairs(deletion_options) do
      table.insert(items, string.format("%d. %s", i, option.description))
    end

    -- fzf picker
    fzf_lua.fzf_exec(items, {
      prompt = "Buffer Deletion> ",
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then
            return
          end

          local selection = selected[1]
          local index = tonumber(selection:match("^(%d+)%."))
          if index and deletion_options[index] then
            local option = deletion_options[index]
            -- vim.print(option)

            -- Handle special case for avante
            if option.type == "avante" then
              if
                require("buffer-management").is_avante_buffer()
              then
                vim.cmd.normal("gT")
              end
              pcall(function()
                require("buffer-management").delete_all_buffers(
                  option.type,
                  { delay_notify = true }
                )
              end)
              return
            end

            require("buffer-management").delete_all_buffers(
              option.type,
              { delay_notify = true }
            )
          end
        end,
      },
      fzf_opts = {
        ["--no-multi"] = "",
        ["--header"] = "Select buffer deletion type",
      },
    })
  end, {
    noremap = true,
    desc = "Buffer deletion selector with fzf",
  })
end

return M
