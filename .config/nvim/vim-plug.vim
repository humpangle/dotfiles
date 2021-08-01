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
  Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
  " execute remove(g:plugs, 'yaegassy/coc-volar')

  " FUZZY FINDER
  " sudo apt install bat # Syntax highlighting
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'

  " Tag generation - browse tags with FZF - keymap: `,bt` / `,pt`
  Plug 'ludovicchabant/vim-gutentags'

  " GIT
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  " MARKDOWN
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  " Align Markdown table
  Plug 'godlygeek/tabular'

  " Statusline
  Plug 'itchyny/lightline.vim'

  " Terminal
  Plug 'voldikss/vim-floaterm'

  Plug 'mbbill/undotree'
  Plug 'tpope/vim-commentary'

  " Surround text with quotes, parenthesis, brackets, and more.
  Plug 'tpope/vim-surround'

  " A number of useful motions for the quickfix list, pasting and more.
  Plug 'tpope/vim-unimpaired'

  " MANAGE VIM SESSIONS AUTOMACTICALLY
  Plug 'tpope/vim-obsession'
  Plug 'dhruvasagar/vim-prosession'

  Plug 'windwp/nvim-autopairs'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'nelstrom/vim-visual-star-search'

  Plug 'easymotion/vim-easymotion'

  " Quickly toggle maximaize a tab
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
  Plug 'editorconfig/editorconfig-vim'
  Plug 'posva/vim-vue'

  " THEMES
  Plug 'rakr/vim-one'
  Plug 'lifepillar/vim-gruvbox8'
  Plug 'lifepillar/vim-solarized8'

  " FORMATTER
  Plug 'sbdchd/neoformat'
  Plug 'aeke/vim-phpfmt'

  " Plug 'vim-scripts/AutoComplPop'
  Plug 'dart-lang/dart-vim-plugin'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
