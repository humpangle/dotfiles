local utils = require("utils")
local plenary_path = require("plenary.path")
local load_in_float = require("load-in-float-api").load_in_float

local function find_file_path(path)
  if vim.fn.glob(path) ~= "" then
    return path
  else
    local found = plenary_path:find_upwards(path)
    return found and found.filename
  end
end

local fzf_options = {}
local files_fzf_options = {
  {
    description = "chat ebnis chat",
    path = ".claude.ebnis.chat.md",
    count = 11,
    count2 = 0,
  },
  {
    description = "s1.md",
    path = ".___scratch/s1.md",
  },
  {
    description = "t.log",
    path = ".___scratch/t.log",
    opts = {
      check_autocmd = true,
    },
  },
  {
    description = "todos global",
    path = ".___scratch/z/todos-global/todos-global.md",
  },
  {
    description = "checklist",
    path = ".___scratch/z/todos-global/checklist.md",
  },
  {
    description = "sz",
    path = ".___scratch/z/sz.md",
  },
  {
    description = "Slack",
    path = ".___scratch/z/todos-global/slack.md",
  },
}

for _, file in ipairs(files_fzf_options) do
  local file_path = find_file_path(file.path)
  if not file_path then
    vim.print("File not found: " .. file.path)
    goto continue
  end

  -- 50% height option
  local description_count_50 = file.count2
      and string.rep(" ", 95 - #file.description) .. file.count2
    or ""

  table.insert(fzf_options, {
    description = file.description .. " 50%" .. description_count_50,
    action = function()
      load_in_float(
        file_path,
        vim.tbl_extend("keep", file.opts or {}, { height = 0.5 })
      )
    end,
    count = file.count2,
  })

  -- Full height option
  local description_count = file.count
      and string.rep(" ", 95 - #file.description) .. file.count
    or ""

  table.insert(fzf_options, {
    -- ' z ' to make 50% version come up first in search
    description = file.description .. " z " .. description_count,
    action = function()
      load_in_float(
        file_path,
        vim.tbl_extend(
          "keep",
          file.opts or {},
          { cursor_at_end = false }
        )
      )
    end,
    count = file.count,
  })

  ::continue::
end

table.insert(fzf_options, {
  description = "Rename File",
  action = function()
    utils.RenameFile()
  end,
})

utils.map_key({"n", "x"}, "<leader>bb", function()
  utils.create_fzf_key_maps(fzf_options, {
    prompt = "Edit In Float",
    header = "Select an Edit In Float Option",
  })
end, { noremap = true, desc = "EditFloat quick actions <leader>bn" })

-- :EditFloat {file?}
vim.api.nvim_create_user_command("EditFloat", function(opts)
  load_in_float(opts.args ~= "" and opts.args or nil, {})
end, { nargs = "?", complete = "file" })
