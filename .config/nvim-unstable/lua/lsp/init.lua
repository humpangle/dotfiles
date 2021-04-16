if LSP.enabled == nil or LSP.enabled == false then
    require("lsp/completion")
elseif LSP.enabled == true then
    require("lsp/completion")

    -- LSP servers

    -- Stop lsp diagnostics from showing virtual text
    Vim.lsp.handlers["textDocument/publishDiagnostics"] =
        Vim.lsp.with(Vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            update_in_insert = false,
            underline = true,
            signs = true,
        })

    -- javascript/typescript
    require("lsp/tsserver")

    -- bash
    require("lsp/bashls")

    -- lua
    require("lsp/sumneko_lua")

    -- python
    require("lsp/pyright")

    -- html etc
    require("lsp/emmet_ls")

    -- json
    require("lsp/jsonls")

    -- css
    require("lsp/cssls")

    local u = require("utils.core")

    -- u.map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
    u.map("n", "gd", ":Telescope lsp_definitions<CR>")
    -- u.map("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>")
    -- u.map("n", "gr", ":Telescope lsp_references<CR>")
    -- u.map("n", "gh", ":lua vim.lsp.buf.hover()<CR>")
    -- u.map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
    -- u.map("n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>")
    -- u.map("n", "<c-p>", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
    -- u.map("n", "<c-n>", ":lua vim.lsp.diagnostic.goto_next()<CR>")
end
