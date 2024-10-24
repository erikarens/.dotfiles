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

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

lspconfig.ts_ls.setup {
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
      importModuleSpecifierEnding = "minimal",
    },
  },
}

-- accessing the mason-regisrty to configure lsp's with it
local ok, mason_registry = pcall(require, 'mason-registry')
if not ok then
  vim.notify 'mason-registry could not be loaded'
  return
end

-- AngularLS setup using mason-registry
local angularls_path = mason_registry.get_package('angular-language-server'):get_install_path()

local ngls_cmd = {
  'ngserver',
  '--stdio',
  '--tsProbeLocations',
  table.concat({
    angularls_path,
    vim.uv.cwd(),
  }, ','),
  '--ngProbeLocations',
  table.concat({
    angularls_path .. '/node_modules/@angular/language-server',
    vim.uv.cwd(),
  }, ','),
}

lspconfig.angularls.setup {
  cmd = ngls_cmd,
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  on_new_config = function(new_config)
    new_config.cmd = ngls_cmd
  end,
}

-- Omnisharp setup using mason-registry
local omnisharp_path = mason_registry.get_package('omnisharp'):get_install_path()

-- Omnisharp setup
lspconfig.omnisharp.setup {
  on_attach = custom_on_attach,
  capabilities = nvlsp.capabilities,
  cmd = { omnisharp_path .. "/omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
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
  },
}

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    custom_on_attach(client, bufnr)
    -- Optional: if ESLint provides formatting, you can disable other formatters
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    format = { enable = true },
    lint = {
      enable = true, -- Enable linting with ESLint
      packageManager = "npm", -- Adjust depending on your package manager
    },
  },
}
