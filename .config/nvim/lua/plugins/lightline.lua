-- function LightlineFugitive()
--   -- Check if FugitiveHead function exists
--   if vim.fn.exists('*FugitiveHead') == 1 then
--     local branch = vim.fn.FugitiveHead()
--     return branch ~= '' and branch or ''
--   end
--
--   return ''
-- end

-- Define the function in Lua
-- function LightlineInactiveTabFilename(n)
--   local buflist = vim.fn.tabpagebuflist(n)
--   local winnr = vim.fn.tabpagewinnr(n)
--   local bufnr = buflist[winnr] -- Lua is 1-indexed
--   local filename = vim.fn.expand('#' .. bufnr .. ':f')
--   local shortened_file_path = filename:gsub('\\', '/') -- Substitute backslashes with forward slashes
--
--   -- Call the utility function, assuming it's defined elsewhere in Lua
--   -- Note: This step assumes the existence of 'util.get_file_name' function in Lua
--   return require('utils').get_file_name(shortened_file_path)
-- end

vim.cmd([[
  function! LightlineFugitive()
    if exists('*FugitiveHead')
      let branch = FugitiveHead()
      return branch !=# '' ? branch : ''
    endif
    return ''
  endfunction

  function! LightlineInactiveTabFilename(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let filename = expand('#' . buflist[winnr - 1] . ':f')
    let shortened_file_path = substitute(filename, '\', '/', 'g')
    let lua_func = 'require("utils").get_file_name("' . shortened_file_path . '")'
    return luaeval(lua_func)
  endfunction

  function! LightlineFilename()
    return luaeval('require("utils").get_file_name(2)')
  endfunction
]])

vim.g.lightline = {
  component_function = {
    fugitive = "LightlineFugitive",
    filename = "LightlineFilename",
  },

  component = {
    filename = "%f",
  },

  active = {
    left = {
      { "mode", "paste" },
      {
        "fugitive",
        "readonly",
        "filename",
        "modified",
      },
    },
  },

  tab_component_function = {
    filename_active = "LightlineInactiveTabFilename",
  },

  tab = {
    active = {
      "tabnum",
      "filename",
      "modified",
    },
    inactive = {
      "tabnum",
      "filename_active",
      "modified",
    },
  },
}
