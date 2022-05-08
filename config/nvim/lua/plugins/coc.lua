local set = vim.opt
local Vimg = vim.g
local keymap = vim.api.nvim_set_keymap

-- 'coc-flutter-tools',
-- 'coc-yank',
-- 'coc-vetur',
-- 'coc-php-cs-fixer',
-- 'coc-emoji',
-- 'coc-lists',
-- 'coc-tasks',
-- 'coc-fzf-preview',
-- 'coc-marketplace',
-- 'coc-explorer',
-- 'coc-emmet',
-- "https://github.com/rodrigore/coc-tailwind-intellisense",
-- "coc-docker",
--
local coc_extensions = {
  "coc-pyright",
  "coc-elixir",
  "coc-spell-checker",
  "coc-cspell-dicts",
  "coc-json",
  "coc-jedi",
  "coc-emmet",
  "coc-tsserver",
  "coc-snippets",
  "coc-css",
  "coc-html",
  "coc-eslint",
  "coc-pairs",
  "coc-prettier",
  "coc-svelte",
  "https://github.com/humpangle/coc-docker",
  "coc-svg",
  "coc-vimlsp",
  "coc-lua",
  "@yaegassy/coc-intelephense",
  "@yaegassy/coc-volar",
  "coc-blade",
  "coc-flutter",
  -- Database auto completion powered by vim-dadbod
  "coc-db",
}

if vim.fn.has("win32") == 1 then
  table.insert(coc_extensions, "coc-powershell")
else
  table.insert(coc_extensions, "coc-sh")
end

Vimg.coc_global_extensions = coc_extensions

-- COC VOLAR
-- yarn add --dev vue-tsc / npm i -g vue-tsc

-- :CocCommand eslint.showOutputChannel

-- Vimg.coc_force_debug = 1
Vimg.coc_filetype_map = {
  htmldjango = "html",
  [".eslintrc"] = "json",
  jinja = "html",
  eelixir = "html",
}

-- Some servers have issues with backup files, see #649
set.backup = false
set.writebackup = false
-- Give more space for displaying messages.
set.cmdheight = 2
-- don't give |ins-completion-menu| messages.
set.shortmess:append("c")
-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
set.signcolumn = "auto"

-- Use tab and shift tab to move to next/previous placeholders in snippets

keymap("i", "<tab>", "<Plug>(coc-snippets-expand)", {noremap = false})

Vimg.coc_snippet_next = "<TAB>"
Vimg.coc_snippet_prev = "<S-TAB>"

keymap("n", "<leader>fc", ":Format<CR>", {noremap = true})

vim.cmd([[
" hack to make vim think this is a script
let s:some = 1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter
" <cr> may have been remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in
" location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
" Show all diagnostics: COC errors in CoCList
nnoremap <C-N> :<c-u>CocList diagnostics<cr>
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap to rename current symbol
nmap <leader>rn <Plug>(coc-rename)
" Show `code action` window for currently selected region. Following actions
" are availbale: 1. Extract Function 2. Move to a new file 3. Extract constant
" 4. spelling suggestion
nmap ,ac  <Plug>(coc-codeaction)
xmap ,ac  <Plug>(coc-codeaction-selected)
" Apply AutoFix to problem on the current line.
nmap ,qf  <Plug>(coc-fix-current)
" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use `:Format` to format current buffer using LSP
command! -nargs=0 Format :call CocAction('format')
xmap <leader>fc :Format<CR>

" Use ``:Prettier` to format current buffer.
" If there is a formatter registered with the LSP, prettier has lower
" priority and thus using `:Format` will not invoke prettier. Use the mapping
" below to explicitly invoke prettier.
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <leader>fp :Prettier<CR>

" Sort import
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
nmap ,o :OR<CR>

nnoremap <silent> <leader>rs :<C-u>CocRestart<cr><cr>
nmap <Leader>ch :CocSearch <Right>

" Mappings for CoCList
" Manage extensions.
nnoremap <C-X>  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>bt  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>pt  :<C-u>CocList -I symbols<cr>

" nmap <leader>ee :CocCommand explorer<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup coc_grp_1
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,vue setl formatexpr=CocAction('formatSelected')

  " Format vue with prettier on write
  " autocmd BufWritePre *.vue Prettier

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" automatically close coc-explorer if it's the last buffer
" autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
]])
