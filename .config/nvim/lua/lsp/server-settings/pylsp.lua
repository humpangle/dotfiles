return {
	settings = {
		pylsp = {
			plugins = {
				-- Disabled because we are using the opinionated formatters black
				pycodestyle = {
					enabled = false,
				},

				pydocstyle = {
					enabled = false,
				},

				-- FORMATTERS
				-- Sine yapf and autopep8 are disabled, black will be used.
				yapf = {
					enabled = false,
				},

				autopep8 = {
					enabled = false,
				},
				-- / FORMATTERS
			},
		},
	},
}
