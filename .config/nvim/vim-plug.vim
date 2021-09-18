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
" Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
" execute remove(g:plugs, 'yaegassy/coc-volar')

" FUZZY FINDER
" sudo apt install bat # Syntax highlighting
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

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
" Align Markdown table
Plug 'godlygeek/tabular'

" Statusline
Plug 'itchyny/lightline.vim'

" Terminal
Plug 'voldikss/vim-floaterm'

" let g:undotree_WindowLayout = 2
" let  g:undotree_ShortIndicators = 1
" Plug 'mbbill/undotree'

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

" Plug 'windwp/nvim-autopairs'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nelstrom/vim-visual-star-search'

Plug 'easymotion/vim-easymotion'

" Quickly toggle maximaize a tab
let g:maximizer_set_default_mapping = 0
Plug 'szw/vim-maximizer'

" displaying the colours in the file (#rrggbb, #rgb, rgb(a)
" requires golang (asdf plugin-add golang && asdf install golang <version>)
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" color picker
Plug 'KabbAmine/vCoolor.vim'

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

" THEMES
Plug 'rakr/vim-one'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'

" FORMATTER
" Works for many files as far as binary to format file exists
Plug 'sbdchd/neoformat'

let g:phpfmt_psr2 = 1
" let g:phpfmt_enable_auto_align = 1
Plug 'aeke/vim-phpfmt'

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
" Plug 't9md/vim-choosewin'

" An ASCII math generator from LaTeX equations.
" Plug 'jbyuki/nabla.nvim'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
