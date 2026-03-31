local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Patch plugin files that use deprecated APIs (run before plugins load)
require("config.utils.patch_deprecations").run()

require("lazy").setup({
  { import = "config.plugins" },
  { import = "config.lsp" },
  { import = "config.dap.init" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  rocks = { enabled = false },
})
