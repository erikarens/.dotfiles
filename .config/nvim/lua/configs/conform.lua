local options = {
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
  },

  format_on_save = {
    -- Format files on save with project-specific config (like .prettierrc)
    timeout_ms = 500,
    lsp_fallback = true,  -- If LSP provides formatting, fallback to LSP formatting
  },
}

return options
