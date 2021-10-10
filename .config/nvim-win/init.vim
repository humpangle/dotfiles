if has('win32')
  language en_US
  set fileformat=unix
  let s:plugins_path = '~\AppData\Local\nvim\autoload'
else
  " unset default paths of regular nvim in unix
  set runtimepath-=~/.config/nvim
  set runtimepath-=~/.config/nvim/after
  set runtimepath-=~/.local/share/nvim/site
  set runtimepath-=~/.local/share/nvim/site/after

  " set custom paths for use in vscode nvim
  set runtimepath+=~/.config/nvim-win/after
  set runtimepath^=~/.config/nvim-win
  set runtimepath+=~/.local/share/nvim-win/site/after
  set runtimepath^=~/.local/share/nvim-win/site

  let &packpath = &runtimepath

  let $MYVIMRC = "$HOME/.config/nvim-win/init.vim"

  let s:plugins_path = "$HOME/.local/share/nvim-win/site/autoload"
  let s:plug_install_path = s:plugins_path . '/plug.vim'
  let s:plugins_path = s:plugins_path . '/plug'

  if !filereadable(s:plug_install_path)
     silent execute '!curl -fLo ' . s:plug_install_path . ' --create-dir https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif
endif

if has('win32')
  so ~\AppData\Local\nvim\settings.vim
  so ~\AppData\Local\nvim\key-maps-common.vim
else
  so ~/.config/nvim-win/settings.vim
  so ~/.config/nvim-win/key-maps-common.vim
endif

augroup MyMiscGroup
  " highlight yank
  " :h lua-highlight
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

call plug#begin(s:plugins_path)
" Surround text with quotes, parenthesis, brackets, and more.
Plug 'tpope/vim-surround'
Plug 'nelstrom/vim-visual-star-search'

" We only use these plugins in neovim-qt on windows - hence check for win32
if !exists('g:vscode') && has('win32')
  " LANGUAGE SERVERS / SYNTAX CHECKING
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/jsonc.vim'

  " FUZZY FINDER
  " sudo apt install bat # Syntax highlighting
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'
  Plug 'chengzeyi/fzf-preview.vim'

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

  " Better undo diff
  Plug 'simnalamburt/vim-mundo'

  " These 2 don't work well for php
  " Plug 'tpope/vim-commentary'
  " Plug 'b3nj5m1n/kommentary'

  " To make new comment types, SEE `autoload/tcomment/types/mytypes.vim`
  Plug 'tomtom/tcomment_vim'

  " A number of useful motions for the quickfix list, pasting and more.
  Plug 'tpope/vim-unimpaired'

  " MANAGE VIM SESSIONS AUTOMACTICALLY
  Plug 'tpope/vim-obsession'
  Plug 'dhruvasagar/vim-prosession'

  " A high-performance color highlighter for Neovim
  Plug 'norcalli/nvim-colorizer.lua'
  " Another color highlighter
  " requires golang (asdf plugin-add golang && asdf install golang <version>)
  " Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

  " color picker
  Plug 'KabbAmine/vCoolor.vim'

  Plug 'easymotion/vim-easymotion'

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
  " Works for many files as far as binary to format file exists
  Plug 'sbdchd/neoformat'

  " let g:phpfmt_psr2 = 1
  " let g:phpfmt_enable_auto_align = 1
  " Plug 'aeke/vim-phpfmt'

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

  " VSCODE ONLY PLUGINS
else
  Plug 'asvetliakov/vim-easymotion', { 'as': 'vim-easymotion-vscode' }
endif
call plug#end()

if has('win32')
  if exists('g:vscode')
    so ~\AppData\Local\nvim\vscode.vim
  endif
else
  so ~/.config/nvim-win/vscode.vim
endif
