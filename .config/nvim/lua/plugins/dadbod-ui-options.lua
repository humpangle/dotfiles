local utils = require("utils")
local load_in_float_api = require("load-in-float-api")

local match_vim_dadbod_ui_temp_query_file = function(str)
  local pattern = "^/tmp/nvim%..+/%d+%.dbout$"
  return string.match(str, pattern) ~= nil
end

local dadbod_ui_options = {
  {
    description = "Initialize Start DBUI                                                                             1",
    action = function()
      vim.cmd("tab new")
      vim.cmd("DBUI")
      vim.cmd("only")
      vim.cmd("vsplit")
      vim.cmd("e ~/.local/share/db_ui/connections.json")
    end,
    count = 1,
  },
  {
    description = "DBUIFindBuffer Connect Start Attach Database                                                     11",
    action = function()
      vim.cmd("DBUIFindBuffer")
      vim.bo.filetype = "sql"
    end,
    count = 11,
  },
  {
    description = "Execute DO query (visual mode: selection, normal mode: paragraph)                                 3",
    action = function()
      if vim.fn.mode() == "n" then
        vim.cmd.normal({ "vip" })
      end

      local keys = vim.api.nvim_replace_termcodes("<Plug>(DBUI_ExecuteQuery)", true, true, true)
      vim.api.nvim_feedkeys(keys, "x", false)
    end,
    count = 3,
  },
  {
    description = "Save result buffer to markdown file                                                              33",
    action = function()
      local buffer_name = vim.fn.expand("%:p")
      if not match_vim_dadbod_ui_temp_query_file(buffer_name) then
        return
      end

      local filename = utils.create_slime_dir()
        .. "/q-"
        .. os.date("%FT%H-%M-%S")
        .. ".md"

      pcall(function()
        vim.cmd("saveas! " .. vim.fn.fnameescape(filename))
      end)

      -- We need to split away otherwise the DbUiDelete below will close the buffer.
      vim.cmd("tab split")

      vim.bo.filetype = "markdown"
      -- The file will be of type 'dbui'. The delete action below will delete all files of this type.
      vim.bo.buftype = ""

      os.execute("rm -rf " .. vim.fn.shellescape(buffer_name))
      vim.cmd("bdelete! " .. buffer_name)
      vim.cmd({ cmd = "wa", bang = true })
      require("buffer-management").delete_all_buffers("dbui")

      -- dbui file is always readonly -  make it modifiable
      vim.bo.modifiable = true
      vim.cmd("e %")

      -- Switch back to the tab we came from (where sql statement was executed)
      vim.cmd.normal("gT")
    end,
    count = 33,
  },
  {
    description = "Format current paragraph as SQL                                                                  31",
    action = function()
      vim.cmd.normal({ "vip" })
      utils.write_to_command_mode("'<,'>Neoformat! sql<CR>")
    end,
    count = 31,
  },
  {
    description = "Write all and delete all DBUI buffers                                                             2",
    action = function()
      vim.cmd({ cmd = "wa", bang = true })
      require("buffer-management").delete_all_buffers("dbui")
    end,
    count = 2,
  },
  {
    description = "DBUIRenameBuffer",
    action = function()
      vim.cmd("DBUIRenameBuffer")
    end,
  },
  {
    description = "DBUILastQueryInfo",
    action = function()
      vim.cmd("DBUILastQueryInfo")
    end,
  },
  {
    description = "DBUI Help Information                                                                            7",
    action = function()
      local lines = {
        "* Help for Vim DadBod UI *",
        "",
        "** Data Source Name (dns) syntax **",
        "postgresql://user1:userpwd@localhost:5432/testdb",
        "mysql://user1:userpwd@127.0.0.1:3306/testdb",
        "sqlite:path-to-sqlite-database",
        "",
        "** Settings file **",
        "~/.local/share/db_ui/connections.json",
        "```json",
        "[",
        "  {",
        '    "url": "postgresql://username:password@127.0.0.1:5432/db_name",',
        '    "name": "folder_name"',
        "  }",
        "]",
        "```",
        "** folder_name is the `name` key in the Settings object **",
        "",
        "~/.local/share/db_ui/folder_name/*.sql",
        "~/.local/share/db_ui",
      }
      local filepath = utils.write_to_out_file({
        additional_directory_path = "my-neovim-status",
        prefix = "vim-dadbod-ui-help",
        ext = "log",
        just_create = true,
      })
      vim.fn.writefile(lines, filepath)
      load_in_float_api.load_in_float(filepath, {
        width = 0.75,
        height = 0.75,
        border = "rounded",
        check_autocmd = true,
      })
    end,
    count = 7,
  },
}

return dadbod_ui_options
