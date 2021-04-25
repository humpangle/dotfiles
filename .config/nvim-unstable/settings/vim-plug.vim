" auto-install vim-plug
let s:my_vim_plug_dir = $HOME . '/.local/nvim-unstable/nvim/site/autoload'
let s:my_vim_plug_install_path = s:my_vim_plug_dir . '/plug.vim'
let s:my_vim_plug_plugins_path = s:my_vim_plug_dir . '/plugged'

if empty(glob(s:my_vim_plug_install_path))
  silent !curl -fLo ~/.local/nvim-unstable/nvim/site/autoload/plug.vim  --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:my_vim_plug_plugins_path)
  " FUZZY FINDER
  " Fuzzy finder 1
  "  Fzf does not automatically update project wide tags
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " Manage branches and tags with fzf
  Plug 'stsewd/fzf-checkout.vim'
  " Fuzzy finder 2
  Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
  " View and search LSP symbols, tags in Vim/NeoVim.
  Plug 'liuchengxu/vista.vim'

  " SNIPPET ENGINES
  Plug 'SirVer/ultisnips'

  " LANGUAGE SERVERS / SYNTAX CHECKING
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/jsonc.vim'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

if !empty(glob(s:my_vim_plug_install_path))
  so ~/.config/nvim/settings/plugins/coc.vim
  so ~/.config/nvim/settings/plugins/fzf.vim
  so ~/.config/nvim/settings/plugins/fzf-checkout.vim
endif
