local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.sql_ls() then
  return {}
end

return {
  ["sql-formatter"] = {},

  sqls = {
    filetypes = {
      "sql",
      "mysql",
    },
  },
}
