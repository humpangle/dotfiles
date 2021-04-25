--[[
Install binaries for formatting

javascript, typescript, svelte, graphql, Vue, html, YAML, SCSS, Less, JSON,
npm install -g prettier prettier-plugin-svelte

shell
wget -O $HOME/.local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.2.4/shfmt_v3.2.4_linux_amd64 && chmod ugo+x $HOME/.local/bin/shfmt

sql
wget -O pgFormatter-5.0.tar.gz https://github.com/darold/pgFormatter/archive/refs/tags/v5.0.tar.gz && tar xzf pgFormatter-5.0.tar.gz && cd pgFormatter-5.0/ && perl Makefile.PL && make && sudo make install && pg_format --version

--]] --
--
-- SETTINGS
-- Shell
Vimg.shfmt_opt = "-ci"

local u = require("utils.core")

u.map("n", "<leader>fc", ":Neoformat<CR>")

-- format on save
Cmd([[
  augroup fmt
    autocmd!
      " if file not changed and saved (e.g. to trigger test run), error is thrown: use try/catch to suppress
      au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
  augroup END
]])
