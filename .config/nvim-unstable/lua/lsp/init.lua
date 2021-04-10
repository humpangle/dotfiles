local vim = vim

if LSP.enabled == nil or LSP.enabled == false then
    require("lsp/completion")
elseif LSP.enabled == true then
    require("lsp/completion")

    -- LSP servers

    -- Stop lsp diagnostics from showing virtual text
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
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
end
