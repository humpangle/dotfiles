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
  require("plugins.bigfile-nvim"),
  -- THEMES / COLORSCHEME
  require("plugins/color-schemes"),

  "nvim-lua/plenary.nvim",

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

  -- choosewin replacement
  {
    "gbrlsnchs/winpick.nvim",
    enabled = not plugin_enabled.has_vscode(),
    init = function()
      -- invoke with '-'
      keymap("n", "<leader>-", function()
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
    enabled = plugin_enabled.render_markdown_nvim(),
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
    init = function()
      keymap("n", "<leader>mt", function()
        local count = vim.v.count

        local arg = "toggle"

        if count == 1 then
          arg = "toggle"
        end

        vim.cmd("RenderMarkdown " .. arg)
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
      keymap({ "n", "x" }, "<leader>mm", ":MaximizerToggle!<CR>")
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

  require("plugins/elixir"),
  require("plugins/ai"),
  require("plugins/neotest"),
  require("plugins/nvim-neoclip"),
  require("plugins/neotree"),
}

require("lazy").setup(plugins_table, {})
