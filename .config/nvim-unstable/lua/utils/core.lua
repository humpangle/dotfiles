local vim_expand = Vimf.expand
local vim_empty = Vimf.empty

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
        local current_dir = vim_expand("%:h")
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

function utils.split(parent_str, regex)
    local splits = {}
    local fpat = "(.-)" .. regex
    local last_end = 1
    local s, e, next_token = parent_str:find(fpat, 1)

    while s do
        if s ~= 1 or next_token ~= "" then
            table.insert(splits, next_token)
        end

        last_end = e + 1
        s, e, next_token = parent_str:find(fpat, last_end)
    end

    if last_end <= #parent_str then
        next_token = parent_str:sub(last_end)
        table.insert(splits, next_token)
    end

    return splits
end

function utils.get_file_name(num)
    local has_file_arg = type(num) == "string"
    local file_name = (has_file_arg and num) or vim_expand("%:f")

    if vim_empty(file_name) == 1 then
        return "[No Name]"
    end

    local splitted = utils.split(file_name, "/+")
    local len = #splitted
    local last_but_one_index = len - 1
    local tail = splitted[len]

    if has_file_arg then
        local m = {}

        for i = 1, last_but_one_index, 1 do
            local t = string.sub(splitted[i], 1, 1)

            if t == "." then -- for dot file, we take the dot and next char
                t = string.sub(splitted[i], 1, 2)
            end

            table.insert(m, t)
        end

        return table.concat(m, "/") .. "/" .. tail
    elseif num == 2 then
        local head = splitted[last_but_one_index]

        if head then
            return head .. "/" .. tail
        end

        return tail
    end

    return tail
end

return utils
