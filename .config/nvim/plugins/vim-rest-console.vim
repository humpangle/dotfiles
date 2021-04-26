let g:vrc_elasticsearch_support = 1 " bulk upload and external data file
let g:vrc_trigger = '<C-n>' " n = new request/ trigger is <C-J> by default

" make new rest
nnoremap ,nr :tabe .rest<Left><Left><Left><Left><Left>
" map rest rest
nnoremap ,mr :let b:vrc_output_buffer_name = '__-Rest__'<Left><Left><Left><Left><Left><Left><Left><Left>
