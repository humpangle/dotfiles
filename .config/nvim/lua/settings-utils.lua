local utils = {}

function utils.RedirMessages(msgcmd, destcmd)
  --[[ Examples of usage:
        RedirMessages('registers', '')
        RedirMessages('registers', 'new')
        RedirMessages('registers', 'vnew')
        RedirMessages('registers', 'tabnew')
  -- ]]

  -- Redirect command output to a variable in Lua
  local message = vim.fn.execute(msgcmd)

  -- If a destination command is provided, execute it
  if destcmd and #destcmd > 0 then
    vim.cmd(destcmd)
  end

  -- Insert the captured messages into the current buffer
  -- Split the message by newline and insert line by line
  local lines = vim.split(message, "\n")
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, lines)
end

--[[ Create commands to make RedirMessages() easier to use interactively.
  Here are some examples of their use:
      :BufMessage registers
      :WinMessage ls
      :TabMessage echo "Key mappings for Control+A:" | map <C-A>
--]]

return utils
