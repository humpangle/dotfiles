local lsp_config = require("lsp.config")
local lsp_utils = require("lsp.utils")

local lsp_installer_ok, _ = pcall(require, "nvim-lsp-installer")
if not lsp_installer_ok then
	return
end

local lsp_installer_servers = require("nvim-lsp-installer.servers")

local server_config_map = lsp_utils.server_config_map

for server_name, _ in pairs(server_config_map) do
	local server_available, requested_server = lsp_installer_servers.get_server(
		server_name
	)

	if server_available then
		requested_server:on_ready(function()
			local on_attach = lsp_config.on_attach
			local capabilities = lsp_config.capabilities

			local has_server_opts, server_opts = pcall(
				require,
				"lsp.settings." .. server_name
			)

			if not has_server_opts then
				server_opts = {}
			end

			if server_opts.on_attach then
				on_attach = server_opts.on_attach(lsp_config)
			end

			local opts = vim.tbl_deep_extend("force", server_opts, {
				on_attach = on_attach,
				capabilities = capabilities,
				flags = {
					-- This will be the default in neovim 0.7+
					debounce_text_changes = 150,
				},
			})

			requested_server:setup(opts)
		end)

		if not requested_server:is_installed() then
			-- Queue the server to be installed
			requested_server:install()
		end
	end
end
