if vim.fn.executable("clip") then
  local utils = require("utils")

  -- keymap to sync content of unnamed register with external host's clipboard.
  -- WHY: https://github.com/wincent/clipper#configuration-for-vimrc
  --    This is a workarund for situations where a remote machine's clipboard
  --    does not sync with a macos client machine.

  local result = nil
  local nc_flag = ""

  -- Ubuntu OS requires the -N flag to the netcat nc executable.
  local handle = io.popen(
    "grep -q 'ubuntu' /etc/os-release &>/dev/null && echo 'yes' || echo 'no'"
  )
  if handle then
    result = handle:read("*a"):gsub("%s+", "")
    handle:close()
  end

  if result == "yes" then
    nc_flag = "-N"
  end

  local cmd = "nc " .. nc_flag .. " localhost 8378"

  utils.map_key("n", "<leader>cc", function()
    local reg_value = vim.fn.getreg('"')
    vim.fn.system(cmd, reg_value)

    local count = vim.v.count

    if count == 1 then
      vim.cmd.echo("'" .. cmd .. "'")
    elseif count == 2 then
      vim.cmd.echo("'" .. cmd .. " " .. reg_value .. "'")
    end
  end, {
    noremap = true,
  })
end
