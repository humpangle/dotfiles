" https://stackoverflow.com/a/2170224
call matchup#util#append_match_words('<:>')

call matchup#util#append_match_words(
      \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>')


call matchup#util#append_match_words(
      \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,')

call matchup#util#append_match_words(
      \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>')
