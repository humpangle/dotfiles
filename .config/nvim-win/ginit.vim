source $VIMRUNTIME/mswin.vim
GuiFont! Cascadia\ Mono:h12
call GuiWindowMaximized(1)

let s:ismaximised = 0
function! MaximizeToggle()
  let s:ismaximised = !s:ismaximised
  call GuiWindowFullScreen(s:ismaximised)
endfunction

nnoremap <F11> :call MaximizeToggle()<CR>
let g:can_use_coc = 1
let $FZF_DEFAULT_OPTS="--layout=reverse --border"


" Use neovim terminal UI for tabs instead of Qt. This is to allow
" lightline work properly for tab titles.
:GuiTabline 0

" Change title to include directory of file
set title
augroup dirchange
  autocmd!
  autocmd DirChanged * let &titlestring=v:event['cwd']
augroup END

"""""""""""""""""""""""""""""""""""""
" START THEME
"""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme one
"""""""""""""""""""""""""""""""""""""
" END THEME
"""""""""""""""""""""""""""""""""""""

let g:python3_host_prog = '~\.pyenv\pyenv-win\versions\3.9.6\python.exe\'

" https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
" Always show in tree view
let g:netrw_liststyle = 3

" Open file by default in new tab
" let g:netrw_browse_split = 3
let g:netrw_list_hide= '.*\.swp$,.*\.pyc'

" Keep the current directory and the browsing directory synced. This helps you
" avoid the move files error. --- I think without this setting, if you try to
" move file from one directory to another, vim will error. This setting
" prevents this error - setting always changing pwd, which breaks some plugins
" let g:netrw_keepdir = 0

" let g:netrw_winsize = 30
let g:netrw_banner = 0
" Change the copy command. Mostly to enable recursive copy of directories.
let g:netrw_localcopydircmd = 'cp -r'

" Highlight marked files in the same way search matches are. - seems to make
" no difference.
" hi! link netrwMarkFile Search

let g:markdown_fenced_languages = [
  \ 'html',
  \ 'python',
  \ 'bash=sh',
  \ 'lua',
  \ 'vim',
  \ 'help',
  \ 'javascript',
  \ 'typescript',
  \ 'css',
  \ 'dart',
\]

syntax enable
" turn on detection for ftplugin/<filetype.vim>,indent/<filetype>.vim
filetype plugin on

" Spell check
set spelllang=en
" set spell
" ~/.config/nvim/spell/en.utf-8.add
" set spellfile=~/.config/nvim/spell/en.utf-8.add

set foldmethod=indent
set foldnestmax=10
" don't fold by default when opening a file.
set nofoldenable
set foldlevel=2

" autocompletion
set complete+=kspell
set completeopt-=preview
set completeopt+=menuone,longest,noselect

" reload a file if it is changed from outside vim
set autoread
set noswapfile

" LINE NUMBERING
set number " always show line numbers
" set relative numbering as default
set relativenumber

augroup MyGvimMiscGroup
  au!
  au FocusGained * checktime

  " Trim whitespace
  au BufWritePre * %s/\s\+$//e
  au BufWritePre * %s/\n\+\%$//e
  au BufWritePre *.[ch] *.[ch] %s/\%$/\r/e
  " autocmd FileType help wincmd H
augroup END

augroup filetypes
  au!
  " autocmd! FileType json set filetype=jsonc
  autocmd! FileType vifm set filetype=vim
  " autocmd! FileType mysql set filetype=sql
  au BufNewFile,BufRead *.html.django set filetype=htmldjango
  au BufNewFile,BufRead *.eslintrc set filetype=json
  au BufNewFile,BufRead *.code-snippets set filetype=json
  au BufNewFile,BufRead *.code-workspace set filetype=json
  au BufNewFile,BufRead .babelrc set filetype=json
  " au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set filetype=jinja
  au BufNewFile,BufRead .env* set filetype=sh
  au BufNewFile,BufRead *.psql set filetype=sql
  au BufNewFile,BufRead Dockerfile* set filetype=dockerfile
  au BufNewFile,BufRead *config set filetype=gitconfig
augroup END

augroup terminal_settings
  autocmd!

  " start terminal in insert mode
  autocmd TermOpen * startinsert
augroup END

so ~\AppData\Local\nvim\plugins\lightline.vim
so ~\AppData\Local\nvim\plugins\functions.vim
so ~\AppData\Local\nvim\key-maps.vim
so ~\AppData\Local\nvim\plugins\fugitive.vim
so ~\AppData\Local\nvim\plugins\fzf.vim
so ~\AppData\Local\nvim\plugins\neoformat.vim
so ~\AppData\Local\nvim\plugins\coc.vim
so ~\AppData\Local\nvim\plugins\vcoolor.vim
" so ~\AppData\Local\nvim\plugins\vimspector.vim
so ~\AppData\Local\nvim\plugins\floaterm.vim
