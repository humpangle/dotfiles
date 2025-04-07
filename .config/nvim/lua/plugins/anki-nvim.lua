local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.anki() then
  return {}
end

return {
  "rareitems/anki.nvim",
  -- lazy -- don't lazy it, it tries to be as lazy possible and it needs to add a filetype association
  opts = {
    {
      -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
      tex_support = false,
      models = {
        -- Here you specify which notetype should be associated with which deck
        ["word pic"] = "!0::2024-12-25T21-14-44---list",
      },
    },
  },
}
