-- https://github.com/kohane27/nvim-config/blob/main/lua/plugins/leap.lua
local status_ok, leap = pcall(require, "leap")

if status_ok then
  leap.set_default_keymaps()

  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
  vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward-to)")

  -- mark cursor location before jumping
  vim.api.nvim_create_autocmd("User", {
    pattern = "LeapEnter",
    callback = function()
      vim.cmd("normal m'")
    end,
  })
end
