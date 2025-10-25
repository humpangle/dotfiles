---@diagnostic disable: missing-fields
return {
  "3rd/image.nvim",
  -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  -- Instead use::
  --
  -- sudo apt install luajit luarocks libmagickwand-dev libgraphicsmagick1-dev
  -- brew install luajit
  -- asdf install lua 5.1
  -- asdf global lua 5.1
  -- luarocks install magick
  --
  build = false,
  config = function()
    require("image").setup({
      -- sudo apt install libsixel-bin
      -- https://software.opensuse.org/download.html?project=home%3Ajustkidding&package=ueberzugpp
      backend = "kitty", -- ueberzug, sixel
      processor = "magick_rock", -- or "magick_cli"
    })
  end,

  dependencies = {
    "leafo/magick",
  },
}
