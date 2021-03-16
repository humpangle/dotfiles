lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { -- list of language that will be disabled
      "c",
      "c_sharp",
      "clojure",
      "cpp",
      "dart",
      "devicetree",
      "elm",
      "erlang",
      "fennel",
      "Godot",
      "Glimmer",
      "go",
      "haskell",
      "java",
      "julia",
      "kotlin",
      "ledger",
      "nix",
      "ocaml",
      "ocaml_interface",
      "ocamllex",
      "php",
      "ql",
      "rst",
      "ruby",
      "rust",
      "scala",
      "sparql",
      "supercollider",
      "swift",
      "teal",
      "turtle",
      "verilog",
    },
  },
}
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
