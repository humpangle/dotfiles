-- install instructions from
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone):
-- git clone https://github.com/sumneko/lua-language-server $HOME/.local/share/nvim/lua/sumneko_lua
-- cd ~/.local/share/nvim/lua/sumneko_lua
-- git submodule update --init --recursive
-- cd 3rd/luamake
-- ninja -f ninja/linux.ninja
-- cd ../..
-- ./3rd/luamake/luamake rebuild
local luapath = "/home/" .. os.getenv("USER") ..
                    "/.local/share/nvim/lua/sumneko_lua"
local luabin = luapath .. "/bin/Linux/lua-language-server"

local nvim_lsp = require "lspconfig"
local vim = vim

nvim_lsp.sumneko_lua.setup {
    cmd = {luabin, "-E", luapath .. "/main.lua"},
    autostart = LSP.lua,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim", "use", "run", "Theming", "LSP", "Completion"},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 10000,
            },
            telemetry = {enable = false},
        },
    },
}
