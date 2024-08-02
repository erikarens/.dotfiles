-- Useful plugin to show you pending keybinds.
return {
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add({
      { "<leader>c", "which_key_ignore", desc = "[C]ode" },
      { "<leader>d", "which_key_ignore", desc = "[D]ocument" },
      { "<leader>r", "which_key_ignore", desc = "[R]ename" },
      { "<leader>s", "which_key_ignore", desc = "[S]earch" },
      { "<leader>w", "which_key_ignore", desc = "[W]orkspace" },
      { "<leader>t", "which_key_ignore", desc = "[T]oggle" },
      { "<leader>h", "which_key_ignore", desc = "Git [H]unk" },
      -- visual mode
      { "<leader>h", desc = "Git [H]unk", mode = "v" },
    })
  end,
}
