-- LSP Configuration & Plugins
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
        end

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "[G]oto [D]eclaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "[G]oto [D]efinition"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "[G]oto [I]mplementation"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "[R]e[n]ame"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = ev.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = ev.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- configuration options can be found here https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    mason_lspconfig.setup_handlers({
      -- default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({
          capabilities = capabilities,
        })
      end,
      ["svelte"] = function()
        -- configure svelte server
        lspconfig["svelte"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,
      ["graphql"] = function()
        -- configure graphql language server
        lspconfig["graphql"].setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,
      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
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
      end,
      ["lua_ls"] = function()
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
                globals = { "vim" },
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        })
      end,
      ["ts_ls"] = function()
        -- configure tsserver
        lspconfig["ts_ls"].setup({

          init_options = {
            preferences = {
              -- Use relative imports instead of absolute
              importModuleSpecifierPreference = "relative",
              importModuleSpecifierEnding = "minimal",
            },
          },
        })
      end,
      ["angularls"] = function()
        -- Access mason-registry to get the Angular Language Server path
        local ok, mason_registry = pcall(require, "mason-registry")
        if not ok then
          vim.notify("Mason registry could not be loaded")
          return
        end

        local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

        -- Update the ngls_cmd to include proper paths
        local ngls_cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          table.concat({
            angularls_path,
            vim.uv.cwd(),
          }, ","),
          "--ngProbeLocations",
          table.concat({
            angularls_path .. "/node_modules/@angular/language-server",
            vim.uv.cwd(),
          }, ","),
          "--experimental-ivy",
        }

        -- Configure angularls
        lspconfig["angularls"].setup({
          cmd = ngls_cmd,
          on_new_config = function(new_config)
            new_config.cmd = ngls_cmd
          end,
          capabilities = capabilities, -- Use your existing capabilities
          on_attach = function(client, bufnr)
            -- Customize on_attach here if needed
          end,
        })
      end,
      ["omnisharp"] = function()
        -- configure omnisharp
        --
        -- You need to install omnisharp-roslyn and define the path to omnisharp below
        -- for macOS do the following https://github.com/OmniSharp/homebrew-omnisharp-roslyn
        --
        -- This is the main repo im talking about https://github.com/omnisharp/omnisharp-roslyn
        lspconfig["omnisharp"].setup({
          capabilities = capabilities,
          cmd = { "dotnet", "/opt/homebrew/bin/omnisharp" }, -- Ensure the Omnisharp executable is in your PATH
          on_attach = function(client, bufnr)
            -- Add buffer-local key mappings
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
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
        })
      end,
    })
  end,
}
