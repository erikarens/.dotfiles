return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- Import mason, mason-lspconfig, and mason-tool-installer
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- Mason setup
    mason.setup({
      -- Registries that should be used.
      registries = {
        "github:mason-org/mason-registry",
        -- Custom registry providing an up-to-date `roslyn` package (the C#
        -- language server, which now also handles Razor/CSHTML via cohosting).
        -- The upstream mason `roslyn-language-server` package lags behind, so
        -- we keep this. Note: the old `rzls` package was removed from this
        -- registry once Razor support moved into roslyn itself.
        -- Source: https://github.com/seblyng/roslyn.nvim
        "github:Crashdummyy/mason-registry",
      },
      -- ui config
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "angularls",
        "emmet_ls",
        "prismals",
        "pyright",
        "jsonls",
        "dockerls",
        "docker_compose_language_service",
        "bashls",
        "terraformls",
      },
      automatic_installation = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "angularls",
        "emmet_ls",
        "prismals",
        "pyright",
        "jsonls",
        "dockerls",
        "docker_compose_language_service",
        "bashls",
        "terraformls",
      },
    })

    mason_tool_installer.setup({
      -- Mason Tool Installer setup
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
        "debugpy", -- python debugger
        "roslyn",
        "ansible-lint",
        "tflint", -- terraform linter
      },
    })
  end,
}
