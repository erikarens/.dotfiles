return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

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
}
