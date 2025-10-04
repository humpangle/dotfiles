local utils = require("utils")
local plugin_enabled = require("plugins/plugin_enabled")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier for people to discover. Otherwise,
-- you normally need to press <C-\><C-n>, which is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit
-- terminal mode

-- utils.map_key("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local function send_to_term_with_slime(split_direction)
  local current_buf = vim.api.nvim_get_current_buf()

  -- Yank current paragraph
  vim.cmd("normal! yip")
  local paragraph = vim.fn.getreg('"')

  vim.cmd(utils.split_direction(split_direction))
  vim.cmd("term")

  vim.b[current_buf].slime_config = {
    jobid = vim.b.terminal_job_id, -- neovim terminal job id
  }
  vim.b[current_buf].slime_target = "neovim"

  -- Switch back to the original buffer to make slime work
  if split_direction == "t" then
    vim.cmd.normal({ "gT" })
  else
    vim.cmd.wincmd("p")
  end

  vim.fn["slime#send"](paragraph)
end

-- Terminal in new tab/split
utils.map_key("n", "<localleader>tt", function()
  local count = vim.v.count

  if count == 2 then
    vim.cmd("vertical split")
  elseif count == 3 then
    vim.cmd("tab split")
  elseif count == 6 then
    send_to_term_with_slime()
    return
  elseif count == 62 then
    send_to_term_with_slime("v")
    return
  elseif count == 63 then
    send_to_term_with_slime("t")
    return
  elseif count == 4 then
    vim.cmd("botright split")
  else
    vim.cmd("split")
  end

  vim.cmd("term")
end, { noremap = true, desc = "terminal 0=s 1=v 2=t 4/botright 6/slime" })

local clear_terminal = function()
  local current_mode = vim.fn.mode()

  -- Step 1: Enter terminal mode if in normal mode
  if current_mode == "n" then
    vim.fn.feedkeys("a", "n")
    -- Add small delay to ensure mode switch completes
    vim.cmd("sleep 5m")
  end

  -- Step 2: Send Ctrl-C to stop whatever is running
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<C-c><C-c><C-c><C-c><C-c><C-c><C-c><C-c><C-c><C-c>", true, false, true),
    "t",
    false
  )

  -- Step 3: Send 'C' and Enter to clear the screen
  vim.api.nvim_feedkeys("C", "t", true)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<CR>", true, false, true),
    "t",
    false
  )

  -- Step 4: Scroll to the top
  local sb = vim.bo.scrollback
  vim.bo.scrollback = 1
  vim.bo.scrollback = sb

  if vim.v.count == 1 then
    -- Return to terminal-normal mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true),
      "t",
      true
    )
    vim.schedule(function()
      vim.cmd.normal({ "gg" })
    end)
  end
end

utils.map_key("t", "<C-l>", clear_terminal)
-- while :; do ll; ll ~; sleep 1; done

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    utils.map_key("n", "d=", clear_terminal, {
      silent = true,
      desc = "Clear terminal. Supply count > 0 to enter insert mode.",
    }, 0)

    vim.opt.number = true
    vim.opt.relativenumber = true
    -- https://stackoverflow.com/a/45317514
    vim.cmd("setlocal scrollback=-1")

    vim.wo.spell = false
  end,
})

if plugin_enabled.has_termux() then
  -- Exit terminal mode
  vim.keymap.set(
    "t",
    "<C-k>",
    "<C-\\><C-n>",
    { desc = "Exit terminal mode in termux" }
  )
end
