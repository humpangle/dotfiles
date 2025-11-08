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

  local func_to_invoke = telescope_builtins_module[func_name]
  if func_to_invoke and type(func_to_invoke) == "function" then
    func_to_invoke()
  end
end

--[[ How it works: If count contains a number greater than 3, then we invoke telescope e.g. 4gd, 51gd
  Example usage:
    go to definition:    fzf-lua  telescope
      current window:    gd       4gd or gd4
      horizontal split:  1gd      15gd or 51gd
      vertical split:    2gd      42gd
      tab split:         3gd      37gd
]]
local map_to_fzf_lua_or_telescope = function(
  key,
  func_name,
  desc,
  may_be_telescope_func_name
)
  map_key("n", key, function()
    local count = vim.v.count
    local string_count = "" .. count

    -- If count contains 1/2/3, we split window
    -- otherwise we exec in place.
    if string_count:match("1") then
      vim.cmd("split")
    elseif string_count:match("2") then
      vim.cmd("vsplit")
    elseif string_count:match("3") then
      vim.cmd("tab split")
    end

    -- If count matches no other string
    if string_count:match("^%d$") then
      -- utils.set_fzf_lua_nvim_listen_address()
      require("fzf-lua")[func_name]()
      return
    end

    invoke_telescope_func(may_be_telescope_func_name or func_name)
  end, {
    noremap = true,
    desc = "LSP " .. desc,
  })
end

local highlight_content_of_register_plus = function()
  local con = vim.fn.getreg("+")

  if not con or (con == "") then
    return
  end

  vim.fn.setreg("/", con)
  vim.cmd("set hlsearch")

  -- Attempt to navigate to and back from highlighted text
  pcall(function()
    vim.cmd.normal({ "n", bang = true })
    vim.cmd.normal({ "N", bang = true })
  end)
end

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local fzf_lua = require("fzf-lua")
      fzf_lua.register_ui_select()

      local fzf_lua_actions = require("fzf-lua.actions")

      local opts = {}

      opts.winopts = {
        fullscreen = true,
        preview = {
          hidden = "hidden", -- Start with preview hidden, toggle with ?
        },
      }

      opts.git = {
        branches = {
          actions = {
            ["ctrl-a"] = false, -- Disable default ctrl-a binding
            ["ctrl-d"] = {
              fn = fzf_lua_actions.git_branch_del,
              reload = true,
            },
            ["ctrl-b"] = {
              fn = fzf_lua_actions.git_branch_add,
              field_index = "{q}",
              reload = true,
            },
          },
          -- Add branch and switch immediately
          cmd_add = {
            "git",
            "checkout",
            "-b",
          },
        },
      }

      opts.keymap = {
        builtin = {
          ["?"] = "toggle-preview", -- Toggle preview on/off
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept", -- Open all without first selecting anything
        },
      }

      fzf_lua.setup(opts)

      -- Find color schemes
      map_key("n", "<leader>fs", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").colorschemes()
      end, { noremap = true })

      -- Search key mappings - find already mapped before defining new mappings
      map_key("n", "<leader>M", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").keymaps()
      end, { noremap = true, desc = "Find keymaps" })

      -- Find open buffers
      map_key("n", "<Leader>fb", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").buffers()
      end, {
        noremap = true,
      })

      -- Find file from cwd
      map_key("n", "<leader>fW", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").files()
      end, { noremap = true })

      -- Find windows
      map_key("n", "<leader>fw", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").tabs()
      end, { noremap = true })

      -- Search buffers history
      map_key("n", "<Leader>fh", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").oldfiles()
      end, {
        noremap = true,
      })

      -- Search for text in current buffer
      map_key("n", "<Leader>fl", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").grep_curbuf()
      end, {
        noremap = true,
        desc = "",
      })

      -- Search for text in current buffer
      map_key("n", "<Leader>C", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").commands()
      end, {
        noremap = true,
        desc = "",
      })

      map_key("n", "<Leader>/", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        highlight_content_of_register_plus()

        local count = vim.v.count

        if count == 0 then
          require("fzf-lua").live_grep()
          return
        end

        if count == 1 then
          -- Start grep, then ctrl-g to filter over (fuzzy=search) the search results
          -- https://www.reddit.com/r/neovim/comments/1hhiidm/comment/m2rxfhl/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
          require("fzf-lua").grep_project()
          return
        end
      end, { noremap = true })
      -- map_key("n", "<leader>cb", function()
      --   require("fzf-lua").git_branches")
      -- end, {
      --   noremap = true,
      --   desc = "Git branches",
      -- })

      map_key("n", "<leader>czL", function()
        -- utils.set_fzf_lua_nvim_listen_address()
        require("fzf-lua").git_stash()
      end, {
        noremap = true,
        desc = "Git stashes list",
      })

      -- Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.
      map_to_fzf_lua_or_telescope(
        "gO",
        "lsp_document_symbols",
        "[D]ocument [S]ymbols",
        "lsp_document_symbols"
      )

      -- Find references(places where identifiers are used/referenced) for the word under your cursor.
      map_to_fzf_lua_or_telescope(
        "grr",
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

      -- Fuzzy find all the symbols in your current workspace/project. Similar to document symbols, except searches over your entire project.
      map_to_fzf_lua_or_telescope(
        "<leader>ws",
        "lsp_live_workspace_symbols",
        "[W]orkspace [S]ymbols",
        "lsp_dynamic_workspace_symbols"
      )
    end,
  },
}
