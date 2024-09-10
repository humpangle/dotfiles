-- Python formatter

local utils = require("utils")

return {
  {
    -- https://github.com/psf/black
    --  You must `pip install -U pynvim` into the python executable
    "psf/black",
    ft = "python",
    config = function()
      -- Force keymap `leader fc` to use Neoformat for certain file types
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {
          "python",
        },
        callback = function()
          utils.map_key("n", "<leader>fc", function()
            vim.cmd("Black")
          end, {
            noremap = true,
            buffer = true,
          })
        end,
      })
    end,
  },

  {
    -- https://github.com/fisadev/vim-isort
    "fisadev/vim-isort",
    ft = "python",
    config = function()
      -- Disable default key binding
      vim.g.vim_isort_map = ""

      -- Automatically format file buffer when saving
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*.py",
        callback = function()
          vim.cmd("Isort")
        end,
      })
    end,
  },

  {
    -- https://github.com/mfussenegger/nvim-dap-python
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      -- https://github.com/mfussenegger/nvim-dap
      "mfussenegger/nvim-dap",
    },
    config = function()
      local python_bin = require("plugins/lsp_utils").get_python_path()

      require("dap-python").setup(python_bin)
    end,
  },
}
