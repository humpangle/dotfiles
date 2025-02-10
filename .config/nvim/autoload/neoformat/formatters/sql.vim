" https://github.com/sql-formatter-org/sql-formatter

function! neoformat#formatters#sql#enabled() abort
    return ['sqlformatter', 'pg_format', 'sqlfmt', 'sleek']
endfunction

function! neoformat#formatters#sql#sqlformatter() abort
    return {
        \ 'exe': 'sql-formatter',
        \ 'args': [],
        \ 'stdin': 1,
        \ }
endfunction
