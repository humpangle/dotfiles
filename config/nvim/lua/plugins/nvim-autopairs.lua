local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end

npairs.setup({
	-- Use treesitter to check for a pair.
	check_ts = true,

	ts_config = {
		lua = {
			-- it will not add a pair on that treesitter node
			"string",
			"source",
		},

		javascript = {
			"string",
			"template_string",
		},

		-- don't check treesitter on java
		java = false,
	},

	disable_filetype = {
		"TelescopePrompt",
		"spectre_panel",
	},

	fast_wrap = {
		map = "<M-e>",

		chars = {
			"{",
			"[",
			"(",
			'"',
			"'",
			"<",
		},

		pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),

		-- Offset from pattern match
		offset = 0,

		end_key = "$",

		keys = "qwertyuiopzxcvbnmasdfghjkl",

		check_comma = true,

		highlight = "PmenuSel",

		highlight_grey = "LineNr",
	},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local cmp_status_ok, cmp = pcall(require, "cmp")

if not cmp_status_ok then
	return
end
cmp.event:on(
	"confirm_done",
	cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
)

local Rule = require("nvim-autopairs.rule")

npairs.add_rule(Rule("<", ">"))
