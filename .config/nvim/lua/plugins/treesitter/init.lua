-- Highlight, edit, and navigate code
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.treesitter() then
  return {}
end

local map_key = require("utils").map_key

local function select_markdown_region(send_to_slime)
  -- Only work in markdown files
  -- if vim.bo.filetype ~= "markdown" then
  --   return
  -- end

  local query_string =
    '((inline) @delimiter (#match? @delimiter "^[ ]*#=[=]{79,}[ ]*$"))'
  local parser = require("nvim-treesitter.parsers").get_parser()
  local ok, query =
    pcall(vim.treesitter.query.parse, parser:lang(), query_string)
  if not ok then
    return
  end

  local tree = parser:parse()[1]
  local delimiter_lines = {}

  -- Collect all delimiter line numbers
  for _, node in query:iter_captures(tree:root(), 0) do
    local start_row, _, _, _ = node:range()
    table.insert(delimiter_lines, start_row + 1) -- Convert to 1-based line number
  end

  -- Sort delimiter lines
  table.sort(delimiter_lines)

  -- Get current cursor line
  local cursor_line = vim.fn.line(".")

  -- Find delimiters before and after cursor
  local delimiter_before = nil
  local delimiter_after = nil

  for _, line_num in ipairs(delimiter_lines) do
    if line_num < cursor_line then
      delimiter_before = line_num
    elseif line_num > cursor_line then
      delimiter_after = delimiter_after or line_num
    elseif line_num == cursor_line then
      -- Cursor is on a delimiter line
      -- Treat it as if cursor is just before this delimiter
      delimiter_after = line_num
    end
  end

  local start_line, end_line

  -- Determine region type and set selection bounds
  if not delimiter_before and delimiter_after then
    -- Type 1: No delimiter before, delimiter after (exclude delimiter)
    start_line = 1
    end_line = delimiter_after - 1
  elseif delimiter_before and delimiter_after then
    -- Type 2: Delimiter before and after (exclude both delimiters)
    start_line = delimiter_before + 1
    end_line = delimiter_after - 1
  elseif delimiter_before and not delimiter_after then
    -- Type 3: Delimiter before, no delimiter after (exclude delimiter)
    start_line = delimiter_before + 1
    end_line = vim.fn.line("$")
  else
    -- Type 4: No delimiters around cursor - select current paragraph
    -- Find empty lines before and after cursor
    start_line = cursor_line
    end_line = cursor_line

    -- Search backward for empty line or beginning of file
    while start_line > 1 do
      if vim.fn.getline(start_line - 1):match("^%s*$") then
        break
      end
      start_line = start_line - 1
    end

    -- Search forward for empty line or end of file
    local last_line = vim.fn.line("$")
    while end_line < last_line do
      if vim.fn.getline(end_line + 1):match("^%s*$") then
        break
      end
      end_line = end_line + 1
    end
  end

  -- Trim leading empty lines
  while
    start_line <= end_line and vim.fn.getline(start_line):match("^%s*$")
  do
    start_line = start_line + 1
  end

  -- Trim trailing empty lines
  while end_line >= start_line and vim.fn.getline(end_line):match("^%s*$") do
    end_line = end_line - 1
  end

  -- Only process if we have valid content
  if start_line > end_line then
    return
  end

  -- Yank to system clipboard
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, "\n")
  vim.fn.setreg("+", text)
  vim.notify(#lines .. " lines yanked to system clipboard")

  -- Select the region visually
  vim.cmd("normal! " .. start_line .. "G")
  vim.cmd("normal! V")
  vim.cmd("normal! " .. end_line .. "G")

  -- If send_to_slime is true, trigger vim-slime to send the selection
  if send_to_slime and vim.fn.exists(":SlimeSend") == 2 then
    local term_keys = vim.api.nvim_replace_termcodes(
      "<Plug>SlimeRegionSend",
      true,
      true,
      true
    )
    vim.api.nvim_feedkeys(
      term_keys,
      "m", -- "m" => allow remapping so <Plug> expands
      true -- third arg (true) => do not escape CSI
    )
    vim.notify(#lines .. "lines sent to slime")
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      require("plugins/treesitter-textobjects"),

      -- https://github.com/LiadOz/nvim-dap-repl-highlights/issues/12
      plugin_enabled.dap()
          and {
            "LiadOz/nvim-dap-repl-highlights",
          }
        or {},
    },

    build = ":TSUpdate",
    init = function()
      map_key("n", "<localleader><localleader>", function()
        local count = vim.v.count
        -- If count == 0, send to slime; otherwise just select and yank
        select_markdown_region(count == 0)
      end, {
        desc = "Select markdown region based on #=== delimiters (with count: send to slime)",
      })
    end,
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      local ensure_installed = {
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
        "jsonc", -- required by "folke/neoconf.nvim"
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
      }

      if plugin_enabled.dap() then
        require("nvim-dap-repl-highlights").setup() -- must be setup before nvim-treesitter
        table.insert(ensure_installed, "dap_repl")
      end

      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
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
        ensure_installed = ensure_installed,
        -- Autoinstall languages that are not installed
        auto_install = true,
        indent = {
          enable = true,
          disable = {
            "ruby",
          },
        },
      })

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
    config = function()
      local tsc = require("treesitter-context")
      tsc.setup({
        max_lines = 2,
      })
    end,
  },
}
