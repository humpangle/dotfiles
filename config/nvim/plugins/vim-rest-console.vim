" bulk upload and external data file
let g:vrc_elasticsearch_support = 1
" n = new request/ trigger is <C-J> by default
let g:vrc_trigger = '<C-n>'

" make new rest console buffer
nnoremap ,nr :tabe .rest<Left><Left><Left><Left><Left>
" map rest rest
nnoremap ,mr :let b:vrc_output_buffer_name = '__-Rest__'<Left><Left><Left><Left><Left><Left><Left><Left>
