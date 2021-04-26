local u = require("util")

-- TODO: signcolumn loses color when colorscheme changed. Study the below
-- for likely fix:
-- https://github.com/folke/lsp-colors.nvim
--
-- underline error/warning messages (with colors)
-- Diagnostic text colors
Cmd([[
  augroup MyLspDiagnosticColors
    autocmd!
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsVirtualTextWarning guifg=Grey ctermfg=Grey
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsVirtualTextInformation guifg=248 ctermfg=248
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsVirtualTextHint guifg=248 ctermfg=248

    " Underline the offending code
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsUnderlineError guifg=Red ctermfg=Red cterm=underline gui=underline
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsUnderlineWarning guifg=Grey ctermfg=Grey cterm=underline gui=underline
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsUnderlineInformation guifg=248 ctermfg=248 cterm=underline gui=underline
    autocmd BufEnter,ColorScheme * hi LspDiagnosticsUnderlineHint guifg=248 ctermfg=248 cterm=underline gui=underline

    " suggested:
    "      autocmd BufEnter,ColorScheme *  highlight! link LspDiagnosticsUnderlineError SpellBad  "  (SpellCap, SpellLocal and SpellRare)
  augroup END
]])

-- this not working: https://github.com/neovim/neovim/issues/12162
-- Attempt to use autocmd to change color (as below ) also fails
-- autocmd ColorScheme * hi! LspDiagnosticsErrorSign cterm=bold ctermfg=196 ctermbg=235
Vimf.sign_define("LspDiagnosticsErrorSign",
                 {text = "Er", texthl = "LspDiagnosticsError"})

local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {}
    u.map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts, bufnr)

    u.map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, bufnr)

    u.map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts, bufnr)

    u.map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts, bufnr)

    u.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts, bufnr)

    -- u.map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    --                opts)

    u.map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts, bufnr)

    u.map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts, bufnr)

    u.map("n", "<leader>law", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
          opts, bufnr)

    u.map("n", "<leader>lrw",
          "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts, bufnr)

    u.map("n", "<leader>llw",
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
          opts, bufnr)

    u.map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts,
          bufnr)

    u.map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, bufnr)

    u.map("n", "<leader>ld",
          "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts, bufnr)

    u.map("n", "<leader>dd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
          opts, bufnr)

    u.map("n", ",ac", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts, bufnr)

    u.map("n", ",o", "<cmd>lua lsp_organize_imports()<CR>", opts, bufnr)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        u.map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts,
              bufnr)

    elseif client.resolved_capabilities.document_range_formatting then
        u.map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
              opts, bufnr)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        Cmd([[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=#6F5858 guifg=#E0DADA
          hi LspReferenceText cterm=bold ctermbg=red guibg=#6F5858  guifg=#E0DADA
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=#6F5858  guifg=#E0DADA

          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd cursorhold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd cursormoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
    end
end

local nvim_lsp = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
capabilities.textDocument.completion.completionItem.snippetSupport = true;
capabilities.textDocument.completion.completionItem.resolveSupport =
    {properties = {"documentation", "detail", "additionalTextEdits"}}

-- lsp-install
-- https://github.com/kabouzeid/nvim-lspinstall/wiki
-- ################# IMPORTANT ###################
-- do not forget to install a server: LspInstall <server>
-- see: https://github.com/kabouzeid/nvim-lspinstall#bundled-installers
-- for list of servers

------------------------------ Custom Installer -------------------
-- https://github.com/kabouzeid/nvim-lspinstall#custom-installer

-- Emmet
-- https://github.com/aca/emmet-ls
-- no need for hmtl server having emmet-ls and snippets working
local emmet_config = {
    default_config = {
        cmd = {"emmet-ls", "--stdio"},
        filetypes = {"html", "css"},
        root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json",
                                              "jsconfig.json", ".git",
                                              Vimf.getcwd()),
        settings = {},
    },
}

require"lspinstall/servers".emmet = vim.tbl_extend("error", emmet_config, {
    -- lspinstall will automatically create/delete the install directory for every server
    install_script = "npm install emmet-ls@latest",
    uninstall_script = nil, -- can be omitted
})

-- Configure lua language server for neovim development
local lua_settings = {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {"vim", "use", "run"},
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
        },
        telemetry = {enable = false},
        completion = {snippetSupport = true},
    },
}

local python_settings = {
    pyright = {disableOrganizeImports = false, disableLanguageServices = false},
}

local lsp_install = require("lspinstall")

local function auto_install()
    lsp_install.setup()
    local installed_servers = lsp_install.installed_servers()

    for _, server in pairs(installed_servers) do
        local config = {on_attach = on_attach, capabilities}

        -- language specific config
        if server == "lua" then
            config.settings = lua_settings
        end

        if server == "python" then
            config.settings = python_settings
        end

        nvim_lsp[server].setup(config)
    end
end

auto_install()
-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lsp_install.post_install_hook = function()
    -- reload installed servers
    auto_install()

    -- triggers the FileType autocmd that starts the server
    vim.cmd("bufdo e")
end
