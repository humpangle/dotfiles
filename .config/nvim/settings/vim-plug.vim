" auto-install vim-plug
if !has('win32') && empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

let my_pluging_path = has('win32') ? '~\AppData\Local\nvim\autoload\plugged' : '~/.config/nvim/autoload/plugged'

call plug#begin(g:my_pluging_path)
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
  " Better manage Vim sessions - prosession depends on obsession
  Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession'
  Plug 'tpope/vim-surround'
  " Connect to database use vim
  Plug 'tpope/vim-dadbod'
  " A git wrapper so awesome it should be illegal.
  Plug 'tpope/vim-fugitive'
  " search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " Terminal wrapper
  Plug 'kassio/neoterm'

  " themes
  Plug 'rakr/vim-one'
  Plug 'lifepillar/vim-gruvbox8'

  " typescript and other language server protocols - mimics VSCode.
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " syntax highlighting
  Plug 'ianks/vim-tsx'
  Plug 'leafgarland/typescript-vim'
  Plug 'cespare/vim-toml'
  Plug 'evanleck/vim-svelte'
  Plug 'elixir-editors/vim-elixir'

  Plug 'ntpeters/vim-better-whitespace'
  Plug 'airblade/vim-gitgutter'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'itchyny/lightline.vim' " cool status bar
  " Surround text with quotes, parenthesis, brackets, and more.
  Plug 'easymotion/vim-easymotion'
  Plug 'will133/vim-dirdiff'
  " python syntax highlighting - adds highlighting to other file types too
  Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  " modifies Vim’s indentation behavior to comply with PEP8
  Plug 'Vimjas/vim-python-pep8-indent'
  Plug 'lepture/vim-jinja'
  Plug 'diepm/vim-rest-console'
  Plug 'godlygeek/tabular' " Align Markdown table
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  let g:mkdp_refresh_slow = 1
  " Plug 'plasticboy/vim-markdown'

  Plug 'neoclide/jsonc.vim'
  " interactive scratchpad  = repl
  Plug 'metakirby5/codi.vim'

  Plug 'dense-analysis/ale'

  " Floaterm is a floating terminal for Neovim
  Plug 'voldikss/vim-floaterm'

  " Manage branches and tags with fzf
  Plug 'stsewd/fzf-checkout.vim'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
