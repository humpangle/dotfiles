local vim_expand = vim.fn.expand
local vim_empty = vim.fn.empty

local utils = {}

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

    if num == 2 then
        return file_name
    end

    if has_file_arg then
        local splitted = utils.split(file_name, "/+")
        local len = #splitted
        local last_but_one_index = len - 1
        local tail = splitted[len]

        local m = {}

        for i = 1, last_but_one_index, 1 do
            local t = string.sub(splitted[i], 1, 1)

            if t == "." then -- for dot file, we take the dot and next char
                t = string.sub(splitted[i], 1, 2)
            end

            table.insert(m, t)
        end

        return table.concat(m, "/") .. "/" .. tail
    end

    return file_name
end

return utils
