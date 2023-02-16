local client_config_module = require("lsp.client-config")
local servers_names_map_module = require("lsp.server-names-to-flags-map")

local lsp_installer_ok, _ = pcall(require, "nvim-lsp-installer")
if not lsp_installer_ok then
	return
end

local lsp_installer_servers = require("nvim-lsp-installer.servers")

local servers_names_map = servers_names_map_module.servers_names_map

for server_name, _ in pairs(servers_names_map) do
	local server_available, requested_server = lsp_installer_servers.get_server(
		server_name
	)

	if server_available then
		requested_server:on_ready(function()
			local on_attach = client_config_module.on_attach
			local capabilities = client_config_module.capabilities

			local has_exclusive_server_opts, exclusive_server_opts = pcall(
				require,
				"lsp.server-settings." .. server_name
			)

			if not has_exclusive_server_opts then
				exclusive_server_opts = {}
			end

			if exclusive_server_opts.on_attach then
				on_attach = exclusive_server_opts.on_attach(
					client_config_module
				)
			end

			local server_opts = vim.tbl_deep_extend(
				"force",
				exclusive_server_opts,
				{
					on_attach = on_attach,
					capabilities = capabilities,
					flags = {
						-- This will be the default in neovim 0.7+
						debounce_text_changes = 150,
					},
				}
			)

			requested_server:setup(server_opts)
		end)

		if not requested_server:is_installed() then
			-- Queue the server to be installed
			requested_server:install()
		end
	end
end
