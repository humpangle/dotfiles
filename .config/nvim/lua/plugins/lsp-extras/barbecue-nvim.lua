-- Display LSP-based breadcrumbs
return {
  -- https://github.com/utilyre/barbecue.nvim
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    -- https://github.com/SmiteshP/nvim-navic
    "SmiteshP/nvim-navic",
    -- https://github.com/nvim-tree/nvim-web-devicons
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  opts = {
    attach_navic = false, -- We'll manually attach navic to avoid conflicting lsp clients/servers
  },
  config = function(_, opts)
    require("barbecue").setup(opts)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("barbecue-navic-attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
          return
        end

        local excludes = {
          vue_ls = true, -- conflicts with vtsls
          -- ts_ls = true, -- if you have vtsls clashing with ts_ls
        }

        if excludes[client.name] then
          return
        end

        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, args.buf)
        end
      end,
    })
  end,
}
