require("nvim-treesitter.configs").setup({
	-- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = {
		"bash",
		"comment",
		"dart",
		"dockerfile",
		"elixir",
		"erlang",
		"fish",
		"go",
		"graphql",
		"heex",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"lua",
		"make",
		"php",
		"python",
		"regex",
		"rst",
		"ruby",
		"rust",
		"scss",
		"svelte",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},
	highlight = {
		-- false will disable the whole extension
		enable = true,
		-- list of language that will be disabled
		disable = {},
	},
	indent = {
		-- default is disabled
		enable = true,
	},
	context_commentstring = {
		enable = true,
	},
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
