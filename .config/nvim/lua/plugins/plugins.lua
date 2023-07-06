-- Set up global variables
-- redefine the vim global as capitalized to make editor happy
Vim = vim
-- ditto
Cmd = Vim.cmd
Vimg = Vim.g
Vimo = Vim.o
Vimw = Vim.wo
Vimf = Vim.fn

-- Automatically install packer

PACKER_BOOTSTRAP = false

local install_path = Vimf.stdpath("data") ..
                       "/site/pack/packer/start/packer.nvim"
if Vimf.empty(Vimf.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = Vimf.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })

  print("Installing packer...... ")
  -- Only required if you have packer configured as `opt`
  Cmd([[packadd packer.nvim]])
  print("Done installing packer...... close and reopen Neovim....")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- Cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init({
  -- opt_default = true, -- Lazy load plugins
  opt_default = false, -- Lazy load plugins
  display = {
    -- Have packer use a popup window
    open_fn = function()
      return require("packer.util").float({border = "rounded"})
    end,

    prompt_border = "double", -- Border style of prompt popups
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- Have packer manage itself, eager load
  use({"wbthomason/packer.nvim", opt = false})

  -- Useful lua functions used by lots of plugins
  use({"nvim-lua/plenary.nvim"})

  -- THEMES / COLORSCHEME
  use({"rakr/vim-one", "lifepillar/vim-gruvbox8", "lifepillar/vim-solarized8"})

  -- LANGUAGE SERVERS / SYNTAX CHECKING
  use({
    "neoclide/coc.nvim",
    branch = "release",
    disable = false,
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

    requires = {
      {"neoclide/jsonc.vim"},

      -- Laravel blade
      {
        "jwalton512/vim-blade",
        -- disable = false,
      },

      {
        "kristijanhusak/vim-dadbod-completion",
        -- disable = true, -- favor sqls
      },

      -- Laravel
      {
        "noahfrederick/vim-laravel",
        disable = false,
        requires = {
          "noahfrederick/vim-composer",
          "tpope/vim-projectionist",
          "tpope/vim-dispatch",
        },
      },
    },
  })

  -- NATIVE NEOVIM LSP / COMPLETION ENGINE
  use({
    "hrsh7th/nvim-cmp",
    disable = true,
    config = function()
      require("plugins/nvim-cmp")
    end,

    requires = {
      -- COMPLETION SOURCES

      -- snippet completions
      "saadparwaiz1/cmp_luasnip",

      -- "hrsh7th/vim-vsnip", -- snippet completions

      -- buffer completions
      "hrsh7th/cmp-buffer",

      -- path completions
      "hrsh7th/cmp-path",

      -- cmdline completions
      "hrsh7th/cmp-cmdline",

      -- lsp completions
      "hrsh7th/cmp-nvim-lsp",

      -- source for neovim Lua API.
      "hrsh7th/cmp-nvim-lua",

      -- uses `look` command line tool for dictionary word
      "octaltree/cmp-look",

      -- / COMPLETION SOURCES

      -- snippet engine
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = {"~/.config/nvim/snippets"},
          })
        end,
      },

      -- a bunch of snippets to use
      {"rafamadriz/friendly-snippets", disable = true},

      -- {
      --   "windwp/nvim-autopairs",
      --   config = function()
      --     return require("plugins/nvim-autopairs")
      --   end,
      -- },

      -- LSP
      {
        "neovim/nvim-lspconfig",
        config = function()
          require("lsp")
        end,
      },

      -- simple to use language server installer
      {
        "williamboman/nvim-lsp-installer",
        config = function()
          Cmd([[
            nnoremap <C-X> :LspInstallInfo<cr>
          ]])
        end,
      },

      -- Code actions, diagnostics = linters, formatters, hover,  completion
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require("plugins/null-ls")
        end,
      },

      -- LSP PHP

      {
        "phpactor/phpactor",
        disable = true,
        branch = "master",
        ft = "php",
        run = "composer install --no-dev -o && ./vendor/bin/phpactor extension:install \"phpactor/language-server-phpstan-extension\"",
      },

      -- Treesitter
      {
        "nvim-treesitter/nvim-treesitter",
        disable = true,
        run = ":TSUpdate",
        config = function()
          require("plugins/treesitter")
        end,

        requires = {
          {
            "JoosepAlviste/nvim-ts-context-commentstring",
            config = function()
              require("nvim-treesitter.configs").setup({
                context_commentstring = {
                  enable = true,
                  enable_autocmd = false,
                  config = {css = "// %s"},
                },
              })
            end,
          },

          {
            "terrortylor/nvim-comment",
            config = function()
              Cmd([[
                augroup set-commentstring-ag
                  autocmd!

                  " when you enter a (new) buffer
                  autocmd BufEnter *.sql :lua vim.api.nvim_buf_set_option(0, "commentstring", "-- %s")

                  " when you've changed the name of a file opened in a buffer, the file type may have changed
                  autocmd BufFilePost *.sql :lua vim.api.nvim_buf_set_option(0, "commentstring", "-- %s")
                augroup END
              ]])

              require("nvim_comment").setup({
                -- Ignore Empty Lines
                comment_empty = false,
                hook = function()
                  require("ts_context_commentstring.internal").update_commentstring()
                end,
              })
            end,
          },
        },
      },

      {"jose-elias-alvarez/nvim-lsp-ts-utils"},

      {
        -- Neovim plugin for sqls that leverages the built-in LSP client
        "nanotee/sqls.nvim",
        config = function()
          Cmd([[
                nnoremap <Leader>qs :SqlsExecuteQuery<cr>
                xnoremap <Leader>qs :SqlsExecuteQuery<cr>
                nnoremap <Leader>qv :SqlsExecuteQueryVertical<cr>
                xnoremap <Leader>qv :SqlsExecuteQueryVertical<cr>
            ]])
        end,
      },

      {
        "kamykn/spelunker.vim",
        disable = true,
        config = function()
          Vimg.enable_spelunker_vim_on_readonly = 1
        end,

        requires = {"kamykn/popup-menu.nvim"},
      },
    },
  })

  -- FUZZY FINDER
  -- sudo apt install bat -- Syntax highlighting
  use({
    "junegunn/fzf",
    "junegunn/fzf.vim",
    "stsewd/fzf-checkout.vim",
    -- "chengzeyi/fzf-preview.vim", -- requires COC
  })

  -- GIT
  use({"airblade/vim-gitgutter"})
  use({
    "tpope/vim-fugitive",
    requires = {
      -- Enable fugitive :GBrowse to open git objects on github
      "tpope/vim-rhubarb",
    },
  })

  -- Statusline
  use({"itchyny/lightline.vim"})

  -- Terminal
  use({
    "voldikss/vim-floaterm",
    config = function()
      require("plugins/floaterm")
    end,
    requires = {"voldikss/fzf-floaterm"},
  })

  -- Better undo diff
  use({
    "simnalamburt/vim-mundo",
    -- disable = true,
    config = function()
      Cmd([[
        " mbbill/undotree
        " nnoremap <A-u> :UndotreeToggle<CR>
        " simnalamburt/vim-mundo
        nnoremap <A-u> :MundoToggle<CR>
      ]])
    end,
  })

  use({"tomtom/tcomment_vim"})

  -- Surround text with quotes, parenthesis, brackets, and more.
  use({"tpope/vim-surround"})

  -- A number of useful motions for the quickfix list, pasting and more.
  use({"tpope/vim-unimpaired"})

  -- MANAGE VIM SESSIONS AUTOMACTICALLY
  use({"tpope/vim-obsession", "dhruvasagar/vim-prosession"})

  -- Color highlighter - superior
  -- requires golang (asdf plugin-add golang && asdf install golang <version>)
  use({
    "rrethy/vim-hexokinase",
    run = "cd ~/.local/share/nvim/site/pack/packer/start/vim-hexokinase && make hexokinase",
  })

  -- color picker
  use({
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
  })

  use({"nelstrom/vim-visual-star-search"})

  -- use({"easymotion/vim-easymotion"})

  -- Easy motion alternative
  use({
    "ggandor/leap.nvim",
    config = function()
      -- https://github.com/kohane27/nvim-config/blob/main/lua/plugins/leap.lua
      local status_ok, leap = pcall(require, "leap")
      if status_ok then
        leap.set_default_keymaps(true)

        -- mark cursor location before jumping
        vim.api.nvim_create_autocmd("User", {
          pattern = "LeapEnter",
          callback = function()
            vim.cmd("normal m'")
          end,
        })
      end
    end,
  })

  -- SYNTAX HIGHLIGHTING
  use({
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
  })

  -- making rest api call
  use({
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
        nnoremap ,mr :let b:vrc_output_buffer_name = '-Rest'<Left><Left><Left><Left><left><left>
     ]])
    end,
  })

  -- Database management
  use({
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
  })

  -- Image preview
  -- pip install -U Pillow
  use({"mi60dev/image.vim"})

  -- tmux-like window navigation
  use({
    use {
      "s1n7ax/nvim-window-picker",
      tag = "v1.*",
      config = function()
        require"window-picker".setup({
          include_current_win = true,
          show_prompt = false,
          filter_rules = {bo = {buftype = {}}},
        })

        local picker = require("window-picker")

        vim.keymap.set("n", "<leader>-", function()
          local picked_window_id = picker.pick_window() or
                                     vim.api.nvim_get_current_win()
          vim.api.nvim_set_current_win(picked_window_id)
        end, {desc = "Pick a window"})
      end,
    },
    {
      "t9md/vim-choosewin",
      disable = true,
      config = function()
        Cmd([[
      " if you want to use overlay feature
      let g:choosewin_overlay_enable = 1
      " invoke with '-'
      nmap <Leader>- <Plug>(choosewin)
      ]])
      end,
    },
  })

  -- Send text from vim to tmux/NeoVim :terminal etc
  use({
    "jpalardy/vim-slime",
    config = function()
      require("plugins/vim-slime")
      -- ctrl-c ctrl-c
      -- ctrl-c v
    end,
  })

  -- MARKDOWN
  use({
    "iamcco/markdown-preview.nvim",
    opt = true,
    run = "cd app && yarn install",
    ft = {"markdown"},
    config = function()
      Vimg.mkdp_refresh_slow = 1
      Cmd([[
        nnoremap <leader>mt :MarkdownPreviewToggle<CR>
        let g:mkdp_open_to_the_world = 1
      ]])
    end,
  })

  -- Another markdown preview
  use({
    "ellisonleao/glow.nvim",
    opt = true,
    disable = true,
    setup = function()
      -- Vimg.glow_binary_path = "~\\scoop\\apps\\glow\\current"
    end,
  })

  -- Align Markdown table
  use({"godlygeek/tabular"})

  -- Tag generation - browse tags with FZF - keymap: `,bt` / `,pt`
  use({
    "ludovicchabant/vim-gutentags",
    opt = false,
    disable = true,
    -- disable = false,
    setup = function()
      Vimg.gutentags_add_default_project_roots = 0
      Vimg.gutentags_project_root = {".git", "package.json"}
      Vimg.gutentags_trace = 0
    end,
  })

  -- Quickly toggle maximaize a tab
  use({"szw/vim-maximizer"})

  use({"editorconfig/editorconfig-vim"})

  -- Debugging
  use({
    "puremourning/vimspector",
    disable = true,
    setup = function()
      Vimg.vimspector_enable_mappings = "HUMAN"
    end,
  })

  -- Enhances vim ga with Unicode character names, Vim digraphs, emoji codes
  -- Pressing ga on a character reveals its representation in
  -- decimal,
  -- octal,
  -- hex
  -- Unicode character names
  use({"tpope/vim-characterize"})

  -- FORMATTERS
  use({
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
      disable = true,
      config = function()
        Cmd([[
            let g:phpfmt_psr2 = 1
            " let g:phpfmt_enable_auto_align = 1
            let g:phpfmt_on_save = 0
            nmap <leader>pc1 :w<CR>:call PhpFmtFixFile()<CR>
        ]])
      end,
    },
  })

  -- Generate random paragraph/country/word/nonsense
  use({
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
  })

  -- Use <ctrl-h> <ctrl-j> <ctrl-k> <ctrl-l> <ctrl-\> to switch between vim
  -- and tmux splits
  -- use {"christoomey/vim-tmux-navigator"}
  -- An ASCII math generator from LaTeX equations.
  -- use {"jbyuki/nabla.nvim"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
