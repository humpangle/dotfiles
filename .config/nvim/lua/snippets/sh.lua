local ls       = require("luasnip")
local s        = ls.snippet
local i        = ls.insert_node
local fmt      = require("luasnip.extras.fmt").fmt

local snippets = {}

table.insert(snippets, s(
  {
    trig = "bash",
    dscr = [[Option 1: #!/bin/bash
Description: Shebang Bash executor.

Option 2: #!/usr/bin/env bash
Description: Shell searches for the first match of bash in the $PATH environment variable.
It can be useful if you aren't aware of the absolute path or don't want to search for it]]
  },
  fmt([[
      #!/usr/bin/env bash
      # shellcheck disable={}
      {}
    ]], {
    i(1),
    i(0),
  }),
  {
    condition = function()
      return vim.fn.line(".") == 1 and vim.fn.col(".") == 1
    end
  }
)
)

return snippets
