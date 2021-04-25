local u = require("utils/core")

require("gitsigns").setup {
    signs = {
        add = {
            hl = "GitSignsAdd",
            text = "+",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn",
        },
        change = {
            hl = "GitSignsChange",
            text = "*",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
        },
        delete = {
            hl = "GitSignsDelete",
            text = "_",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
        },
        topdelete = {
            hl = "GitSignsDelete",
            text = "‾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
        },
        changedelete = {
            hl = "GitSignsChange",
            text = "~",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
        },
    },
    numhl = false,
    linehl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
    },
    watch_index = {interval = 1000},
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
    use_decoration_api = true,
    use_internal_diff = true, -- If luajit is present
}

u.map("n", "<leader>hu", [[<cmd>lua require("gitsigns").undo_stage_hunk()<CR>]])
u.map("n", "<leader>hr", [[<cmd>lua require("gitsigns").reset_hunk()<CR>]])
u.map("n", "<leader>hR", [[<cmd>lua require("gitsigns").reset_buffer()<CR>]])
u.map("n", "<leader>hp", [[<cmd>lua require("gitsigns").preview_hunk()<CR>]])
u.map("n", "<leader>hb", [[<cmd>lua require("gitsigns").blame_line()<CR>]])
u.map("n", "]c", [[<cmd>lua require("gitsigns").next_hunk()<CR>]])
u.map("n", "[c", [[<cmd>lua require("gitsigns").prev_hunk()<CR>]])
