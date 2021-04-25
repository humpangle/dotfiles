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
        "--glob",
        os.getenv("RG_IGNORES"),
    },
}

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
        Vimo.background = "dark"
    end
end

function utils.delete_buffers()
    local last_buf_num = Vim.fn.bufnr("%")
    local i = 1
    local wipe_buf = ""
    local del_buf = ""

    while i <= last_buf_num do
        local buf_name = Vim.fn.bufname(i)

        if Vim.fn.bufexists(i) == 1 then
            if buf_name == "" or buf_name:find("term://") == 1 then
                wipe_buf = wipe_buf .. " " .. i
            else
                del_buf = del_buf .. " " .. i
            end
        end

        i = i + 1
    end

    if wipe_buf ~= "" then
        Cmd("bwipeout!" .. wipe_buf)
    end

    if del_buf ~= "" then
        Cmd("bd" .. del_buf)
    end
end

function utils.toggle_spell()
    if Vim.w.spell then
        Vimo.spell = false
    else
        Vimo.spell = true
    end
end

return utils
