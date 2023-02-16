local M = {
    init_options = {
        preferences = {
            -- disableSuggestions = true,
        },
    },
}

M.on_attach = function(lsp_config)
    return function(client, bufnr)
        local ts_utils = require("nvim-lsp-ts-utils")

        ts_utils.setup({
            filter_out_diagnostics_by_code = {
                -- Disable "File is a CommonJS module; it may be converted to an ES6 module"
                -- https://stackoverflow.com/a/70294761
                80001,
            },
        })

        ts_utils.setup_client(client)

        lsp_config.on_attach(client, bufnr)

        vim.api.nvim_buf_set_keymap(bufnr, "n", ",o", ":TSLspOrganize<CR>",
                                    lsp_config.keymap_opts)
    end
end

return M
