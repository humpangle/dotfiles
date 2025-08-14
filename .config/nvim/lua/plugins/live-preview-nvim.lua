return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
  },
  cmd = {
    "LivePreview",
  },
  config = function()
    require("livepreview.config").set({
      picker = "fzf-lua",
    })
  end,
}
