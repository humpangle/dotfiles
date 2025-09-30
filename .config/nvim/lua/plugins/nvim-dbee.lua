local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local dbee_fzf_options = {
  {
    description = "Open                                                                                             1",
    action = function()
      vim.cmd("tab split")
      require("dbee").open()
    end,
    count = 1,
  },
  {
    description = "Query Cancel/Stop Query                                                                          2",
    action = function()
      require('dbee').api.ui.call_log_do_action("cancel_call")
    end,
    count = 2,
  },
  {
    description = "Close                                                                                           22",
    action = function()
      require("dbee").close()
    end,
    count = 22,
  },
  {
    description = "Execute Selection Execute                                                                        3",
    action = function()
      vim.cmd.normal({ "vip" })
      require('dbee').api.ui.editor_do_action("run_selection")
    end,
    count = 3,
  },
}

return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup( --[[optional config]])
  end,
  cmd = {
    "Dbee",
  },
  keys = {
    map_lazy_key("<leader>dby", function()
      utils.create_fzf_key_maps(dbee_fzf_options, {
        prompt = "Dbee",
        header = "Select a Dbee Option",
      })
    end, {
      desc = "Dbee 1/OPen 2/CancelQuery 22/CloseDbee 3/Execute",
    }),
  },
}
