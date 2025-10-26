-- TODO:implement trash file
-- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/202#issuecomment-2996740957

local utils = require("utils")

local function open_buffer_dir()
  -- Open the directory of the file currently being edited
  -- If the file doesn't exist because you maybe switched to a new git branch
  -- open the current working directory

  local mini_files = require("mini.files")
  local buf_name = vim.api.nvim_buf_get_name(0)
  local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
  if vim.fn.filereadable(buf_name) == 1 then
    -- Pass the full file path to highlight the file
    mini_files.open(buf_name, true)
  elseif vim.fn.isdirectory(dir_name) == 1 then
    -- If the directory exists but the file doesn't, open the directory
    mini_files.open(dir_name, true)
  else
    -- If neither exists, fallback to the current working directory
    mini_files.open(vim.uv.cwd(), true)
  end
end

return {
  "nvim-mini/mini.files",
  -- https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/mini-files.lua
  opts = function(_, opts)
    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
      close = "qq",
      -- Use this if you want to open several files
      go_in = "<CR>",
      -- This opens the file, but quits out of mini.files (default L)
      go_in_plus = "", -- "<CR>",
      -- I swapped the following 2 (default go_out: h)
      -- go_out_plus: when you go out, it shows you only 1 item to the right
      -- go_out: shows you all the items to the right
      go_out = "H",
      go_out_plus = "-", -- "h",
      -- Default <BS>
      reset = "<BS>",
      -- Default @
      reveal_cwd = ".",
      show_help = "g?",
      -- Default =
      synchronize = "s",
      trim_left = "<",
      trim_right = ">",
    })

    opts.windows = vim.tbl_deep_extend("force", opts.windows or {}, {
      preview = true,
      width_focus = 30,
      width_preview = 80,
    })

    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      -- If set to false, files are moved to the trash directory
      -- To get this dir run :echo stdpath('data')
      -- ~/.local/share/neobean/mini.files/trash
      permanent_delete = false,
    })

    return opts
  end,
  config = function(_, opts)
    local mini_files = require("mini.files")
    mini_files.setup(opts)
  end,
  keys = {
    utils.map_lazy_key("-", function()
      local count = vim.v.count

      if count == 0 then
        open_buffer_dir()
        return
      end

      require("mini.files").open(vim.uv.cwd(), true)
    end),
  },
}
