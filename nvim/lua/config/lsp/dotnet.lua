-- LSP Source: https://github.com/seblj/roslyn.nvim
-- File: lua/config/lsp/roslyn.lua
-- This sets up the roslyn.nvim and rzls.nvim plugin, along with the common LSP on_attach & capabilities
--
-- !To then install the packages to :MasonInstall roslyn & :MasonInstall rzls
-- This will only work once the lsp is beeing laoded (open a cs and razor file)
-- Or temporarily remove the `ft = {"cs", "razor"}` part of the config to install it
--
-- Also makre sure that the correct dotnet sdk version is installed
-- For a brew tap -> https://github.com/isen-ng/homebrew-dotnet-sdk-versions
return {
  "seblj/roslyn.nvim",
  dependencies = {
    "tris203/rzls.nvim",
  },
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

      local root = vim.fs.dirname(vim.g.roslyn_nvim_selected_solution) or vim.loop.cwd()

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

  -- We can pass plugin options using the `opts` key
  -- or a `config` function. We'll show a `config` function
  config = function()
    local roslyn = require("roslyn")
    local rzls = require("rzls")

    -- Import existing on_attach and capabilities
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local lsp_utils = require("config.utils.lsp_utils")

    -- Resolve Roslyn server command: prefer native executable (no dotnet in PATH needed), else dotnet + DLL with full dotnet path.
    local data = tostring(vim.fn.stdpath("data"))
    local libexec = vim.fs.joinpath(data, "mason", "packages", "roslyn", "libexec")
    local native_exe = vim.fs.joinpath(libexec, "Microsoft.CodeAnalysis.LanguageServer")
    local dll_path = vim.fs.joinpath(libexec, "Microsoft.CodeAnalysis.LanguageServer.dll")

    local function dotnet_bin()
      local exe = vim.fn.exepath("dotnet")
      if exe and exe ~= "" then
        return exe
      end
      -- Fallbacks when Neovim is launched without dotnet in PATH (e.g. from Cursor/IDE).
      local candidates = {
        "/usr/local/share/dotnet/dotnet",
        "/opt/homebrew/share/dotnet/dotnet",
      }
      for _, p in ipairs(candidates) do
        if vim.fn.executable(p) == 1 then
          return p
        end
      end
      return "dotnet"
    end

    local cmd
    if vim.fn.executable(native_exe) == 1 then
      -- Use native executable so we don't depend on dotnet in PATH (fixes exit code 150 / "Could not execute..." when started from GUI).
      cmd = { native_exe }
    else
      cmd = { dotnet_bin(), dll_path }
    end

    rzls.setup({
      on_attach = lsp_utils.on_attach,
      capabilities = capabilities,
    })

    roslyn.setup({
      config = {
        cmd = cmd,
        on_attach = lsp_utils.on_attach,
        capabilities = capabilities,
        handlers = require("rzls.roslyn_handlers"),
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
      -- exe must match cmd so the plugin starts the same process (used for solution/project handling).
      exe = cmd,
      -- Additional arguments
      args = {
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(
          data,
          "mason",
          "packages",
          "roslyn",
          "libexec",
          "Microsoft.CodeAnalysis.Razor.Compiler.dll"
        ),
        "--razorDesignTimePath=" .. vim.fs.joinpath(
          data,
          "mason",
          "packages",
          "rzls",
          "libexec",
          "Targets",
          "Microsoft.NET.Sdk.Razor.DesignTime.targets"
        ),
      },
      filewatching = "roslyn",
      choose_target = nil,
      ignore_target = nil,
      broad_search = true,
      lock_target = false,
    })
  end,
}
