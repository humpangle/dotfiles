-- https://github.com/haringsrob/neovim-config/blob/master/lua/config/lsp.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

-- make $ part of the keyword.
vim.api.nvim_exec(
	[[
  autocmd FileType php set iskeyword+=$
]],
	false
)

return {
	init_options = {
		licenceKey = os.getenv("INTELEPHENSE_LICENCE"),
	},

	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},

			completion = {
				fullyQualifyGlobalConstantsAndFunctions = false,
			},

			phpdoc = { returnVoid = false },
		},
	},
}
