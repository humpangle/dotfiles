-- General purpose linters
return {
  -- https://github.com/mfussenegger/nvim-lint
  "mfussenegger/nvim-lint",
  ft = {
    "python",
  },
  config = function()
    -- Define a table of linters for each filetype (not extension).
    -- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint#available-linters
    require("lint").linters_by_ft = {
      python = {
        -- Uncomment whichever linters you prefer (you should install them with mason tools).
        "flake8",
        -- "mypy", -- Linting errors will only clear if you enter and leave insert mode again. Except we activate BufWritePost
        -- "pylint", -- Linting errors wouldn't clear until you force formatter to run (by distorting current
        -- formatting).
      },
    }

    vim.api.nvim_create_autocmd({
      "BufWritePost" , -- Lint on save.
      "InsertLeave", -- More aggressive linting on leaving insert mode.
    }, {
      -- Only run linter for the following extensions. Remove this to always run.
      pattern = { "*.py" },
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
