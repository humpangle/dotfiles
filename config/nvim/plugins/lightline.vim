let g:lightline = {}

let g:lightline.component_function = {
  \'fugitive': 'LightlineFugitive',
  \ 'filename': 'LightlineFilename',
\}

let g:lightline.component = {
  \'filename': '%f',
\}

let g:lightline.active = {
  \'left': [
      \[
          \'mode',
          \'paste'
      \],
      \[
          \'fugitive',
          \'readonly',
          \'filename',
          \'modified',
      \],
      \[
      \],
  \],
\}

let g:lightline.tab_component_function = {
  \ 'filename_active': 'LightlineInactiveTabFilename',
\}

let g:lightline.tab = {
  \ 'active': [
      \ 'tabnum',
      \ 'filename',
      \ 'modified'
  \],
  \ 'inactive': [
      \ 'tabnum',
      \ 'filename_active',
      \ 'modified'
  \],
\}

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction

function! LightlineFilename()
  return luaeval('require("util").get_file_name(2)')
endfunction

function! LightlineInactiveTabFilename(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = expand('#' . buflist[winnr - 1] . ':f')
  let shortened_file_path = substitute(filename, '\', '/', 'g')
  let lua_func = 'require("util").get_file_name("' . shortened_file_path . '")'
  return luaeval(lua_func)
endfunction

function! LightlineCocStatus() abort
  if winwidth(0) < 60
    return ''
  endif

  return coc#status()
endfunction
