-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
Vimw = Vim.wo
Vimf = Vim.fn

-- Automatically install lazy
local lazy_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = lazy_dir .. "/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install your plugins here
local plugins = {
  -- THEMES / COLORSCHEME
  {
    "rakr/vim-one",
    "lifepillar/vim-gruvbox8",
    "lifepillar/vim-solarized8"
  },

  -- LANGUAGE SERVERS / SYNTAX CHECKING
  {
    "neoclide/coc.nvim",
    branch = "release",
    enabled = false,
    config = function()
      require("plugins/coc")
    end,
    -- ft = {
    -- 	"elixir",
    -- 	"json",
    -- 	"jsonc",
    -- 	"python",
    -- 	"html",
    -- 	"javascript",
    -- 	"vim",
    -- 	"css",
    -- 	"sass",
    -- 	"scss",
    -- 	"php",
    -- 	"blade",
    -- 	"sh",
    -- 	"bash",
    -- 	"markdown",
    -- 	"lua",
    -- },
    -- cmd = { "CocActionAsync" },

    dependencies = {
      { "neoclide/jsonc.vim" },

      -- Laravel blade
      {
        "jwalton512/vim-blade",
      },

      {
        "kristijanhusak/vim-dadbod-completion",
        -- enabled = false, -- favor sqls
      },

      -- Laravel
      {
        "noahfrederick/vim-laravel",
        enabled = true,
        dependencies = {
          "noahfrederick/vim-composer",
          "tpope/vim-projectionist",
          "tpope/vim-dispatch",
        },
      },
    },
  },

  -- NATIVE NEOVIM LSP / COMPLETION ENGINE
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins/nvim-cmp")
    end,

    dependencies = {
      -- snippet engine THIS REQUIRED BY THE PLUGIN
      {
        "L3MON4D3/LuaSnip",
      },

      -- COMPLETION SOURCES

      -- snippet completions
      "saadparwaiz1/cmp_luasnip",
      -- buffer completions
      "hrsh7th/cmp-buffer",

      -- path completions
      "hrsh7th/cmp-path",
      -- / COMPLETION SOURCES
    },
  },

  -- FUZZY FINDER
  -- sudo apt install bat -- Syntax highlighting
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "stsewd/fzf-checkout.vim",
  -- "chengzeyi/fzf-preview.vim", -- requires COC

  -- GIT
  "airblade/vim-gitgutter",
  {
    "tpope/vim-fugitive",
    dependencies = {
      -- Enable fugitive :GBrowse to open git objects on github
      "tpope/vim-rhubarb",
    },
  },

  -- Statusline
  "itchyny/lightline.vim",

  -- Terminal
  {
    "voldikss/vim-floaterm",
    config = function()
      require("plugins/floaterm")
    end,
    dependencies = { "voldikss/fzf-floaterm" },
  },

  -- Better undo diff
  {
    "simnalamburt/vim-mundo",
    -- enabled = false,
    config = function()
      Cmd([[
        " mbbill/undotree
        " nnoremap <A-u> :UndotreeToggle<CR>
        " simnalamburt/vim-mundo
        nnoremap <A-u> :MundoToggle<CR>
      ]])
    end,
  },

  "tomtom/tcomment_vim",

  -- Surround text with quotes, parenthesis, brackets, and more.
  "tpope/vim-surround",

  -- A number of useful motions for the quickfix list, pasting and more.
  "tpope/vim-unimpaired",

  -- MANAGE VIM SESSIONS AUTOMACTICALLY
  {
    "dhruvasagar/vim-prosession",
    dependencies = {
      "tpope/vim-obsession",
    }
  },

  -- Color highlighter - superior
  -- requires golang (asdf plugin-add golang && asdf install golang <version>)
  {
    "rrethy/vim-hexokinase",
    build = "make hexokinase",
  },

  -- color picker
  {
    "KabbAmine/vCoolor.vim",
    config = function()
      Cmd([[
        " Disable default mappings
        let g:vcoolor_disable_mappings = 1

        " insert hex color
        let g:vcoolor_map = '<a-c>'
        " Insert rgb color
        let g:vcool_ins_rgb_map = '<a-r>'
        " Insert rgba color
        let g:vcool_ins_rgba_map = '<a-z>'
        " Insert hsl color
        let g:vcool_ins_hsl_map = '<a-h>'
      ]])
    end,
  },

  "nelstrom/vim-visual-star-search",

  -- "easymotion/vim-easymotion",
  -- Easy motion alternative
  {
    "ggandor/leap.nvim",
    config = function()
      require("plugins/ggandor-leap")
    end,
  },

  -- SYNTAX HIGHLIGHTING
  "elixir-editors/vim-elixir",
  "jparise/vim-graphql",
  -- Powershell
  "pprovost/vim-ps1",
  -- kotlin
  "udalov/kotlin-vim",
  -- Highlight, navigate, and operate on sets of matching text.
  "andymass/vim-matchup",
  "hashivim/vim-terraform",
  "pearofducks/ansible-vim",
  "nelsyeung/twig.vim",

  -- making rest api call
  {
    "diepm/vim-rest-console",
    config = function()
      Cmd([[
        " Line-by-line Request Body
        let g:vrc_split_request_body = 1

        " bulk upload and external data file -
        " enable the Elasticsearch support flag.
        let g:vrc_elasticsearch_support = 1
        nnoremap ,MR :let b:vrc_split_request_body = <right>

        " n = new request/ trigger is <C-J> by default
        let g:vrc_trigger = '<C-n>'

        " let g:vrc_show_command = 1
        " let g:vrc_debug = 1

        " make new rest console buffer
        nnoremap ,nr :tabe .rest<Left><Left><Left><Left><Left>

        " The output buffer is name `__REST_response__` and will be shared by
        " all *.rest buffers.
        " Rename the output buffer if you don't want your output to write to
        " the `__REST_response__` buffer
        nnoremap ,rr :let b:vrc_output_buffer_name = '-Rest'<Left><Left><Left><Left><left><left>
      ]])
    end,
  },

  -- Database management
  "tpope/vim-dadbod",
  -- https://alpha2phi.medium.com/vim-neovim-managing-databases-d253faf4a0cd
  {
    "kristijanhusak/vim-dadbod-ui",
    config = function()
      Cmd([[
        " postgres — postgresql://user1:userpwd@localhost:5432/testdb
        " mysql — mysql://user1:userpwd@127.0.0.1:3306/testdb
        " sqlite - sqlite:path-to-sqlite-database
        " :w = execute query in open buffer

        nnoremap <leader>du :tab new<CR>:DBUI<CR><C-w>o<bar><C-w>v<bar>:e ~/.local/share/db_ui/connections.json<CR>
        nnoremap <leader>df :DBUIFindBuffer<CR>
        nnoremap <leader>dr :DBUIRenameBuffer<CR>
        nnoremap <leader>dl :DBUILastQueryInfo<CR>
      ]])
    end,
  },

  -- Image preview
  -- pip install -U Pillow
  "mi60dev/image.vim",

  -- tmux-like window navigation
  {
    "s1n7ax/nvim-window-picker",
    tag = "v1.*",
    enabled = false,
    config = function()
      require "window-picker".setup({
        include_current_win = true,
        show_prompt = false,
        filter_rules = { bo = { buftype = {} } },
      })

      local picker = require("window-picker")

      vim.keymap.set("n", "<leader>-", function()
        local picked_window_id = picker.pick_window() or
            vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
      end, { desc = "Pick a window" })
    end,
  },
  {
    "t9md/vim-choosewin",
    enabled = false,
    config = function()
      Cmd([[
      " if you want to use overlay feature
      let g:choosewin_overlay_enable = 1
      " invoke with '-'
      nmap <Leader>- <Plug>(choosewin)
      ]])
    end,
  },

  -- Send text from vim to tmux/NeoVim :terminal etc
  {
    "jpalardy/vim-slime",
    config = function()
      require("plugins/vim-slime")
      -- ctrl-c ctrl-c
      -- ctrl-c v
    end,
  },

  -- MARKDOWN
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    config = function()
      Vimg.mkdp_refresh_slow = 1
      Cmd([[
      nnoremap <leader>mt :MarkdownPreviewToggle<CR>
      let g:mkdp_open_to_the_world = 1
      ]])
    end,
  },

  -- Another markdown preview
  {
    "ellisonleao/glow.nvim",
    opt = true,
    enabled = false,
    setup = function()
      -- Vimg.glow_binary_path = "~\\scoop\\apps\\glow\\current"
    end,
  },

  -- Align Markdown table
  "godlygeek/tabular",

  -- Tag generation - browse tags with FZF - keymap: `,bt` / `,pt`
  {
    "ludovicchabant/vim-gutentags",
    opt = false,
    enabled = false,
    setup = function()
      Vimg.gutentags_add_default_project_roots = 0
      Vimg.gutentags_project_root = { ".git", "package.json" }
      Vimg.gutentags_trace = 0
    end,
  },

  -- Quickly toggle maximaize a tab
  "szw/vim-maximizer",

  "editorconfig/editorconfig-vim",

  -- Debugging
  {
    "puremourning/vimspector",
    enabled = false,
    setup = function()
      Vimg.vimspector_enable_mappings = "HUMAN"
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
    config = function()
      require("plugins/neoformat")
    end,
  },
  "dart-lang/dart-vim-plugin",
  {
    "aeke/vim-phpfmt",
    enabled = false,
    config = function()
      Cmd([[
        let g:phpfmt_psr2 = 1
        " let g:phpfmt_enable_auto_align = 1
        let g:phpfmt_on_save = 0
        nmap <leader>pc1 :w<CR>:call PhpFmtFixFile()<CR>
        ]])
    end,
  },

  -- Generate random paragraph/country/word/nonsense
  {
    "tkhren/vim-fake",
    config = function()
      Cmd([[
      "" Get a nonsense text like Lorem ipsum
      call fake#define('sentence', 'fake#capitalize('
      \ . 'join(map(range(fake#int(3,15)),"fake#gen(\"nonsense\")"))'
      \ . ' . fake#chars(1,"..............!?"))')

      call fake#define('paragraph', 'join(map(range(fake#int(3,10)),"fake#gen(\"sentence\")"))')

      "" Alias
      call fake#define('p', 'fake#gen("paragraph")')
      call fake#define('lorem', 'fake#gen("paragraph")')
      ]])
    end,
  },

  {
    "emmanueltouzery/elixir-extras.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      Cmd([[
        nnoremap <Leader>EE :lua require('elixir-extras').elixir_view_docs({include_mix_libs=true})<cr>
      ]])

      -- require('elixir-extras').setup_multiple_clause_gutter()
    end
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  }

  -- Use <ctrl-h> <ctrl-j> <ctrl-k> <ctrl-l> <ctrl-\> to switch between vim
  -- and tmux splits
  -- use {"christoomey/vim-tmux-navigator"}
  -- An ASCII math generator from LaTeX equations.
  -- use {"jbyuki/nabla.nvim"}
}

local lazy_opts = {}
require("lazy").setup(plugins, lazy_opts)
