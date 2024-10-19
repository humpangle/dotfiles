-- Highlight, edit, and navigate code
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.treesitter() then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      require("plugins/treesitter-textobjects"),
    },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "eex",
        "elixir",
        "heex",
        "erlang",
        "gitignore",
        "go",
        "helm",
        "html",
        "ini",
        "jsdoc",
        "json5",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scss",
        "sql",
        "ssh_config",
        "terraform",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = {
          "ruby",
        },
        disable = {
          "gitcommit", -- treesitter highlighting does not work well inside buffer of this type.
        },
      },
      indent = {
        enable = true,
        disable = {
          "ruby",
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

      -- Courtesy : https://elixirforum.com/t/preview-livebook-in-neovim/65080
      vim.treesitter.language.register("markdown", "livebook")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
}
