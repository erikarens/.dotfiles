-- LSP Source: https://github.com/seblyng/roslyn.nvim
-- File: lua/config/lsp/dotnet.lua
-- Sets up roslyn.nvim for C# and Razor/CSHTML.
--
-- Razor/Blazor is now handled by the Roslyn language server itself via
-- "cohosting" — the old rzls.nvim plugin and the separate `rzls` Mason
-- package are DEPRECATED and no longer needed (rzls was also removed from
-- the crashdummyy Mason registry). Install the server with :MasonInstall roslyn.
-- The `html` LSP (already in mason ensure_installed) provides the HTML half
-- of Razor support.
--
-- Make sure the matching .NET SDK is installed and `dotnet` is on PATH.
-- For brew taps -> https://github.com/isen-ng/homebrew-dotnet-sdk-versions
return {
  "seblyng/roslyn.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- Only load when editing C# and Razor files:
  ft = { "cs", "razor" },

  -- Run BEFORE the plugin is fully loaded
  init = function()
    vim.keymap.set("n", "<leader>ds", function()
      if not vim.g.roslyn_nvim_selected_solution then
        return vim.notify("No solution file found")
      end

      local projects = require("roslyn.sln.api").projects(vim.g.roslyn_nvim_selected_solution)
      local files = vim
        .iter(projects)
        :map(function(it)
          return vim.fs.dirname(it)
        end)
        :totable()

      local root = vim.fs.dirname(vim.g.roslyn_nvim_selected_solution) or vim.uv.cwd()

      require("telescope.pickers")
        .new({}, {
          cwd = root,
          prompt_title = "Find solution files",
          finder = require("telescope.finders").new_oneshot_job(
            vim.list_extend({ "fd", "--type", "f", "." }, files),
            { entry_maker = require("telescope.make_entry").gen_from_file({ cwd = root }) }
          ),
          sorter = require("telescope.config").values.file_sorter({}),
          previewer = require("telescope.config").values.grep_previewer({}),
        })
        :find()
    end)
  end,

  config = function()
    -- Plugin-level options only. The server binary is auto-detected from the
    -- Mason `roslyn` package (bin: roslyn-language-server), and Razor cohosting
    -- is wired up internally — no manual exe/args/handlers required anymore.
    require("roslyn").setup({
      broad_search = true,
      filewatching = "auto",
      choose_target = nil,
      ignore_target = nil,
      lock_target = false,
    })

    -- Server-specific settings go through the 0.11+ vim.lsp.config interface.
    -- Capabilities and on_attach are already applied globally via the
    -- vim.lsp.config("*") defaults set in lspconfig.lua.
    vim.lsp.config("roslyn", {
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
    })
  end,
}
