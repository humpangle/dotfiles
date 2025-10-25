-- Harper LSP - Grammar checker
-- https://github.com/Automattic/harper
-- https://writewithharper.com/docs/integrations/neovim

local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.harper_lsp() then
  return {}
end

return {
  harper_ls = {
    filetypes = {
      "markdown",
      "rust",
      "typescript",
      "typescriptreact",
      "javascript",
      "python",
      "go",
      "c",
      "cpp",
      "ruby",
      "swift",
      "csharp",
      "toml",
      "lua",
      "gitcommit",
      "java",
    },
    settings = {
      ["harper-ls"] = {
        linters = {
          spell_check = true,
          spelled_numbers = false,
          an_a = true,
          sentence_capitalization = true,
          unclosed_quotes = true,
          wrong_quotes = false,
          long_sentences = true,
          repeated_words = true,
          spaces = true,
          matcher = true,
          correct_number_suffix = true,
          number_suffix_capitalization = true,
          multiple_sequential_pronouns = true,
        },
      },
    },
  },
}
