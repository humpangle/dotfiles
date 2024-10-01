local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")
local keymap = utils.map_key

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Did we install nerd font
vim.g.have_nerd_font = true

local plugins_table = {
  -- THEMES / COLORSCHEME
  require("plugins/color-schemes"),

  "nvim-lua/plenary.nvim",

  "bronson/vim-visual-star-search",

  require("plugins/cmp"),

  -- Highlight, edit, and navigate code
  require("plugins/treesitter"),
  require("plugins/lsp"),
  require("plugins/dap"),
  -- Fuzzy Finder (files, lsp, etc)
  require("plugins/telescope"),

  require("plugins/coc"),

  -- FUZZY FINDER
  -- sudo apt install bat -- Syntax highlighting
  --  brew install bat
  {
    "junegunn/fzf.vim",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      require("plugins/fzf")
    end,
    dependencies = {
      {

        "junegunn/fzf",
        build = nil, -- "./install --all",
      },
      "stsewd/fzf-checkout.vim",
    },
  },

  -- GIT
  {
    "tpope/vim-fugitive",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      require("plugins/fugitive")
    end,
    dependencies = {
      -- Enable fugitive :GBrowse to open git objects on github
      "tpope/vim-rhubarb",

      -- Adds git related signs to the gutter, as well as utilities for managing changes
      require("plugins/gitsigns"),
    },
  },

  -- Surround text with quotes, parenthesis, brackets, and more.
  {
    "tpope/vim-surround",
  },

  -- A number of useful motions for the quickfix list, pasting and more.
  {
    "tpope/vim-unimpaired",
  },

  -- Manage Vim Sessions Manually
  {
    "tpope/vim-obsession",
    enabled = not plugin_enabled.has_vscode(),
  },
  -- MANAGE VIM SESSIONS AUTOMACTICALLY
  {
    "dhruvasagar/vim-prosession",
    enabled = not plugin_enabled.has_vscode(),
    dependencies = {
      "tpope/vim-obsession",
    },
  },

  -- Statusline / tabline
  -- require("plugins.lualine"),
  require("plugins.lightline"),

  -- TERMINAL
  require("plugins/floaterm"),

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    enabled = not plugin_enabled.has_vscode(),
    opts = {},
  },

  -- "easymotion/vim-easymotion",
  -- Easy motion alternative
  {
    "ggandor/leap.nvim",
    config = function()
      -- https://github.com/kohane27/nvim-config/blob/main/lua/plugins/leap.lua
      local status_ok, leap = pcall(require, "leap")

      if status_ok then
        leap.set_default_keymaps()

        vim.keymap.set({ "n", "o" }, "s", "<Plug>(leap-forward-to)")

        vim.keymap.set({ "n", "o" }, "S", "<Plug>(leap-backward-to)")

        -- mark cursor location before jumping
        vim.api.nvim_create_autocmd("User", {
          pattern = "LeapEnter",
          callback = function()
            vim.cmd("normal m'")
          end,
        })
      end
    end,
  },

  -- Better undo diff
  {
    "simnalamburt/vim-mundo",
    enabled = not plugin_enabled.has_vscode(),
    config = function()
      -- mbbill/undotree
      -- nnoremap <A-u> :UndotreeToggle<CR>
      -- simnalamburt/vim-mundo
      keymap("n", "<A-u>", ":MundoToggle", { noremap = true })
    end,
  },

  -- making rest api call
  {
    "diepm/vim-rest-console",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- Line-by-line Request Body
      vim.g.vrc_split_request_body = 1

      -- bulk upload and external data file -
      -- enable the Elasticsearch support flag.
      vim.g.vrc_elasticsearch_support = 1

      keymap("n", ",MR", ":let b:vrc_split_request_body = <right>")

      -- n = new request/ trigger is <C-J> by default
      vim.g.vrc_trigger = "<C-n>"

      -- let g:vrc_show_command = 1
      -- let g:vrc_debug = 1

      -- make new rest console buffer
      keymap("n", ",nr", ":tabe .rest<Left><Left><Left><Left><Left>")

      -- The output buffer is name `__REST_response__` and will be shared by
      -- all *.rest buffers.
      -- Rename the output buffer if you don't want your output to write to
      -- the `__REST_response__` buffer
      keymap(
        "n",
        ",rr",
        ":let b:vrc_output_buffer_name = '-Rest'<Left><Left><Left><Left><left><left>"
      )
    end,
  },

  require("plugins.dadbod-ui"),

  {
    "t9md/vim-choosewin",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- if you want to use overlay feature: does not work well if there is terminal buffer in the tab
      -- vim.g.choosewin_overlay_enable = 1
      vim.g.choosewin_overlay_enable = 0

      -- invoke with '-'
      keymap("n", "<leader>-", "<Plug>(choosewin)", { noremap = true })
    end,
  },

  -- Send text from vim to tmux/NeoVim :terminal etc
  {
    "jpalardy/vim-slime",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/targets/neovim.md
      vim.g.slime_target = "neovim"
    end,
    config = function()
      require("plugins/slime")
    end,
  },

  -- MARKDOWN
  -- Courtesy : https://elixirforum.com/t/preview-livebook-in-neovim/65080
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = {
        "markdown",
        "livebook",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = {
      "markdown",
      "livebook",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false, -- not plugin_enabled.has_vscode(),
    cmd = {
      "MarkdownPreviewToggle",
      "MarkdownPreview",
      "MarkdownPreviewStop",
    },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_refresh_slow = 1
      vim.g.mkdp_open_to_the_world = 1

      keymap(
        "n",
        "<leader>mt",
        ":MarkdownPreviewToggle<CR>",
        { noremap = true }
      )
    end,
  },

  -- Align Markdown table
  {
    "godlygeek/tabular",
    enabled = not plugin_enabled.has_vscode(),
  },

  -- Quickly toggle maximaize a window
  {
    "szw/vim-maximizer",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      vim.maximizer_set_default_mapping = 0
      keymap({ "n", "x" }, "mm", ":MaximizerToggle!<CR>")
    end,
  },

  {
    "editorconfig/editorconfig-vim",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      vim.g.EditorConfig_exclude_patterns = {
        "fugitive://.*",
      }
    end,
  },

  -- Enhances vim ga with Unicode character names, Vim digraphs, emoji codes
  -- Pressing ga on a character reveals its representation in
  -- decimal,
  -- octal,
  -- hex
  -- Unicode character names
  "tpope/vim-characterize",

  -- FORMATTERS
  -- Works for many files as far as binary that can format the file exists
  {
    "sbdchd/neoformat",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      require("plugins/neoformat")
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
  },

  {
    -- A plugin to color colornames and ANSI codes. :ColoHighlight
    "chrisbra/Colorizer",
  },
  {
    -- Bash Automated Testing System
    -- https://github.com/bats-core/bats-core?tab=readme-ov-file
    "aliou/bats.vim",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- https://github.com/aliou/bats.vim#configuration
      vim.g.bats_vim_consider_dollar_as_part_of_word = true
    end,
  },
  -- HTTP REST-Client Interface
  {
    "mistweaverco/kulala.nvim",
    enabled = not plugin_enabled.has_vscode(),
    config = function()
      -- Setup is required, even if you don't pass any options
      require("kulala").setup({
        -- default_view, body or headers
        default_view = "body",
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = "dev",
        -- enable/disable debug mode
        debug = utils.get_os_env_or_nil("NVIM_DEBUG_HTTP") ~= nil,
        -- default formatters for different content types
        formatters = {
          json = { "jq", "." },
          xml = { "xmllint", "--format", "-" },
          html = { "xmllint", "--format", "--html", "-" },
        },
        -- default icons
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅ ",
          },
          lualine = "🐼",
        },
        -- additional cURL options
        -- e.g. { "--insecure", "-A", "Mozilla/5.0" }
        additional_curl_options = {},
      })
    end,
    init = function()
      -- https://kulala.mwco.app/docs/requirements
      -- This will make Neovim recognize files with the .http extension as HTTP files.
      vim.filetype.add({
        extension = {
          ["http"] = "http",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "http",
        callback = function()
          local table1 = {
            ["<C-k>"] = "jump_prev",
            ["<C-j>"] = "jump_next",
            ["<C-l>"] = "run",
          }

          for key, value in pairs(table1) do
            utils.map_key(
              "n",
              key,
              ":lua require('kulala')." .. value .. "()<CR>",
              {
                noremap = true,
                buffer = 0,
              }
            )
          end
        end,
      })
    end,
  },

  require("plugins/elixir"),
  require("plugins.bigfile-nvim"),

  {
    "github/copilot.vim",
    cmd = {
      "Copilot",
    },
  },
}

require("lazy").setup(plugins_table, {})
