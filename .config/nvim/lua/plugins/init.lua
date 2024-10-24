return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- LazyGit plugin
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit", -- Lazy load LazyGit when the command is run
    keys = { -- Define the keybinding even when LazyGit is not loaded
      { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
    },
    config = function()
      -- Optional additional config
    end,
  },

  -- Bufferline plugin
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- For icons
    version = "*", -- Use latest version
    lazy = false, -- Ensure Bufferline is loaded at startup
    opts = {
      options = {
        mode = "tabs", -- Only show tabs (no buffers)
        separator_style = "slant", -- Choose separator style
        show_buffer_close_icons = false, -- Hide close icons on buffers
        show_close_icon = false, -- Hide global close icon
        diagnostics = "nvim_lsp", -- Show LSP diagnostics
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  -- Auto-session plugin
  {
    "rmagatti/auto-session",
    config = function()
      local auto_session = require "auto-session"
      auto_session.setup {
        auto_restore_enabled = false,
        auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
      }
    end,
  },

  -- Git blame plugin
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy", -- Load the plugin lazily
    opts = {
      enabled = true, -- Enable the plugin
      message_template = " <author> • <date> • <<sha>>", -- Customize the git blame message
      date_format = "%m-%d-%Y", -- Customize the date format
      virtual_text_column = 1, -- Set where the virtual text should appear
    },
  },
}
