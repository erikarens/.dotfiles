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
        'github:mason-org/mason-registry',
        -- Adds a custom registry containing the roslyn and rzls packages.
        -- These packages are currently not included in the mason registry itself.
        -- Source: https://github.com/seblj/roslyn.nvim / https://github.com/tris203/rzls.nvim
        -- TODO: As soon as the packages beeing added to the mason registry we can remove this.
        'github:crashdummyy/mason-registry',
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

    -- Mason-LSPConfig setup
    mason_lspconfig.setup({
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
      },
    })

    -- Mason Tool Installer setup
    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",   -- JavaScript/TypeScript formatter
        "stylua",     -- Lua formatter
        "isort",      -- Python import sorter
        "black",      -- Python formatter
        "pylint",
        "eslint_d",   -- ESLint for JavaScript/TypeScript
      },
    })
  end,
}
