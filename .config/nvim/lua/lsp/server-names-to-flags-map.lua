-- This is a map of server names and some flags so that in `./config.lua` and I
-- wouldn't need to do `if...else`. Options that can be passed to each server
-- on initialization can be found in `./settings/`. For each server, go to
-- https://github.com/tamago324/nlsp-settings.nvim/tree/main/schemas to see
-- what options are available

local M = {}

-- Some servers will have their LSP formatting capabilities disabled
-- as we will be using null-ls
M.servers_names_map = {
	bashls = {},

	cssls = {},

	dockerls = {},

	elixirls = {
		no_formatting = true,
	},

	emmet_ls = {},

	-- eslint = {},

	graphql = {},

	html = {
		no_formatting = true,
	},

	-- Set up your intelephense licence:
	-- -- echo "export INTELEPHENSE_LICENCE=''" >> ~/.bashrc
	intelephense = {
		no_formatting = true,
	},

	jsonls = {
		no_formatting = true,
	},

	-- https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/pylsp#installing-pylsp-plugins
	-- :PylspInstall python-ls-black pylsp-mypy pyls-isort
	pylsp = {},

	sumneko_lua = {},

	tailwindcss = {},

	tsserver = {
		no_formatting = true,
	},

	vimls = {},

	volar = {
		no_formatting = true,
	},

	yamlls = {},

  -- https://github.com/lighttiger2505/sqls#installation
  -- go install github.com/lighttiger2505/sqls@latest
	sqls = {},
}

return M
