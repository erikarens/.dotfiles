return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local api = require("nvim-tree.api")

    -- For debugging purposes
    -- dap.set_log_level("Trace")

    -- Function to close nvim-tree
    local function close_nvim_tree()
      if api.tree.is_visible() then
        api.tree.close()
      end
    end

    -- Setup dap-ui
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
      mappings = {
        edit = "i",
        remove = "dd",
      },
    })

    -- Open dap-ui automatically
    dap.listeners.after.event_initialized["dapui_config"] = function()
      close_nvim_tree()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Define custom signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

    -- Keymaps for dap functionality
    local keymap = vim.keymap
    keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue Debugging" })
    keymap.set("n", "<Leader>dd", dap.disconnect, { desc = "Disconnect Debugging Session" })
    keymap.set("n", "<F5>", dap.continue, { silent = true, noremap = true, desc = "Continue Debugging" })
    keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over Function" })
    keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into Function" })
    keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out Function" })
    keymap.set("n", "<leader>du", function()
      require("dapui").toggle()
    end, { desc = "Toggle DAP UI" })
    keymap.set("n", "<leader>dr", function()
      require("dap").run_last()
    end, { desc = "Re-run the last debug session" })
    keymap.set("n", "<leader>dre", function()
      require("dap").repl.open()
    end, { desc = "Open DAP REPL" })
    keymap.set("n", "<leader>dD", function()
      dap.clear_breakpoints()
      vim.notify("All breakpoints cleared", vim.log.levels.INFO)
    end, { desc = "Clear All Breakpoints" })

    -- Per language config
    require("config.dap.cs").setup()
  end,
}
