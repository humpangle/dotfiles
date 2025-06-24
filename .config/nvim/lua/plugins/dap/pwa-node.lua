-- Taken from https://banjocode.com/post/nvim/debug-node

local dap = require("dap")
local utils = require("utils")

local function pick_script()
  local pilot = require("package-pilot")

  local current_dir = vim.fn.getcwd()
  local package = pilot.find_package_file({ dir = current_dir })

  if not package then
    vim.notify("No package.json found", vim.log.levels.ERROR)
    return require("dap").ABORT
  end

  local scripts = pilot.get_all_scripts(package)

  local label_fn = function(script)
    return script
  end

  local co, ismain = coroutine.running()
  local ui = require("dap.ui")
  local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
  local result = pick(scripts, "Select script", label_fn)
  return result or require("dap").ABORT
end

if not dap.adapters["pwa-node"] then
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        utils.mason_install_path
          .. "/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
end

if not dap.adapters["node"] then
  dap.adapters["node"] = function(cb, config)
    if config.type == "node" then
      config.type = "pwa-node"
    end
    local pwa_node_adapter = dap.adapters["pwa-node"]
    if type(pwa_node_adapter) == "function" then
      pwa_node_adapter(cb, config)
    else
      cb(pwa_node_adapter)
    end
  end
end

local js_filetypes = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

local vscode = require("dap.ext.vscode")
vscode.type_to_filetypes["node"] = js_filetypes
vscode.type_to_filetypes["pwa-node"] = js_filetypes

local current_file = vim.fn.expand("%:t")
for _, language in ipairs(js_filetypes) do
  dap.configurations[language] = {
    {
      name = "Launch file",
      type = "pwa-node",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      name = "Attach",
      type = "pwa-node",
      request = "attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      name = "tsx (" .. current_file .. ")",
      type = "node",
      request = "launch",
      program = "${file}",
      runtimeExecutable = "tsx",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      skipFiles = {
        "<node_internals>/**",
        "${workspaceFolder}/node_modules/**",
      },
    },
    {
      name = "pick script (pnpm)",
      type = "node",
      request = "launch",
      runtimeExecutable = "pnpm",
      runtimeArgs = { "run", pick_script },
      cwd = "${workspaceFolder}",
    },
  }
end
