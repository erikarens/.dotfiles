-- This is a simple Lua module that exposes a .setup() function.

local M = {}

function M.setup()
  local dap = require("dap")
  local dap_utils = require("dap.utils")

  -- For this to work on macOS, we need `netcoredbg` installed
  -- e.g., downloaded from https://github.com/Samsung/netcoredbg/releases
  dap.adapters.coreclr = {
    type = "executable",
    -- path to the current netcoredbg executable
    command = "/usr/local/netcoredbg",
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "Launch",
      request = "launch",
      program = function()
        local project_path = vim.fs.root(0, function(name)
          return name:match("%.csproj$") ~= nil
        end)

        if not project_path then
          return vim.notify("Couldn't find the csproj path")
        end

        return dap_utils.pick_file({
          filter = string.format("Debug/.*/%s", vim.fn.fnamemodify(project_path, ":t:r")),
          path = string.format("%s/bin", project_path),
        })
      end,
    },
    {
      type = "coreclr",
      name = "Attach",
      request = "attach",
      processId = function()
        return dap_utils.pick_process({
          filter = function(proc)
            -- Filter out test runners for example
            return proc.name:match(".*/Debug/.*") and not proc.name:find("vstest.console.dll")
          end,
        })
      end,
      env = {
        ASPNETCORE_ENVIRONMENT = "Development", -- Start in development mode
      },
    },
  }
end

return M
