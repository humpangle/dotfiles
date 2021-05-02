local wk = require("which-key")
wk.setup({
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = {gc = "Comments"},
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2}, -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3, -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    -- triggers = "auto", -- automatically setup triggers
    triggers = {"<leader>", ","}, -- or specifiy a list manually
})

local leader_key_maps = {
    e = "Explorer",
    w = "+Save files",
    q = "+Quit",
    t = {
        name = "+Tab/Terminal",
        n = "New Tab Empty",
        s = "Split Tab New",
        t = "Terminal New Split",
        v = "Terminal New VSplit",
    },
    N = "Neoformat",
    p = "+Paragraphs",
    b = {
        name = "+Buffers",
        n = "Rename",
        a = "Delete All",
        e = "Delete All Force",
        d = "Delete Current",
        D = "Delete Current Force",
        w = "Wipe Current",
        l = "List",
    },
    g = {
        name = "+Git",
        g = "Status",
        c = "Commit",
        d = "Diff Vertical",
        ["."] = "Stage all",
        ["%"] = "Stage file",
        l = "Log all",
        ["0"] = "Log file",
    },
    c = {name = "+Commits", b = "Change branch"},
    f = {
        name = "+Find",
        ["."] = "Directory files",
        h = "Buffer history",
        l = "Buffer text",
        g = "Git Files",
    },
    F = {
        name = "+Floaterm",
        F = "New",
        S = "New Split",
        K = "Kill All",
        ["5"] = "50% width",
    },
}

wk.register(leader_key_maps, {prefix = "<leader>", silent = false})
