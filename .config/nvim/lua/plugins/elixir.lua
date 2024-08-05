local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  {
    "emmanueltouzery/elixir-extras.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local e = require("elixir-extras")

      vim.api.nvim_create_user_command("EE", function(opts)
        -- opts.fargs[1] = nil | deps | multi_clause_gutter
        --    nil:                  view docs for your project and core docs
        --    deps:        include docs from mix deps in api documentation view
        --    multi_clause_gutter:  enable markers in the gutter for multi clause functions.

        local arg_size = #opts.fargs

        if arg_size == 0 then
          return e.elixir_view_docs({})
        end

        local flag = opts.fargs[1]

        if flag == "deps" then
          return e.elixir_view_docs({ include_mix_libs = true })
        end

        -- flag == "multi_clause_gutter"
        e.setup_multiple_clause_gutter()
      end, {
        nargs = "*",
        force = true,
        desc = "Show elixir API docs using emmanueltouzery/elixir-extras.nvim plugin",
        complete = function()
          -- return completion candidates as a list-like table
          return {
            "deps",
            "multi_clause_gutter",
          }
        end,
      })
    end,
  },
}
