-- Taken from -- https://github.com/StevanFreeborn/nvim-config
-- https://www.youtube.com/watch?v=DVG3m7rNFKc

local dap = require("dap")

local get_user_input = function(opts)
  return function()
    opts = vim.tbl_extend("keep", opts or {}, {
      prompt = "Enter URL: ",
      default = "http://localhost:",
    })
    local co = coroutine.running()
    return coroutine.create(function()
      vim.ui.input(opts, function(userInput)
        if userInput == nil or userInput == "" then
          return
        else
          coroutine.resume(co, userInput)
        end
      end)
    end)
  end
end

for _, adapter_type in ipairs({
  "node",
  "chrome",
  "msedge",
}) do
  local pwa_type = "pwa-" .. adapter_type
  dap.adapters[pwa_type] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }

  -- This allows us to handle launch.json configurations which specify type as "node" or "chrome" or "msedge" instead
  -- of pwa-node/pwa-chrome etc
  dap.adapters[adapter_type] = function(cb, config)
    local native_adapter = dap.adapters[pwa_type]
    config.type = pwa_type
    if type(native_adapter) == "function" then
      native_adapter(cb, config)
    else
      cb(native_adapter)
    end
  end
end

local sourceMapPathOverrides = {

  -- webpack-internal:// from your screenshot
  ["webpack-internal:///src/*"] = "${workspaceFolder}/src/*",
  ["webpack-internal:///./src/*"] = "${workspaceFolder}/src/*",
  ["webpack-internal:///*"] = "${workspaceFolder}/*",

  -- Webpack-style paths
  ["webpack:///src/*"] = "${workspaceFolder}/src/*",
  ["webpack:///./src/*"] = "${workspaceFolder}/src/*",
  ["webpack:///./*"] = "${workspaceFolder}/*",
  ["webpack:///*"] = "${workspaceFolder}/*",

  ["webpack://alayacare/accloud-mfe-scheduling/src/*"] = "${workspaceFolder}/src/*",
  ["webpack://alayacare/accloud-mfe-scheduling/*"] = "${workspaceFolder}/*",

  -- Docker path inside container -> host path
  ["/app/*"] = "${workspaceFolder}/*",

  -- Some Vue setups use "vite:///" or similar; harmless if unused
  ["vite:///*"] = "${workspaceFolder}/*",
}
-- sourceMapPathOverrides = {
--   ["*webpack://**/src"] = "${workspaceFolder/src}",
-- }

for _, language in ipairs({
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}) do
  dap.configurations[language] = {
    {
      name = "Launch file using Node.js (nvim-dap) Launch",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      name = "Attach to process using Node.js (nvim-dap) Attach",
      type = "pwa-node",
      request = "attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    -- requires ts-node to be installed globally or locally
    {
      name = "Launch file Node.js file ts-node/register (nvim-dap)",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeArgs = { "-r", "ts-node/register" },
    },
    {
      name = "Launch Edge (nvim-dap) Launch",
      type = "pwa-msedge",
      request = "launch",
      url = get_user_input(),
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      name = "Launch Chrome (nvim-dap) Launch",
      type = "pwa-chrome",
      request = "launch",
      url = get_user_input(),
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      -- optional nice-to-haves:
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      skipFiles = {
        "<node_internals>/**",
        "${workspaceFolder}/node_modules/**",
      },
    },
    {
      name = "Attach Chrome Attach (nvim-dap)",
      type = "pwa-chrome",
      request = "attach",
      port = get_user_input({
        prompt = "Enter port: ",
        default = "9222",
      }),
      webRoot = "${workspaceFolder}",
      -- urlFilter = "http://localhost/some-url-path",
      sourceMaps = true,
      -- smartStep = true, -- auto-step through transpiled helper code
      -- optional nice-to-haves:
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },

      -- 🔑 Map paths from sourcemaps -> real files on disk
      sourceMapPathOverrides = sourceMapPathOverrides,

      skipFiles = {
        "<node_internals>/**",
        "**/node_modules/**",
        "**/old_app*",
        "**/*.esm-bundler*",
        "chrome-extension*",
        "**/559.js",
        "**/dist/**",

        -- -- The concrete files to be skipped
        -- "webpack://*/runtime-core.esm-bundler.js",
        -- "webpack://*/reactivity.esm-bundler.js",
        -- "webpack-internal://*/shared.esm-bundler.js",
      },
    },

    {
      name = "Chrome: scheduling-mfe (launch)",
      type = "pwa-chrome",
      request = "launch",

      -- Your Vue app URL
      url = "http://alayadev.localhost/scheduling-mfe",

      -- Project root (make sure :pwd in nvim is this dir)
      webRoot = "${workspaceFolder}",

      -- Tell js-debug which Chrome to use (Linux)
      runtimeExecutable = "/usr/bin/google-chrome",

      -- Equivalent of your --user-data-dir arg
      userDataDir = "/tmp/chrome-nvim-dap-debug",

      -- Sourcemap goodies
      sourceMaps = true,
      smartStep = true,

      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },

      -- 🔑 Make .vue SFCs & Docker paths map correctly
      sourceMapPathOverrides = sourceMapPathOverrides,

      skipFiles = {
        "<node_internals>/**",
        "${workspaceFolder}/node_modules/**",
      },
    },
  }
end
