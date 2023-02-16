-- npm install -g @vue/runtime-dom@latest @volar/server
-- "@vue/runtime-dom@latest" for Vue 2 compatibility.

-- use a global TypeScript Server installation if a local server is not found

local util = require("lspconfig.util")

local function get_typescript_server_path(root_dir)
	local project_root = util.find_node_modules_ancestor(root_dir)

	local local_tsserverlib = project_root ~= nil
		and util.path.join(
			project_root,
			"node_modules",
			"typescript",
			"lib",
			"tsserverlibrary.js"
		)

	if local_tsserverlib and util.path.exists(local_tsserverlib) then
		return local_tsserverlib
	else
		return os.getenv("TS_SERVER_GBLOBAL_LIBRARY_PATH") or ""
	end
end

return {
	config = {
		on_new_config = function(new_config, new_root_dir)
			new_config.init_options.typescript.serverPath =
				get_typescript_server_path(
					new_root_dir
				)
		end,
	},
}
