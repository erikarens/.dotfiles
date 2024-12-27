-- LSP Source: https://github.com/seblj/roslyn.nvim
-- File: lua/config/lsp/roslyn.lua
-- This sets up the roslyn.nvim and rzls.nvim plugin, along with the common LSP on_attach & capabilities
--
-- !To then install the packages to :MasonInstall roslyn & :MasonInstall rzls
-- This will only work once the lsp is beeing laoded (open a cs and razor file)
-- Or temporarily remove the `ft = {"cs", "razor"}` part of the config to install it
return {
    "seblj/roslyn.nvim",
    dependencies = {
        "tris203/rzls.nvim"
    },
    -- Only load when editing C# and Razor files:
    ft = {"cs", "razor"},
  
    -- We can pass plugin options using the `opts` key
    -- or a `config` function. We'll show a `config` function
    config = function()
      local roslyn = require("roslyn")
      local rzls = require("rzls")
  
      -- Import existing on_attach and capabilities 
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local lsp_utils = require("config.utils.lsp_utils")

    rzls.setup({
        on_attach = lsp_utils.on_attach,
        capabilities = capabilities,
      })
  
      roslyn.setup({
        -- The `config` table passes standard LSP client config to `vim.lsp.start`
        config = {
          on_attach = lsp_utils.on_attach,
          capabilities = capabilities,
          -- Add rzls handlers to make the packages work with each other
          handlers = require 'rzls.roslyn_handlers',
          -- `settings` for Roslyn-specific functionality:
          settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },
          },
        },
        -- If we installed via Mason custom registry (which we do in the mason.lua by adding the `crashdummyy/mason-registry`), these are the default paths:
        exe = {
          "dotnet",
          vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
        },
        -- Additional arguments
        args = {
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
          '--razorSourceGenerator=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'roslyn',
            'libexec',
            'Microsoft.CodeAnalysis.Razor.Compiler.dll'
          ),
          '--razorDesignTimePath=' .. vim.fs.joinpath(
            vim.fn.stdpath 'data' --[[@as string]],
            'mason',
            'packages',
            'rzls',
            'libexec',
            'Targets',
            'Microsoft.NET.Sdk.Razor.DesignTime.targets'
          ),
        },
        filewatching = true,
        choose_target = nil,
        ignore_target = nil,
        broad_search = false,
        lock_target = false,
      })
    end,
  }
  