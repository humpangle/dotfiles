-- vim.g.neoformat_verbose = 1

-- vim.api.nvim_set_keymap("n", "<leader>fc", ":Neoformat<CR>", {
-- 	noremap = true,
-- })

vim.api.nvim_set_keymap("n", "<leader>N", ":Neoformat<CR>", {
	noremap = true,
})

-- Install binaries for formatting
--
-- javascript, typescript, svelte, graphql, Vue, html, YAML, SCSS, Less, JSON,
-- npm install -g prettier prettier-plugin-svelte
--
-- shell
-- wget -O $HOME/.local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.4.0/shfmt_v3.4.0_linux_amd64 && chmod ugo+x $HOME/.local/bin/shfmt
--
-- sjl
-- wget -O pgFormatter-5.0.tar.gz \
--   https://github.com/darold/pgFormatter/archive/refs/tags/v5.0.tar.gz && \
--   tar xzf pgFormatter-5.0.tar.gz && \
--   cd pgFormatter-5.0/ && \
--   perl Makefile.PL && \
--   make && sudo make install && \
--   pg_format --version
--
-- SETTINGS
-- Shell
vim.g.shfmt_opt = "-ci"

-- jsonc
vim.g.neoformat_jsonc_prettier = {
	["exe"] = "prettier",

	["args"] = {
		"--stdin-filepath",
		'"%:p"',
		"--parser",
		"json",
	},

	["stdin"] = 1,
}

vim.g.neoformat_enabled_jsonc = {
	"prettier",
}

vim.g.neoformat_enabled_python = {
	"black",
	"autopep8",
}

-- vim.g.neoformat_enabled_php = {
-- 	"php-cs-fixer",
-- }

-- format on save
-- vim.cmd([[
--   augroup fmt
--     autocmd!
--     " if file not changed and saved (e.g. to trigger test run), error is thrown: use try/catch to suppress
--     au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
--   a
-- ]])
