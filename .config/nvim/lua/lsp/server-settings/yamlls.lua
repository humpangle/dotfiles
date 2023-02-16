return {
	settings = {
		yaml = {
			schemas = {
				["kubernetes"] = {
					"/kubernetes.yml",
				},

				["https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json"] = {
					"/docker-compose.yml",
				},
			},
		},
	},
}
