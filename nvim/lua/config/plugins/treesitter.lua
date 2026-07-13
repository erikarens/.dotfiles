-- Highlight, edit, and navigate code
--
-- NOTE: nvim-treesitter `main` branch (required for Neovim 0.12+). This is a
-- full rewrite of the plugin — the old `master`-branch API
-- (`require("nvim-treesitter.configs").setup{ highlight = {...} }`) is gone.
-- Highlighting is now Neovim-native (`vim.treesitter.start()`), parsers are
-- installed via `require("nvim-treesitter").install{}`, and indentation is an
-- experimental opt-in. main does NOT support lazy-loading.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      opts = {},
    },
  },
  config = function()
    require("nvim-treesitter").setup({})

    -- Parsers to keep installed. Replaces the old `ensure_installed`.
    -- `install` is async and a no-op for parsers already present.
    local ensure_installed = {
      "bash",
      "c",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "json",
      "python",
      "regex",
      "typescript",
      "javascript",
      "c_sharp",
      "css",
      "dockerfile",
      "yaml",
      "tsx",
      "gitignore",
    }
    require("nvim-treesitter").install(ensure_installed)

    -- Enable treesitter highlighting + (experimental) indentation per buffer.
    -- Also replicates the old `auto_install`: install a parser on first use of
    -- a filetype if it's available but not yet installed.
    local ts_config = require("nvim-treesitter.config")
    local installed = ts_config.get_installed("parsers")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter_start", { clear = true }),
      callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end

        -- auto_install: fetch a missing-but-available parser, then bail this
        -- pass (install is async; highlighting starts on the next buffer of
        -- that filetype).
        if not vim.tbl_contains(installed, lang) then
          if vim.tbl_contains(ts_config.get_available(), lang) then
            require("nvim-treesitter").install({ lang })
            table.insert(installed, lang)
          end
          return
        end

        -- Neovim-native treesitter highlighting.
        if not pcall(vim.treesitter.start, ev.buf, lang) then
          return
        end

        -- Experimental treesitter-based indentation.
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
