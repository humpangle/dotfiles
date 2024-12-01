local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  "claydugo/browsher.nvim",
  event = "VeryLazy",
  config = function()
    -- Specify empty to use below default options
    require("browsher").setup({
      --- Default remote name (e.g., 'origin').
      default_remote = nil,
      --- Default branch name.
      default_branch = nil,
      --- Default pin type ('commit', 'branch', or 'tag').
      default_pin = "commit",
      --- Length of the commit hash to use in URLs. If nil, use full length. (40)
      commit_length = nil,
      --- Allow line numbers with uncommitted changes.
      allow_line_numbers_with_uncommitted_changes = true, -- false,
      --- Command to open URLs (e.g., 'firefox').
      open_cmd = nil,
      --- Custom providers for building URLs.
      ---
      --- Each provider is a table with the following keys:
      --- - `url_template`: The URL template, where `%s` are placeholders.
      ---   The placeholders are, in order:
      ---   1. Remote URL
      ---   2. Branch or tag
      ---   3. Relative file path
      --- - `single_line_format`: Format string for a single line (e.g., `#L%d`).
      --- - `multi_line_format`: Format string for multiple lines (e.g., `#L%d-L%d`).
      ---
      --- Example:
      --- ```lua
      --- providers = {
      ---   ["mygit.com"] = {
      ---     url_template = "%s/src/%s/%s",
      ---     single_line_format = "?line=%d",
      ---     multi_line_format = "?start=%d&end=%d",
      ---   },
      --- }
      providers = {
        ["github.com"] = {
          url_template = "%s/blob/%s/%s",
          single_line_format = "#L%d",
          multi_line_format = "#L%d-L%d",
        },
        ["gitlab.com"] = {
          url_template = "%s/-/blob/%s/%s",
          single_line_format = "#L%d",
          multi_line_format = "#L%d-%d",
        },
      },
    })
  end,
}
