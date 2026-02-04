return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })
  end,
}

