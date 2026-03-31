-- LSP Configuration & Plugins
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Imports (no lspconfig - use vim.lsp.config per 0.11 API)  │
    -- ╰──────────────────────────────────────────────────────────╯
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lsp_utils = require("config.utils.lsp_utils")

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Capabilities                                            │
    -- ╰──────────────────────────────────────────────────────────╯
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Diagnostic Config (0.11+ API)                           │
    -- ╰──────────────────────────────────────────────────────────╯
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Global defaults (merged for all LSP configs)             │
    -- ╰──────────────────────────────────────────────────────────╯
    vim.lsp.config("*", {
      capabilities = capabilities,
      on_attach = lsp_utils.on_attach,
    })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Server-specific overrides (vim.lsp.config)               │
    -- ╰──────────────────────────────────────────────────────────╯
    -- Svelte: custom on_attach with TS/JS change notification
    vim.lsp.config("svelte", {
      on_attach = function(client, bufnr)
        lsp_utils.on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- GraphQL
    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- Emmet
    vim.lsp.config("emmet_ls", {
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
    })

    -- Lua
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    -- TypeScript
    vim.lsp.config("ts_ls", {
      init_options = {
        preferences = {
          importModuleSpecifierPreference = "relative",
          importModuleSpecifierEnding = "minimal",
        },
      },
    })

    -- Angular (Mason 2.0: use $MASON env)
    local angularls_path = vim.fn.expand("$MASON/packages/angular-language-server")
    if vim.fn.isdirectory(angularls_path) == 1 then
      local ngls_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        table.concat({ angularls_path, vim.uv.cwd() }, ","),
        "--ngProbeLocations",
        table.concat({
          angularls_path .. "/node_modules/@angular/language-server",
          vim.uv.cwd(),
        }, ","),
        "--experimental-ivy",
      }
      vim.lsp.config("angularls", {
        cmd = ngls_cmd,
      })
    end
  end,
}
