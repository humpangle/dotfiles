local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.fzf_lua_install() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key

local invoke_telescope_func = function(func_name)
  local ok, telescope_builtins_module = pcall(require, "telescope.builtin")
  if not ok then
    return
  end

  if
    telescope_builtins_module[func_name]
    and type(telescope_builtins_module[func_name]) == "function"
  then
    telescope_builtins_module[func_name]()
  end
end

local map_to_fzf_lua_or_telescope = function(
  key,
  func_name,
  desc,
  may_be_telescope_func_name
)
  map_key("n", key, function()
    local count = vim.v.count

    if count == 0 then
      vim.cmd("FzfLua " .. func_name)
      return
    end

    invoke_telescope_func(may_be_telescope_func_name or func_name)
  end, {
    noremap = true,
    desc = "LSP " .. desc,
  })
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.cmd("FzfLua register_ui_select")

      local actions = require("fzf-lua.actions")
      local my_fzf_utils = require("plugins/fzf-lua/utils")

      require("fzf-lua").setup({
        winopts = {
          fullscreen = true,
        },

        git = {
          branches = {
            actions = {
              ["enter"] = actions.git_switch,

              ["ctrl-d"] = {
                fn = actions.git_branch_del,
                reload = true,
              },

              ["ctrl-b"] = {
                fn = actions.git_branch_add,
                field_index = "{q}",
                reload = true,
              },

              ["ctrl-e"] = {
                fn = my_fzf_utils.git_branch_merge,
                -- reload = true,
              },
            },
            -- Add branch and switch immediately
            cmd_add = {
              "git",
              "checkout",
              "-b",
            },
          },
        },
      })

      -- Find open buffers
      map_key("n", "<Leader>ffb", function()
        vim.cmd("FzfLua buffers")
      end, {
        noremap = true,
      })

      -- Find file from cwd
      map_key("n", "<leader>ffW", function()
        vim.cmd("FzfLua files")
      end, { noremap = true })

      -- Find windows
      map_key("n", "<leader>ffw", function()
        vim.cmd("FzfLua tabs")
      end, { noremap = true })

      -- Search buffers history
      map_key("n", "<Leader>fh", function()
        vim.cmd("FzfLua oldfiles")
      end, {
        noremap = true,
      })

      -- Search for text in current buffer
      map_key("n", "<Leader>ffl", function()
        vim.cmd("FzfLua grep_curbuf")
      end, {
        noremap = true,
        desc = "",
      })

      -- Search in project - do not match filenames
      map_key("n", "<Leader>f/", function()
        vim.cmd("FzfLua grep_project")
      end, { noremap = true })

      -- map_key("n", "<leader>cb", function()
      --   vim.cmd("FzfLua git_branches")
      -- end, {
      --   noremap = true,
      --   desc = "Git branches",
      -- })

      map_key("n", "<leader>czL", function()
        vim.cmd("FzfLua git_stash")
      end, {
        noremap = true,
        desc = "Git stashes list",
      })

      -- Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
      map_to_fzf_lua_or_telescope(
        "<leader>bs",
        "lsp_document_symbols",
        "[D]ocument [S]ymbols"
      )

      -- Find references(places where identifiers are used/referenced) for the word under your cursor.
      map_to_fzf_lua_or_telescope(
        "gr",
        "lsp_references",
        "[G]oto [R]eferences"
      )

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map_to_fzf_lua_or_telescope(
        "gd",
        "lsp_definitions",
        "[G]oto [D]efinition"
      )

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map_to_fzf_lua_or_telescope(
        "gi",
        "lsp_implementations",
        "[G]oto [I]mplementation"
      )

      -- Fuzzy find all the symbols in your current workspace. Similar to document symbols, except searches over your entire project.
      map_to_fzf_lua_or_telescope(
        "<leader>ws",
        "lsp_live_workspace_symbols",
        "[W]orkspace [S]ymbols",
        "lsp_dynamic_workspace_symbols"
      )
    end,
  },
}
