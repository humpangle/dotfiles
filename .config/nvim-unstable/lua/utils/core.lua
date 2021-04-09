local vim_global = vim
local utils = {}
local scopes = {o = vim_global.o, b = vim_global.bo, w = vim_global.wo}

-- autocommands
function utils.define_augroups(definitions) -- {{{1
    -- Create autocommand groups based on the passed definitions
    --
    -- The key will be the name of the group, and each definition
    -- within the group should have:
    --    1. Trigger
    --    2. Pattern
    --    3. Text
    -- just like how they would normally be defined from Vim itself
    for group_name, definition in pairs(definitions) do
        vim_global.cmd("augroup " .. group_name)
        vim_global.cmd("autocmd!")

        for _, def in pairs(definition) do
            local command = table.concat(
                                vim_global.tbl_flatten({"autocmd", def}), " ")
            vim_global.cmd(command)
        end

        vim_global.cmd("augroup END")
    end
end

-- options
function utils.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

-- mappings
function utils.map(mode, key, result, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim_global.tbl_extend("force", options, opts)
    end
    vim_global.api.nvim_set_keymap(mode, key, result, options)
end

-- Telescope
function utils.search_dotfiles()
    require("telescope.builtin").find_files(
        {prompt_title = "Dotfiles", cwd = "$HOME/.config/"})
end

function utils.search_nvim()
    require("telescope.builtin").find_files(
        {prompt_title = "Neovim Config", cwd = "$HOME/.config/nvim"})
end

return utils
