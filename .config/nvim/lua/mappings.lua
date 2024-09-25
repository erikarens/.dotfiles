require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Custom mappings
-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Exit terminal mode in the builtin terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split window sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Maximize/minimize a split
map("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize split" })

-- Tab management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "gt", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "gT", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-- File explorer (nvim-tree)
map("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
map("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
map("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })

-- Session management
map("n", "<leader>.r", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
map("n", "<leader>.s", "<cmd>SessionSave<CR>", { desc = "Save session" })

-- Uncomment if you need save with Ctrl-S
-- map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Remove the default keymaps for Tabufline
vim.keymap.del("n", "<leader>b") -- Remove buffer new keymap
vim.keymap.del("n", "<tab>") -- Remove buffer goto next keymap
vim.keymap.del("n", "<S-tab>") -- Remove buffer goto prev keymap
vim.keymap.del("n", "<leader>x") -- Remove buffer close keymap
