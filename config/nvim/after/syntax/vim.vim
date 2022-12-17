" https://stackoverflow.com/a/24091111
syn match vimMapRhs '.*\ze|\s*".*'
syn match vimLineComment '|\s*".*$'
syn match vimMapRhs '.*\ze<bar>\s*".*'
syn match vimLineComment '<bar>\s*".*$'
