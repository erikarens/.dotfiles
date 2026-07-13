-- Patch third-party plugins that use deprecated Neovim APIs.
-- Runs before Lazy loads so patched files are used when plugins are required.
-- Re-run after :Lazy update (restart Neovim) to re-apply if plugins were updated.

local M = {}

-- Plain-text (non-pattern) replace-all. Avoids Lua-pattern magic chars.
local function replace_all(s, find, repl)
  local out, idx = {}, 1
  while true do
    local a, b = string.find(s, find, idx, true)
    if not a then
      out[#out + 1] = string.sub(s, idx)
      break
    end
    out[#out + 1] = string.sub(s, idx, a - 1)
    out[#out + 1] = repl
    idx = b + 1
  end
  return table.concat(out)
end

-- Telescope's LSP builtins use several APIs deprecated in Nvim 0.11/0.12:
--   * client.supports_method(...)  -> client:supports_method(...)  (method-call form)
--   * vim.lsp.util.make_position_params() now requires a position_encoding arg
--   * vim.lsp.util.jump_to_location() -> vim.lsp.util.show_document()
local function patch_telescope_lsp()
  local path = vim.fn.stdpath("data") .. "/lazy/telescope.nvim/lua/telescope/builtin/__lsp.lua"
  local ok, content = pcall(vim.fn.readfile, path)
  if not ok or not content or #content == 0 then
    return
  end
  local joined = table.concat(content, "\n")
  local original = joined

  -- Derive the offset encoding from the buffer's attached client at call time.
  local enc = '(vim.lsp.get_clients({ bufnr = opts.bufnr })[1] or {}).offset_encoding'

  joined = replace_all(
    joined,
    "client.supports_method(method, { bufnr = bufnr })",
    "client:supports_method(method, { bufnr = bufnr })"
  )
  joined = replace_all(
    joined,
    "vim.lsp.util.make_position_params(opts.winnr)",
    "vim.lsp.util.make_position_params(opts.winnr, " .. enc .. ")"
  )
  joined = replace_all(
    joined,
    "vim.lsp.util.make_position_params()",
    "vim.lsp.util.make_position_params(0, " .. enc .. ")"
  )
  joined = replace_all(
    joined,
    "vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding)",
    "vim.lsp.util.show_document(flattened_results[1], offset_encoding, { focus = true })"
  )

  if joined ~= original then
    pcall(vim.fn.writefile, vim.split(joined, "\n"), path)
  end
end

function M.run()
  patch_telescope_lsp()
end

return M
