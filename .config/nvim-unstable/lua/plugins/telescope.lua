local u = require("utils.core")

local actions = require("telescope.actions")
-- Global remapping
------------------------------
-- '--color=never',
require("telescope").setup {
    defaults = {
        prompt_position = "top",
        sorting_strategy = "ascending",

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default + actions.center,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
            },
        },
    },
    extensions = {
        media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
            find_cmd = "rg", -- find command (defaults to `fd`)
        },
    },
}

require("telescope").load_extension("media_files")

-- Search file from root directory
u.map("n", "<leader>ff", [[:lua require("utils.core").find_files() <CR>]])
-- Search file from current directory
u.map("n", "<leader>.", [[:lua require("utils.core").find_files("dir") <CR>]])
-- find open buffers
u.map("n", "<leader>fb", [[:Telescope buffers<CR>]])
-- Files managed by git
u.map("n", "<leader>fg", [[:lua require("utils.core").find_files("git") <CR>]])
-- search buffers history
u.map("n", "<leader>fh", [[:Telescope command_history<CR>]])
-- search for text in current buffer
-- not working
u.map("n", "<leader>bl", [[:Telescope current_buffer_fuzzy_find<CR>]])
u.map("n", "<leader>mm", [[:Telescope marks<CR>]])
-- commands: user defined, plugin defined, or native commands
u.map("n", "<leader>C", [[:Telescope commands<CR>]])
-- key mappings - find already mapped before defining new mappings
u.map("n", "<leader>M", [[:Telescope keymaps<CR>]])
u.map("n", "<leader>ft", [[:Telescope filetypes<CR>]])
-- Git commits
u.map("n", "<leader>cm", [[:Telescope git_commits<CR>]])

u.map("n", "<leader>H", [[:Telescope help_tags<CR>]])
u.map("n", "<leader>fs", [[:Telescope colorscheme<CR>]])
u.map("n", "<leader>fa", [[:lua require("utils.core").search_dotfiles()<CR>]])
u.map("n", "<leader>fn", [[:lua require("utils.core").search_nvim()<CR>]])
-- Ivy-like file explorer:
-- use tab to enter directory
-- bksp go up directory
-- create file: type filename and <c-e>
u.map("n", "<leader>fe", [[:Telescope file_browser<CR>]])
u.map("n", "<leader>fm", [[:Telescope media_files<CR>]])
-- find previously open files
u.map("n", "<leader>fo", [[:Telescope oldfiles<CR>]])
