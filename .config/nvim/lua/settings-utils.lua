local utils = {}

--[[
vim_cmd_: a vim command that will output a string of messages.
dest_cmd: is the place to send the output. If dest_cmd not specified, output will be sent to current buffer.
  Other values for dest_cmd are:
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
    :Vmessage !ls -alh
    :Tmessage echo "Key mappings for Control+A:" | map <C-A>
-- ]]
function utils.RedirMessages(vim_cmd_, dest_cmd)
  dest_cmd = dest_cmd or ""
  dest_cmd = dest_cmd:match("^%s*(.-)%s*$")

  -- Capture command string output in a variable
  local command_string_output = vim.fn.execute(vim_cmd_)

  -- If a destination command is provided, execute it.
  -- If non is provided, command output will be redirected to current buffer (0).
  if dest_cmd ~= "" then
    vim.cmd(dest_cmd)
  end

  local current_row = vim.api.nvim_win_get_cursor(0)[1]
  local insertion_start_row = nil

  if dest_cmd == "" then
    -- If directing output to current buffer, start at the cursor position - output messages always start and end with newlines
    -- so the first visible output will be the line after cursor position.
    insertion_start_row = current_row
  else
    -- If directing to current buffer, start insertion from first row of buffer. Trim leading/trailing newlines from
    -- command output.
    insertion_start_row = 0
    command_string_output = command_string_output:match("^%s*(.-)%s*$")
  end

  -- Split the output string by newline and insert line by line.
  local lines_of_output = vim.split(command_string_output, "\n")

  vim.api.nvim_buf_set_lines(
    0,
    insertion_start_row,
    current_row,
    false,
    lines_of_output
  )
end

return utils
