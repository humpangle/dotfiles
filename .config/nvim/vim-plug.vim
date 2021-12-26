" auto-install vim-plug
let s:plugins_path = "$HOME/.local/share/nvim/site/autoload"
let s:plug_install_path = s:plugins_path . '/plug.vim'
let s:plugins_path = s:plugins_path . '/plug'

if empty(glob(s:plug_install_path))
   silent execute '!curl -fLo ' . s:plug_install_path . ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(s:plugins_path)
" LANGUAGE SERVERS / SYNTAX CHECKING
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/jsonc.vim'

" FUZZY FINDER
" sudo apt install bat # Syntax highlighting
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'chengzeyi/fzf-preview.vim'
Plug 'voldikss/fzf-floaterm'

" Tag generation - browse tags with FZF - keymap: `,bt` / `,pt`
" ludovicchabant/vim-gutentags
" https://github.com/kuator/nvim/blob/master/lua/plugins/vim-gutentags.lua
" let g:gutentags_add_default_project_roots = 0
" let g:gutentags_project_root = ['.git', 'package.json']
" Plug 'ludovicchabant/vim-gutentags'

" GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" MARKDOWN
let g:mkdp_refresh_slow = 1
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" Another markdown preview
" let g:glow_binary_path = '~\scoop\apps\glow\current'
" Plug 'ellisonleao/glow.nvim'
" Align Markdown table
Plug 'godlygeek/tabular'

" Statusline
Plug 'itchyny/lightline.vim'

" Terminal
Plug 'voldikss/vim-floaterm'

" Better undo diff
Plug 'simnalamburt/vim-mundo'

" These 2 don't work well for php
" Plug 'tpope/vim-commentary'
" Plug 'b3nj5m1n/kommentary'

" To make new comment types, SEE `autoload/tcomment/types/mytypes.vim`
Plug 'tomtom/tcomment_vim'

" Surround text with quotes, parenthesis, brackets, and more.
Plug 'tpope/vim-surround'

" A number of useful motions for the quickfix list, pasting and more.
Plug 'tpope/vim-unimpaired'

" MANAGE VIM SESSIONS AUTOMACTICALLY
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'

" A high-performance color highlighter for Neovim - not as good
" as vim-hexokinase
" Plug 'norcalli/nvim-colorizer.lua'

" Another color highlighter - superior
" requires golang (asdf plugin-add golang && asdf install golang <version>)
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" color picker
Plug 'KabbAmine/vCoolor.vim'

Plug 'nelstrom/vim-visual-star-search'
Plug 'easymotion/vim-easymotion'
" better easymotion
" Plug 'phaazon/hop.nvim'
lua <<EOF
-- require'hop'.setup()
EOF

" Quickly toggle maximaize a tab
let g:maximizer_set_default_mapping = 0
Plug 'szw/vim-maximizer'

" SYNTAX HIGHLIGHTING
Plug 'elixir-editors/vim-elixir'
Plug 'jparise/vim-graphql'
Plug 'pprovost/vim-ps1' " Powershell
Plug 'jwalton512/vim-blade' " Laravel blade

let g:EditorConfig_exclude_patterns = ['fugitive://.*']
Plug 'editorconfig/editorconfig-vim'

" let g:vue_pre_processors = ['typescript', 'scss']
let g:vue_pre_processors = 'detect_on_enter'
" Temporary fix for color highlighting issue in .vue files.
" let html_no_rendering=1
Plug 'posva/vim-vue'

" Fixes syntax highlighting for style tags in .vue files.
Plug 'othree/html5.vim'

" THEMES / COLORSCHEME
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'

" FORMATTER
" Works for many files as far as binary that can format the file exists
Plug 'sbdchd/neoformat'

" This plugin has been abandoned - but it's still the easier to use.
Plug 'aeke/vim-phpfmt'

" composer global require friendsofphp/php-cs-fixer
" Plug 'stephpy/vim-php-cs-fixer'

Plug 'dart-lang/dart-vim-plugin'

" making rest api call
Plug 'diepm/vim-rest-console'

" Database management
Plug 'tpope/vim-dadbod'
" https://alpha2phi.medium.com/vim-neovim-managing-databases-d253faf4a0cd
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

" Debugging
let g:vimspector_enable_mappings = 'HUMAN'

Plug 'puremourning/vimspector'

" Image preview
" pip install -U Pillow
Plug 'mi60dev/image.vim'

" tmux-like window navigation
Plug 't9md/vim-choosewin'

" Use <ctrl-h> <ctrl-j> <ctrl-k> <ctrl-l> <ctrl-\> to switch between vim
" and tmux splits
" Plug 'christoomey/vim-tmux-navigator'

" An ASCII math generator from LaTeX equations.
" Plug 'jbyuki/nabla.nvim'

" Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-buffer'
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-cmdline'
" Plug 'hrsh7th/nvim-cmp'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
