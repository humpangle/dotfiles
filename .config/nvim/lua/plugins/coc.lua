local plugin_enabled = require("plugins/plugin_enabled")

return {
  "neoclide/coc.nvim",
  branch = "master",
  build = "npm ci",
  enabled = plugin_enabled.coc(),
  config = function()
    local utils = require("utils")

    -- Some servers have issues with backup files, see #649
    vim.opt.backup = false
    vim.opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    vim.opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    vim.opt.signcolumn = "yes"

    vim.g.coc_filetype_map = {
      [".eslintrc"] = "json",
      eelixir = "html",
      ["yaml.ansible"] = "ansible",
    }

    -- Autocomplete
    function _G.check_back_space()
      local col = vim.fn.col(".") - 1
      return col == 0
        or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end

    local options_fn = function(desc, opts)
      desc = desc or ""
      desc = "COC " .. desc

      if opts ~= nil then
        opts = vim.deepcopy(opts)
        opts.desc = desc
        return opts
      end

      return {
        silent = true,
        noremap = true,
        expr = true,
        replace_keycodes = false,
        desc = desc,
      }
    end

    -- Use Tab for trigger completion with characters ahead and navigate
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    -- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
    -- other plugins before putting this into your config
    utils.map_key(
      "i",
      "<TAB>",
      'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
      options_fn("Navigate completion")
    )

    utils.map_key(
      "i",
      "<S-TAB>",
      [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
      options_fn("Navigate completion")
    )

    -- Make <CR> to accept selected completion item or notify coc.nvim to format
    -- <C-g>u breaks current undo, please make your own choice
    utils.map_key(
      "i",
      "<cr>",
      [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
      options_fn("Accept selected completion")
    )

    -- Use <c-j> to trigger snippets
    utils.map_key("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
    -- Use <c-space> to trigger completion
    utils.map_key(
      "i",
      "<c-space>",
      "coc#refresh()",
      { silent = true, expr = true, desc = "COC Trigger snippets" }
    )

    -- Use `[d` and `]d` to navigate diagnostics
    -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    utils.map_key(
      "n",
      "[d",
      "<Plug>(coc-diagnostic-prev)",
      { silent = true, desc = "COC Go to previous diagnostics" }
    )

    utils.map_key(
      "n",
      "]d",
      "<Plug>(coc-diagnostic-next)",
      { silent = true, desc = "COC Go to next diagnostics" }
    )

    -- GoTo code navigation
    utils.map_key("n", "gd", "<Plug>(coc-definition)", { silent = true })

    utils.map_key(
      "n",
      "gy",
      "<Plug>(coc-type-definition)",
      { silent = true }
    )

    utils.map_key(
      "n",
      "gi",
      "<Plug>(coc-implementation)",
      { silent = true }
    )

    utils.map_key("n", "gr", "<Plug>(coc-references)", { silent = true })

    -- Use K to show documentation in preview window
    function _G.show_docs()
      local cw = vim.fn.expand("<cword>")
      if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command("h " .. cw)
      elseif vim.api.nvim_eval("coc#rpc#ready()") then
        vim.fn.CocActionAsync("doHover")
      else
        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
      end
    end
    utils.map_key(
      "n",
      "K",
      "<CMD>lua _G.show_docs()<CR>",
      { silent = true }
    )

    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "COC Highlight symbol under cursor on CursorHold",
    })

    -- Symbol renaming
    utils.map_key(
      "n",
      "<leader>rn",
      "<Plug>(coc-rename)",
      { silent = true, desc = "COC Rename variable" }
    )

    -- Formatting selected code
    utils.map_key(
      { "n", "x" },
      "<leader>fc",
      "<Plug>(coc-format-selected)",
      { desc = "COC Format code" }
    )

    -- Setup formatexpr specified filetype(s)
    vim.api.nvim_create_autocmd("FileType", {
      group = "CocGroup",
      pattern = "typescript,json",
      command = "setl formatexpr=CocAction('formatSelected')",
      desc = "COC Setup formatexpr specified filetype(s).",
    })

    -- Update signature help on jump placeholder
    vim.api.nvim_create_autocmd("User", {
      group = "CocGroup",
      pattern = "CocJumpPlaceholder",
      command = "call CocActionAsync('showSignatureHelp')",
      desc = "COC Update signature help on jump placeholder",
    })

    local opts = { silent = true, nowait = true }

    utils.map_key(
      { "n", "x" },
      "<leader>ac",
      "<Plug>(coc-codeaction-selected)",
      options_fn(
        "code action selected region e.g. acap, acip for current paragraph",
        opts
      )
    )

    utils.map_key(
      "n",
      "<leader>ca",
      "<Plug>(coc-codeaction-cursor)",
      options_fn("code action for line under cursor", opts)
    )

    utils.map_key(
      "n",
      "<leader>as",
      "<Plug>(coc-codeaction-source)",
      options_fn("code action for source current file", opts)
    )

    -- Apply the most preferred quickfix action on the current line.
    utils.map_key(
      "n",
      "<leader>qf",
      "<Plug>(coc-fix-current)",
      options_fn("apply quickfix action to current line", opts)
    )

    -- Remap keys to apply refactor code actions.
    utils.map_key(
      "n",
      "<leader>re",
      "<Plug>(coc-codeaction-refactor)",
      { silent = true, desc = "COC code action refactor" }
    )

    utils.map_key(
      { "x", "n" },
      "<leader>r",
      "<Plug>(coc-codeaction-refactor-selected)",
      { silent = true, desc = "COC code action refactor selected" }
    )

    -- Run the Code Lens actions on the current line
    utils.map_key("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

    -- Map function and class text objects
    -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
    utils.map_key(
      { "x", "o" },
      "if",
      "<Plug>(coc-funcobj-i)",
      options_fn("inside function text object", opts)
    )

    utils.map_key(
      { "x", "o" },
      "af",
      "<Plug>(coc-funcobj-a)",
      options_fn("around function text object", opts)
    )

    utils.map_key(
      { "x", "o" },
      "ic",
      "<Plug>(coc-classobj-i)",
      options_fn("inside class text object", opts)
    )

    utils.map_key(
      { "x", "o" },
      "ac",
      "<Plug>(coc-classobj-a)",
      options_fn("around class text object", opts)
    )

    -- Remap <C-f> and <C-b> to scroll float windows/popups
    ---@diagnostic disable-next-line: redefined-local
    opts = { silent = true, nowait = true, expr = true }

    utils.map_key(
      "n",
      "<C-f>",
      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
      options_fn("", opts)
    )

    utils.map_key(
      "n",
      "<C-b>",
      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
      options_fn("", opts)
    )

    utils.map_key(
      "i",
      "<C-f>",
      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
      options_fn("", opts)
    )

    utils.map_key(
      "i",
      "<C-b>",
      'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
      options_fn("", opts)
    )

    utils.map_key(
      "v",
      "<C-f>",
      'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
      options_fn("", opts)
    )

    utils.map_key(
      "v",
      "<C-b>",
      'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
      options_fn("", opts)
    )

    -- Use CTRL-S for selections ranges
    -- Requires 'textDocument/selectionRange' support of language server
    utils.map_key(
      { "n", "x" },
      "<C-s>",
      "<Plug>(coc-range-select)",
      { silent = true, desc = "COC select ranges" }
    )

    -- Add `:Format` command to format current buffer
    vim.api.nvim_create_user_command(
      "Format",
      "call CocAction('format')",
      {}
    )

    -- " Add `:Fold` command to fold current buffer
    vim.api.nvim_create_user_command(
      "Fold",
      "call CocAction('fold', <f-args>)",
      { nargs = "?" }
    )

    -- Add `:OR` command for organize imports of the current buffer
    vim.api.nvim_create_user_command(
      "OR",
      "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
      {}
    )

    -- Add (Neo)Vim's native statusline support
    -- NOTE: Please see `:h coc-status` for integrations with external plugins that
    -- provide custom statusline: lightline.vim, vim-airline
    vim.opt.statusline:prepend(
      "%{coc#status()}%{get(b:,'coc_current_function','')}"
    )

    -- Mappings for CoCList
    -- code actions and coc stuff
    ---@diagnostic disable-next-line: redefined-local
    opts = { silent = true, nowait = true }

    utils.map_key(
      "n",
      "<Leader>sd",
      ":<C-u>CocList diagnostics<cr>",
      options_fn("search diagnostics", opts)
    )

    utils.map_key(
      "n",
      "<c-x>",
      ":<C-u>CocList extensions<cr>",
      options_fn("manage extensions", opts)
    )

    utils.map_key(
      "n",
      "<Leader>cc",
      ":<C-u>CocList commands<cr>",
      options_fn("show commands", opts)
    )

    utils.map_key(
      "n",
      "<Leader>bs",
      ":<C-u>CocList outline<cr>",
      options_fn("buffer symbols", opts)
    )

    utils.map_key(
      "n",
      "<Leader>ws",
      ":<C-u>CocList -I symbols<cr>",
      options_fn("workspace symbols", opts)
    )

    utils.map_key(
      "n",
      "<Leader>j",
      ":<C-u>CocNext<cr>",
      options_fn("do default action for next item", opts)
    )

    utils.map_key(
      "n",
      "<Leader>k",
      ":<C-u>CocPrev<cr>",
      options_fn("do default action for next item", opts)
    )

    utils.map_key(
      "n",
      "<Leader>p",
      ":<C-u>CocListResume<cr>",
      options_fn("resume latest coc list", opts)
    )

    -- 'coc-flutter-tools',
    -- 'coc-yank',
    -- 'coc-vetur',
    -- 'coc-emoji',
    -- 'coc-lists',
    -- 'coc-tasks',
    -- 'coc-fzf-preview',
    -- 'coc-marketplace',
    -- 'coc-explorer',
    -- "https://github.com/rodrigore/coc-tailwind-intellisense",

    local coc_extensions = {
      "coc-htmldjango",
      "coc-pyright",
      "coc-elixir",
      "coc-spell-checker",
      "coc-json",
      "coc-jedi",
      "coc-emmet",
      "coc-tsserver",
      "coc-snippets",
      "coc-css",
      "coc-html",
      "coc-eslint",
      "coc-pairs",
      "coc-prettier",
      -- "coc-svelte",
      "https://github.com/humpangle/coc-docker",
      -- "coc-docker",
      "coc-svg",
      "coc-vimlsp",
      "coc-sumneko-lua",
      -- "coc-lua",
      "@yaegassy/coc-intelephense",
      "@yaegassy/coc-volar",
      "coc-blade",
      -- "coc-flutter",
      -- Database auto completion powered by vim-dadbod
      "coc-db",
      -- "coc-java",
      -- "coc-kotlin",
      -- "@yaegassy/coc-tailwindcss3"
      "coc-php-cs-fixer",
      "@yaegassy/coc-nginx",
      "coc-cspell-dicts",
      "@yaegassy/coc-ansible",
    }

    if vim.fn.has("win32") == 1 then
      table.insert(coc_extensions, "coc-powershell")
    else
      table.insert(coc_extensions, "coc-sh")
    end

    vim.g.coc_global_extensions = coc_extensions
  end,

  dependencies = {
    { "neoclide/jsonc.vim" },

    -- Laravel blade
    {
      "jwalton512/vim-blade",
    },

    {
      "kristijanhusak/vim-dadbod-completion",
      -- enabled = false, -- favor sqls
    },

    -- Laravel
    {
      "noahfrederick/vim-laravel",
      enabled = true,
      dependencies = {
        "noahfrederick/vim-composer",
        "tpope/vim-projectionist",
        "tpope/vim-dispatch",
      },
    },
  },
}
