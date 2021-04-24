let g:lightline = {}

let g:lightline.component_function = {
  \'fugitive': 'LightlineFugitive',
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
    \]
  \],
\}

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction
