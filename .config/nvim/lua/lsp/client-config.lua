local servers_names_map_module = require("lsp.server-names-to-flags-map")
local servers_names_map = servers_names_map_module.servers_names_map

local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(
			sign.name,
			{ texthl = sign.name, text = sign.text, numhl = "" }
		)
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = "rounded" }
	)

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded" }
	)
end

function M.show_line_diagnostics()
	local opts = {
		focusable = false,
		close_events = {
			"BufLeave",
			"CursorMoved",
			"InsertEnter",
			"FocusLost",
		},
		border = "rounded",
		source = "always", -- show source in diagnostic popup window
		prefix = " ",
	}

	vim.diagnostic.open_float(nil, opts)
end

local function lsp_highlight_document(client)
	-- The below command will highlight the current variable and its usages in the buffer.
	-- https://github.com/jdhao/nvim-config/blob/master/lua/config/lsp.lua
	if client.resolved_capabilities.document_highlight then
		vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual

      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
	end
end

local keymap_opts = { noremap = true, silent = false }
M.keymap_opts = keymap_opts

vim.api.nvim_set_keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", keymap_opts)

-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>f",
-- 	"<cmd>lua vim.diagnostic.open_float()<CR>",
-- keymap_opts
-- )

vim.api.nvim_set_keymap(
	"n",
	"[d",
	[[<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>]],
	keymap_opts
)

vim.api.nvim_set_keymap(
	"n",
	"]d",
	'<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>',
	keymap_opts
)

-- Open diagnostics in quicklist window
vim.api.nvim_set_keymap(
	"n",
	"<C-N>",
	"<cmd>lua vim.diagnostic.setloclist()<CR>",
	keymap_opts
)

local function lsp_keymaps(bufnr)
	-- Formatting with `prettier*` is slow, hence the large timeout
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/572#issuecomment-1011172497
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>fc",
		"<cmd>lua vim.lsp.buf.formatting_sync(nil, 5000000)<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"x",
		"<leader>fc",
		"<cmd>lua vim.lsp.buf.formatting_sync(nil, 5000000)<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gD",
		"<cmd>lua vim.lsp.buf.declaration()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gd",
		"<cmd>lua vim.lsp.buf.definition()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gi",
		"<cmd>lua vim.lsp.buf.implementation()<CR>",
		keymap_opts
	)

	-- find symbols in current buffer
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>bt",
		"<cmd>lua vim.lsp.buf.document_symbol()<CR>",
		keymap_opts
	)

	-- find symbols project wide
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>pt",
		"<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
		keymap_opts
	)

	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gl",
	--                             [[<cmd>lua vim.diagnostic.goto_next({ float =  { border = "single" }})<CR>]],
	--                             opts)

	-- show line diagnostics on hover
	vim.cmd([[
      autocmd CursorHold <buffer> lua require('lsp.client-config').show_line_diagnostics()
  ]])

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gr",
		"<cmd>lua vim.lsp.buf.references()<CR>",
		keymap_opts
	)

	-- Show documentation
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"K",
		"<cmd>lua vim.lsp.buf.hover()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<C-k>",
		"<cmd>lua vim.lsp.buf.signature_help()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>rn",
		"<cmd>lua vim.lsp.buf.rename()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		",ac",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		keymap_opts
	)

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"x",
		",ac",
		"<cmd>lua vim.lsp.buf.code_action()<CR>",
		keymap_opts
	)

	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

M.on_attach = function(client, bufnr)
	local server_config = servers_names_map[client.name]

	if server_config.no_formatting then
		client.resolved_capabilities.document_formatting = false
	end

	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

-- Let `cmp_nvim_lsp` show completions

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
