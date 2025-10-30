local plugin_enabled = require("plugins/plugin_enabled")
local utils = require("utils")
local map_key = utils.map_key

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  {
    "vhyrro/luarocks.nvim",
    priority = 10000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    opts = {
      rocks = {
        "magick",
      }, -- specifies a list of rocks to install
      -- luarocks_build_args = { "--with-lua=/my/path" }, -- extra options to pass to luarocks's configuration script
    },
  },

  require("plugins.bigfile-nvim"),
  -- THEMES / COLORSCHEME
  require("plugins/color-schemes"),

  "nvim-lua/plenary.nvim",

  -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
  -- used for completion, annotations and signatures of Neovim apis
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  {
    "Joakker/lua-json5",
    cond = true, -- false,
    enabled = plugin_enabled.has_lua_json5(),
    priority = 1000,
    -- If the ./install.sh file does not run
    --    cd ~/.local/share/nvim/lazy/lua-json5
    --    ./install.sh
    build = "./install.sh",
  },

  "bronson/vim-visual-star-search",

  require("plugins/blink-cmp"),

  -- Highlight, edit, and navigate code
  require("plugins/treesitter"),
  require("plugins/nvim-lspconfig"),
  require("plugins/dap"),
  -- Fuzzy Finder (files, lsp, etc)
  require("plugins/telescope"),

  -- FUZZY FINDER
  -- sudo apt install bat -- Syntax highlighting
  --  brew install bat
  require("plugins/fzf-lua"),
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

  require("plugins.vim-obsession"),

  -- Statusline / tabline
  -- require("plugins.lualine"),
  require("plugins.lightline"),

  -- TERMINAL
  require("plugins/floaterm"),

  -- "gc" to comment visual regions/lines
  -- "gb" to comment visual regions/block
  {
    "numToStr/Comment.nvim",
    enabled = not plugin_enabled.has_vscode(),
    config = function()
      require("Comment").setup()

      local ft = require("Comment.ft")
      ft.gitconfig = "#%s"
    end,
  },

  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      map_key({ "n", "o" }, "s", function()
        leap.leap({})
      end)
      map_key({ "n", "o" }, "S", function()
        leap.leap({ backward = true })
      end)
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
      map_key("n", "<A-u>", ":MundoToggle", { noremap = true })
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

      map_key(
        "n",
        "<localleader>MR",
        ":let b:vrc_split_request_body = <right>"
      )

      -- n = new request/ trigger is <C-J> by default
      vim.g.vrc_trigger = "<C-n>"

      -- let g:vrc_show_command = 1
      -- let g:vrc_debug = 1

      -- make new rest console buffer
      map_key(
        "n",
        "<localleader>nr",
        ":tabe .rest<Left><Left><Left><Left><Left>"
      )

      -- The output buffer is name `__REST_response__` and will be shared by
      -- all *.rest buffers.
      -- Rename the output buffer if you don't want your output to write to
      -- the `__REST_response__` buffer
      map_key(
        "n",
        "<localleader>rr",
        ":let b:vrc_output_buffer_name = '-Rest'<Left><Left><Left><Left><left><left>"
      )
    end,
  },

  require("plugins.dadbod-ui"),

  -- choosewin replacement
  {
    "gbrlsnchs/winpick.nvim",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- invoke with '-'
      map_key("n", "<leader>-", function()
        local winpick = require("winpick")
        local winid = winpick.select()

        if winid then
          vim.api.nvim_set_current_win(winid)
        end
      end, { noremap = true })
    end,
    config = function()
      local winpick = require("winpick")

      winpick.setup({
        border = "single",
        -- doesn't ignore any window by default
        filter = function(win_id, _, default_filter_value)
          if not vim.api.nvim_win_is_valid(win_id) then
            return false
          end

          local config = vim.api.nvim_win_get_config(win_id)

          if not config.focusable then
            return false
          end

          return default_filter_value
        end,
        prompt = "Pick a window: ",
        -- format_label = winpick.defaults.format_label, -- formatted as "<label>: <buffer name>"
        format_label = function(label, win_id)
          -- :TODO: mark current buffer in different color

          if win_id == vim.api.nvim_get_current_win() then
            return label .. label
          end

          return label
        end,
        chars = nil,
      })
    end,
  },

  -- Send text from vim to tmux/NeoVim :terminal etc
  require("plugins/slime"),

  -- MARKDOWN
  -- Courtesy : https://elixirforum.com/t/preview-livebook-in-neovim/65080
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = plugin_enabled.render_markdown_nvim(),
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Whether markdown should be rendered by default.
      enabled = false,
      file_types = {
        "markdown",
        "livebook",
        "Avante",
        "AvanteInput",
        "codecompanion",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = {
      "markdown",
      "livebook",
      "Avante",
      "AvanteInput",
      "codecompanion",
    },
    init = function()
      map_key("n", "<leader>mt", function()
        vim.cmd("RenderMarkdown toggle")
      end, { noremap = true })
    end,
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

      map_key(
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
      map_key({ "n", "x" }, "mm", ":MaximizerToggle!<CR>")
      map_key({ "n", "x" }, "<leader>mm", ":MaximizerToggle!<CR>")
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
  require("plugins.neoformat"),

  {
    "windwp/nvim-autopairs",
    enabled = plugin_enabled.nvim_autopairs(),
    event = "InsertEnter",
    opts = {}, -- this is equalent to setup({}) function
  },

  {
    -- A plugin to color colornames and ANSI codes. :ColoHighlight
    "chrisbra/Colorizer",
    enabled = plugin_enabled.colorizer(),
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

  {
    "CarloWood/vim-plugin-AnsiEsc",
    enabled = not plugin_enabled.has_vscode(),
  },

  {
    "fladson/vim-kitty",
    ft = "kitty",
  },

  require("plugins/noice-nvim"),
  require("plugins/elixir"),
  require("plugins/ai"),
  require("plugins/ai/avante-nvim"),
  require("plugins/ai/codecompanion-nvim"),
  require("plugins/ai/copilot"),
  require("plugins/ai/claude-code-nvim"),
  require("plugins/neotest"),
  require("plugins/neotree"),
  require("plugins/mini-files"),
  require("plugins.image-nvim"),
  require("plugins/octo-nvim"),
  require("plugins/mini-align"),
  require("plugins/indent-blankline"),
  require("plugins/anki-nvim"),
  require("plugins/refactoring"),
  require("plugins/symlink"),
  -- require("plugins/csvview-nvim"), -- disable until there is need for it
  require("plugins/live-preview-nvim"),
  require("plugins/nvim-dbee"),
  require("plugins/emoji-nvim"),
  require("plugins.yazi-nvim"),
}

---@diagnostic disable:missing-fields
require("lazy").setup(plugins_table, {})
