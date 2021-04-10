-- https://github.com/aca/emmet-ls
-- npm i -g emmet-ls
local configs = require("lspconfig/configs")
local nvim_lsp = require("lspconfig")

local vim = vim
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

configs.emmet_ls = {
    default_config = {
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = function()
            return vim.loop.cwd()
        end,
        settings = {},
    },
}
nvim_lsp.emmet_ls.setup {autostart = LSP.emmet}

-- no need for hmtl server having emmet-ls and snippets working
-- npm i -g vscode-html-languageserver-bin
-- nvim_lsp.html.setup {}
