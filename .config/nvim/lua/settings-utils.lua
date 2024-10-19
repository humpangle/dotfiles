local utils = {}

--[[
msgcmd: a vim command that will output a string of messages.
destcmd: is the place to send the output. If destcmd not specified, output will be sent to current buffer.
  Other values for destcmd are:
    new - horizontal split
    vsplit - vertical split
    tabnew - new tabnew

Examples of usage:
  RedirMessages('registers', '')
  RedirMessages('registers', 'new')
  RedirMessages('registers', 'vnew')
  RedirMessages('registers', 'tabnew')

Create commands to make RedirMessages() easier to use interactively.
  Here are some examples of their use:
    :Bmessage registers
    :Wmessage ls
    :VMessage !ls -alh
    :Tmessage echo "Key mappings for Control+A:" | map <C-A>
-- ]]
function utils.RedirMessages(msgcmd, destcmd)
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

return utils
