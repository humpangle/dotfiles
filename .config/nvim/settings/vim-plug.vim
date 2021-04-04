" auto-install vim-plug
let my_vim_plug_dir = $HOME . '/.local/share/nvim/site/autoload'
let my_vim_plug_install_path = g:my_vim_plug_dir . '/plug.vim'
let my_vim_plug_plugins_path = g:my_vim_plug_dir . '/plugged'

if empty(glob(g:my_vim_plug_install_path))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim  --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(g:my_vim_plug_plugins_path)
  " Handle multi-file find and replace.
  Plug 'mhinz/vim-grepper'
  let g:grepper={}
  let g:grepper.tools=["rg"]

  " Modify * to also work with visual selections.
  Plug 'nelstrom/vim-visual-star-search'
  " Toggle comments in various ways.
  Plug 'tpope/vim-commentary'
  " A number of useful motions for the quickfix list, pasting and more.
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-surround'
  " Connect to database use vim
  Plug 'tpope/vim-dadbod'
  Plug 'ntpeters/vim-better-whitespace'
  " Surround text with quotes, parenthesis, brackets, and more.
  Plug 'easymotion/vim-easymotion'
  Plug 'diepm/vim-rest-console'
  " interactive scratchpad  = repl
  Plug 'metakirby5/codi.vim'
  Plug 'godlygeek/tabular' " Align Markdown table
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  let g:mkdp_refresh_slow = 1

  " MANAGE VIM SESSIONS AUTOMACTICALLY
  Plug 'tpope/vim-obsession'
  Plug 'dhruvasagar/vim-prosession'

  " GIT
  " A git wrapper so awesome it should be illegal.
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'will133/vim-dirdiff'

  " FUZZY FINDER
  " Fuzzy finder 1
  " Nice to have: ludovicchabant/vim-gutentags to:
  "   generate useful tags
  "   continuosly refresh tags
  "  Fzf does not automatically update project wide tags
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " Manage branches and tags with fzf
  Plug 'stsewd/fzf-checkout.vim'
  " Fuzzy finder 2
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  " View and search LSP symbols, tags in Vim/NeoVim.
  Plug 'liuchengxu/vista.vim'

  " THEMES
  Plug 'rakr/vim-one'
  Plug 'lifepillar/vim-gruvbox8'
  Plug 'lifepillar/vim-solarized8'

  " SYNTAX HIGHLIGHTING
  Plug 'elixir-editors/vim-elixir'
  Plug 'jparise/vim-graphql'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}

  " VIM STATUS BAR / TABS / WINDOWS
  " cool status bar
  Plug 'itchyny/lightline.vim'
  " Floaterm is a floating terminal for Neovim
  Plug 'voldikss/clap-floaterm' " use clap to search floaterm
  Plug 'voldikss/vim-floaterm'

  " SNIPPET ENGINES
  Plug 'SirVer/ultisnips'

  " COMPLETION
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " LANGUAGE SERVERS / SYNTAX CHECKING
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/jsonc.vim'
  Plug 'dense-analysis/ale'

  " FORMATTERS
  " lua
  " install formatter executable:
  "   luarocks install --server=https://luarocks.org/dev luaformatter
  Plug 'andrejlevkovitch/vim-lua-format'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
