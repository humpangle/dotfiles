local utils = require("utils")
local map_key = utils.map_key

-- -- Global debugging variables
-- vim.g.neoformat_verbose = 1
-- vim.g.neoformat_only_msg_on_error = 1

local do_format = function()
  -- Reset verbosity in case we already increased verbosity in an earlier call.
  vim.g.neoformat_verbose = 0

  local count = vim.v.count
  local mode = vim.fn.mode()

  if count == 1 then
    if mode == "n" then
      vim.cmd.normal({ "vip" })
    end

    utils.write_to_command_mode("'<,'>Neoformat! ")
    return
  end

  if count ~= 0 then
    vim.g.neoformat_verbose = 1
  end

  vim.cmd("Neoformat")
  -- Neoformat converts spaces to tabs - we retab to force spaces
  vim.cmd({ cmd = "retab", bang = true })
  -- Neoformat marks the buffer as dirty - save the biffer
  -- vim.cmd("silent w")
end

map_key(
  "n",
  "<leader>Nn",
  do_format,
  { noremap = true, desc = "Neoformat 1/visual-select-choose-formatter" }
)

map_key(
  "v",
  "<leader>Nn",
  do_format,
  { noremap = true, desc = "Neoformat 1/visual-select-choose-formatter" }
)

-- [[ Install binaries for formatting ]]
--
-- javascript, typescript, svelte, graphql, Vue, html, YAML, SCSS, Less, JSON,
-- npm install -g prettier prettier-plugin-svelte

-- shell
-- curl -o $HOME/.local/bin/shfmt https://github.com/mvdan/sh/releases/download/v3.4.0/shfmt_v3.4.0_linux_amd64 && chmod ugo+x $HOME/.local/bin/shfmt

-- sql
-- curl -o pgFormatter-5.0.tar.gz \
--   https://github.com/darold/pgFormatter/archive/refs/tags/v5.0.tar.gz && \
--   tar xzf pgFormatter-5.0.tar.gz && \
--   cd pgFormatter-5.0/ && \
--   perl Makefile.PL && \
--   make && sudo make install && \
--   pg_format --version

-- SETTINGS
-- Shell
vim.g.shfmt_opt = "-ci"

-- jsonc
vim.g.neoformat_jsonc_prettier = {
  ["exe"] = "prettier",

  ["args"] = {
    "--stdin-filepath",
    '"%:p"',
    "--parser",
    "json",
  },

  ["stdin"] = 1,
}

vim.g.neoformat_enabled_jsonc = {
  "prettier",
}

vim.g.neoformat_enabled_python = {
  "black",
  "autopep8",
}

vim.g.neoformat_heex_mixformatheex = {
  exe = "mix",

  args = {
    "format",
    '--stdin-filename="%:t"',
    "-",
  },

  stdin = 1,
}

vim.g.neoformat_enabled_heex = {
  "mixformatheex",
}

-- vim.g.neoformat_enabled_php = {
--  "php-cs-fixer",
-- }

-- format on save
-- vim.cmd([[
--   augroup fmt
--     autocmd!
--     " if file not changed and saved (e.g. to trigger test run), error is thrown: use try/catch to suppress
--     au BufWritePre * try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
--   a
-- ]])
