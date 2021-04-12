local u = require("utils.core")

-- TODO figure out why this don't work
Vim.fn.sign_define("LspDiagnosticsSignError", {
    texthl = "LspDiagnosticsSignError",
    text = "",
    numhl = "LspDiagnosticsSignError",
})
Vim.fn.sign_define("LspDiagnosticsSignWarning", {
    texthl = "LspDiagnosticsSignWarning",
    text = "",
    numhl = "LspDiagnosticsSignWarning",
})
Vim.fn.sign_define("LspDiagnosticsSignInformation", {
    texthl = "LspDiagnosticsSignInformation",
    text = "",
    numhl = "LspDiagnosticsSignInformation",
})
Vim.fn.sign_define("LspDiagnosticsSignHint", {
    texthl = "LspDiagnosticsSignHint",
    text = "",
    numhl = "LspDiagnosticsSignHint",
})

-- symbols for autocomplete
Vim.lsp.protocol.CompletionItemKind = {
    "   ",
    "  ",
    "  ",
    "  ",
    " ﴲ ",
    "  ",
    "  ",
    "  ",
    "  ",
    " 襁 ",
    "  ",
    "  ",
    "  ",
    "  ",
    " ",
    "  ",
    "  ",
    "  ",
    "  ",
    "  ",
    " ﲀ ",
    " ﳤ ",
    "  ",
    "  ",
    "  ",
}

local t = function(str)
    return Vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = Vim.fn.col(".") - 1
    if col == 0 or Vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if Vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif Vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return Vim.fn["compe#complete"]()
    end
end
_G.s_tab_complete = function()
    if Vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif Vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

u.map("i", "<CR>", "compe#confirm('<CR>')", {expr = true})
Vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
Vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
Vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
Vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
