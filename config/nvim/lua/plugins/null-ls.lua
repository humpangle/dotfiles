local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
	diagnostics.eslint.with({
		prefer_local = "node_modules/.bin",
	}),

	code_actions.eslint.with({
		prefer_local = "node_modules/.bin",
	}),

	-- npm install -g @fsouza/prettierd
	formatting.prettierd.with({
		prefer_local = "node_modules/.bin",
	}),

	-- https://github.com/JohnnyMorganz/StyLua#from-cratesio
	-- cargo install stylua --features lua52
	formatting.stylua,

	-- https://github.com/FriendsOfPHP/PHP-CS-Fixer/blob/master/doc/installation.rst#globally-manual
	-- curl -L https://cs.symfony.com/download/php-cs-fixer-v3.phar -o /tmp/php-cs-fixer \
	--   && sudo chmod a+x /tmp/php-cs-fixer \
	--   && sudo mv /tmp/php-cs-fixer /usr/local/bin/php-cs-fixer
	formatting.phpcsfixer.with({
		args = {
			"--no-interaction",
			"--quiet",
			"fix",
			"$FILENAME",
		},
	}),

	-- go install mvdan.cc/sh/v3/cmd/shfmt@latest
	formatting.shfmt,

	-- shell script static analysis tool.
	diagnostics.shellcheck,
	code_actions.shellcheck,

	-- elixir
	formatting.mix,
}

null_ls.setup({
	debug = false,
	-- debug = true,

	sources = sources,
})
