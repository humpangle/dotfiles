local utils = {
    rg_defaults = {
        "rg",
        "--files",
        "--hidden",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--ignore",
    },
}

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
        Vim.cmd("augroup " .. group_name)
        Vim.cmd("autocmd!")

        for _, def in pairs(definition) do
            local command = table.concat(Vim.tbl_flatten({"autocmd", def}), " ")
            Vim.cmd(command)
        end

        Vim.cmd("augroup END")
    end
end

-- mappings
function utils.map(mode, key, result, opts)
    local options = {noremap = true}
    if opts then
        options = Vim.tbl_extend("force", options, opts)
    end
    Vim.api.nvim_set_keymap(mode, key, result, options)
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

function utils.find_files(dir)
    local telescope = require("telescope.builtin")
    local opts

    if dir == "git" then
        local ok = pcall(telescope.git_files, opts)
        if ok then
            return
        end
    end

    local rg_options = Vim.tbl_extend("force", utils.rg_defaults, {})

    if dir == "dir" then
        local current_dir = Vim.fn.expand("%:h")
        table.insert(rg_options, current_dir)
    end

    opts = {find_command = rg_options}
    telescope.find_files(opts)

end

function utils.toggleBackground()
    if Vimo.background == "dark" then
        Vimo.background = "light"
    else
        Vimo.background = "light"
    end
end

return utils
