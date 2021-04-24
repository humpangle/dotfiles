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
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction
