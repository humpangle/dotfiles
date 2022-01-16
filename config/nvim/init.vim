" https://github.com/dag/vim-fish#teach-a-vim-to-fish
set shell=/bin/bash

" szw/vim-maximizer
let g:maximizer_set_default_mapping = 0

" editorconfig/editorconfig-vim
let g:EditorConfig_exclude_patterns = ["fugitive://.*"]

lua require('plugins/plugins')

so ~/.config/nvim/plugins/functions.vim
so ~/.config/nvim/settings.vim
so ~/.config/nvim/plugins/lightline.vim
so ~/.config/nvim/key-maps.vim
so ~/.config/nvim/plugins/fugitive.vim
so ~/.config/nvim/plugins/fzf.vim
so ~/.config/nvim/plugins/floaterm.vim
so ~/.config/nvim/plugins/vcoolor.vim
so ~/.config/nvim/plugins/vimspector.vim
so ~/.config/nvim/plugins/markdown-preview.vim
so ~/.config/nvim/plugins/dadbod-ui.vim
so ~/.config/nvim/plugins/easymotion.vim
so ~/.config/nvim/plugins/maximizer.vim
so ~/.config/nvim/plugins/vim-phpfmt.vim
so ~/.config/nvim/plugins/vim-rest-console.vim
so ~/.config/nvim/plugins/vim-choosewin.vim
so ~/.config/nvim/plugins/vim-slime.vim

" THEME SELECTION
if !empty($EBNIS_VIM_THEME)
  so ~/.config/nvim/plugins/$EBNIS_VIM_THEME.vim
  if $EBNIS_VIM_THEME_BG == 'd'
    set background=dark
  else
    set background=light
  endif
else
  colorscheme one
  set background=dark
endif

lua <<EOF
  -- vim.lsp.set_log_level('debug') -- info/debug/error/trace
  -- Open log file with:
  -- :lua vim.cmd('e'..vim.lsp.get_log_path())
EOF