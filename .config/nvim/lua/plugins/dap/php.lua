local dap = require("dap")

-- This is the executable that the vscode-php-debug extension provides
dap.adapters.php = {
  type = "executable",
  -- command = vim.fn.stdpath('data') .. "/mason/bin/php-debug-adapter",
  command = vim.fn.exepath("php-debug-adapter"), -- same as above
  -- args = {
  --   "/some-path/vscode-php-debug/out/phpDebug.js",
  -- },
}
