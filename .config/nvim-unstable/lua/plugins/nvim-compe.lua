require"compe".setup {
    enabled = Completion.enabled,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = Completion.path,
        buffer = Completion.buffer,
        calc = Completion.calc,
        vsnip = Completion.snippets,
        nvim_lsp = Completion.lsp,
        nvim_lua = true,
        spell = Completion.spell,
        tags = false, -- will revisit later: after seeing how lsp accomplishes
        treesitter = false, -- Warning: it sometimes really slow
        emoji = false,
    },
}
