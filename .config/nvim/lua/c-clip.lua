if
  os.getenv("SSH_TTY") == nil
  or os.getenv("SSH_CLIENT") == nil
  or not vim.fn.executable("clip")
then
  return
end

local utils = require("utils")

-- keymap to sync content of unnamed register with external host's clipboard.
-- WHY: https://github.com/wincent/clipper#configuration-for-vimrc
--    This is a workarund for situations where a remote machine's clipboard
--    does not sync with a macos client machine.

utils.map_key("n", "<leader>cc", function()
  local reg_value = vim.fn.getreg('"')
  local cmd = utils.clip_cmd_exec(reg_value)

  if cmd == nil then
    return
  end

  local count = vim.v.count

  if count == 1 then
    vim.cmd.echo("'" .. cmd .. "'")
  elseif count == 2 then
    vim.cmd.echo("'" .. cmd .. " " .. reg_value .. "'")
  end
end, {
  noremap = true,
})
