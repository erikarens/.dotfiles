-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- Function to attach keymaps on LSP attach
local function custom_on_attach(client, bufnr)
  -- Call the default on_attach provided by NvChad
  nvlsp.on_attach(client, bufnr)

  -- Additional custom key mappings
  local keymap = vim.keymap
  local opts = { buffer = bufnr, silent = true }

  -- Set keybinds from your old config
  keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
  keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  keymap.set("n", "K", vim.lsp.buf.hover, opts)
  keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
  keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = custom_on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    custom_on_attach(client, bufnr)
    -- Optional: if ESLint provides formatting, you can disable other formatters
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    format = { enable = true },
    lint = {
      enable = true,              -- Enable linting with ESLint
      packageManager = "npm",      -- Adjust depending on your package manager
    },
  },
}

lspconfig.ts_ls.setup {
  on_attach = custom_on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
      importModuleSpecifierEnding = "minimal",
    },
  },
}

-- configure angularls
local default_node_modules = vim.fn.getcwd() .. "/node_modules"
local ngls_cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations", default_node_modules,
  "--ngProbeLocations", default_node_modules,
  "--experimental-ivy",
}

lspconfig.angularls.setup {
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  cmd = ngls_cmd,
  on_new_config = function(new_config)
    new_config.cmd = ngls_cmd
  end
}

-- configure omnisharp
--
-- You need to install omnisharp-roslyn and define the path to omnisharp below
-- for macOS do the following https://github.com/OmniSharp/homebrew-omnisharp-roslyn
--
-- This is the main repo im talking about https://github.com/omnisharp/omnisharp-roslyn
lspconfig.omnisharp.setup {
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { "dotnet", "/opt/homebrew/bin/omnisharp" },
  root_dir = function()
    return vim.loop.cwd()
  end,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      UseBinaryLogger = false,
      LoadProjectsOnDemand = false,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      AnalyzeOpenDocumentsOnly = true,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  }
}