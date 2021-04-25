require("compe").setup {
    enabled = true,
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
        path = true,
        buffer = true,
        calc = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        spell = true,
        tags = false, -- will revisit later: after seeing how lsp accomplishes
        treesitter = false, -- Warning: it sometimes really slow
        emoji = false,
    },
}

local u = require("utils/core")
--
-- Key bindings for Auto Import etc
-- -- Trigger completion
u.map("i", "<C-Space>", [[compe#complete()]], {silent = true, expr = true})
-- Confirm completion. Use c-y ??
u.map("i", "<CR>", [[compe#confirm('<CR>')]], {silent = true, expr = true})
-- Close completion menu
u.map("i", "<C-e>", [[compe#close('<C-e>')]], {silent = true, expr = true})

u.map("i", "<C-f>", [[compe#scroll({ 'delta': +4 })]],
      {silent = true, expr = true})

u.map("i", "<C-d>", [[compe#scroll({ 'delta': -4 })]],
      {silent = true, expr = true})
