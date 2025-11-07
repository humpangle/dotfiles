vim = vim
local note_type_word_pic = "word pic"
local default_deck = "z-nvim-anki-edit"
return {
  "rareitems/anki.nvim",
  -- lazy -- don't lazy it, it tries to be as lazy possible and it needs to add a filetype association
  opts = {
    {
      -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
      tex_support = false,
      models = {
        -- Here you specify which notetype should be associated with which deck
        -- NoteType = "PathToDeck",
        [note_type_word_pic] = default_deck,
      },
    },
  },
  init = function()
    local utils = require("utils")
    utils.map_key({ "n", "x" }, "<leader>ank", function()
      local anki = require("anki")

      local fzf_lua_opts = {
        {
          description = "Anki New word-pic",
          action = function()
            vim.cmd("tab new")
            vim.bo.filetype = "anki"
            utils.write_to_out_file({
              prefix = "anki",
              ext = "anki",
            })
            anki.ankiWithDeck(
              "z-nvim-anki-edit",
              note_type_word_pic
            )
          end,
          count = 1,
        },
        {
          description = "Anki New Blank",
          action = function()
            -- Get content from current buffer before creating new tab
            local original_buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(original_buf, 0, -1, false)

            vim.cmd("tab new")
            vim.bo.filetype = "anki"
            utils.write_to_out_file({
              prefix = "anki",
              ext = "anki",
            })

            -- Write the copied content to the new buffer
            local new_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
          end,
          count = 11,
        },
        {
          description = "Anki Send Save",
          action = function()
            vim.cmd({ cmd = "w", bang = true })
            vim.schedule(function()
              vim.cmd("AnkiSend")
            end)
          end,
          count = 2,
        },
        {
          description = "Anki Send Save GUI",
          action = function()
            vim.cmd({ cmd = "w", bang = true })
            vim.schedule(function()
              vim.cmd("AnkiSendGui")
            end)
          end,
          count = 3,
        },
      }

      utils.create_fzf_key_maps(fzf_lua_opts, {
        prompt = "Anki Options>  ",
        header = "Select Anki Option",
      })
    end, {
      noremap = true,
      desc = "Anki 0/fzf 1/Send 2/SendGUI",
    })
  end,
}
