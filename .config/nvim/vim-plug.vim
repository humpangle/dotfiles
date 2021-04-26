" auto-install vim-plug
let s:my_vim_plug_dir = $HOME . '/.local/share/nvim/site/autoload'
let s:my_vim_plug_install_path = s:my_vim_plug_dir . '/plug.vim'
let s:my_vim_plug_plugins_path = s:my_vim_plug_dir . '/plugged'

if empty(glob(s:my_vim_plug_install_path))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim  --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin(s:my_vim_plug_plugins_path)
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
  so ~/.config/nvim/plugins/coc.vim
endif
