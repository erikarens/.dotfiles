-- Patch third-party plugins that use deprecated Neovim APIs.
-- Runs before Lazy loads so patched files are used when plugins are required.
-- Re-run after :Lazy update (restart Neovim) to re-apply if plugins were updated.

local M = {}

local function patch_telescope_lsp()
  local path = vim.fn.stdpath("data") .. "/lazy/telescope.nvim/lua/telescope/builtin/__lsp.lua"
  local ok, content = pcall(vim.fn.readfile, path)
  if not ok or not content or #content == 0 then
    return
  end
  local joined = table.concat(content, "\n")

  -- Already patched?
  if joined:find("client:supports_method(method, bufnr)") and joined:find("vim.lsp.util.show_document") then
    return
  end

  local new_content = joined
    :gsub(
      "client%.supports_method(method, %{ bufnr = bufnr %})",
      "client:supports_method(method, bufnr)"
    )
    :gsub(
      "vim%.lsp%.util%.jump_to_location(flattened_results%[1%], offset_encoding)",
      "vim.lsp.util.show_document(flattened_results[1], offset_encoding, { focus = true })"
    )

  if new_content ~= joined then
    pcall(vim.fn.writefile, vim.split(new_content, "\n"), path)
  end
end

function M.run()
  patch_telescope_lsp()
end

return M
