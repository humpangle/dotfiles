local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

local function get_avante_opts()
  return require("lazy.core.plugin").values(
    require("lazy.core.config").spec.plugins["avante.nvim"],
    "opts",
    false
  )
end

return {
  "yetone/avante.nvim",
  version = false, -- Never set this value to "*"! Never!
  -- event = "VeryLazy",
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteChat",
    "AvanteChatNew",
    "AvanteClear",
    "AvanteEdit",
    "AvanteFocus",
    "AvanteHistory",
    "AvanteModels",
    "AvanteRefresh",
    "AvanteShowRepoMap",
    "AvanteStop",
    "AvanteSwitchProvider",
    "AvanteSwitchSelectorProvider",
    "AvanteToggle",
  },
  opts = {
    -- add any opts here
    -- for example
    provider = "openai",
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      temperature = 0,
      max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    },
    windows = {
      position = "right",
      width = 40, -- %
      edit = {
        start_insert = false, -- Start insert mode when opening the edit window
      },
      ask = {
        start_insert = false, -- Start insert mode when opening the ask window
      },
    },
    behaviour = {
      use_cwd_as_project_root = true,
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
    -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = {
          "markdown",
          "Avante",
        },
      },
      ft = {
        "markdown",
        "Avante",
      },
    },
  },
  keys = {
    map_lazy_key("<leader>aia", function()
      local count = vim.v.count1

      local avante = require("avante")
      local avante_api = require("avante.api")
      local opts = get_avante_opts()
      opts.windows.width = 40
      opts.windows.position = "right"

      -- clear current chat history
      if count == 2 then
        vim.cmd("AvanteClear")
        return
      end

      if count == 22 then
        vim.cmd("AvanteStop")
        return
      end

      if count == 5 then
        avante_api.select_history()
        return
      end

      if count == 51 then
        avante_api.select_model()
        return
      end

      if count == 59 then
        -- local opts_as_string = table.concat(opts, ",")
        vim.notify('opts_as_string')
        return
      end

      if count == 3 then
        opts.windows.width = 85
        opts.windows.position = "left"
        vim.cmd("tabnew")
        vim.bo.filetype = "AvanteEbnis" -- custom filetype so we don't delete
      end

      avante.setup(opts)
      avante_api.ask()
    end, {
      desc = "Avante",
    }),
  },
}
