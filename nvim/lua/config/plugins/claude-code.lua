-- Claude Code Neovim IDE extension (https://github.com/coder/claudecode.nvim)
-- WebSocket-based MCP protocol; requires Claude Code CLI in PATH
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    -- Toggle/focus from normal and visual
    { "<C-,>", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
    -- Leave Claude terminal (exit terminal mode + focus other window)
    { "<C-,>", "<C-\\><C-n><cmd>ClaudeCodeFocus<cr>", mode = "t", desc = "Leave Claude terminal" },
    { "<leader>ac", "<C-\\><C-n><cmd>ClaudeCodeFocus<cr>", mode = "t", desc = "Leave Claude terminal" },
  },
  opts = {
    auto_start = true,
    track_selection = true,
    terminal = {
      split_side = "right",
      split_width_percentage = 0.30,
      provider = "auto",
      auto_close = true,
    },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
    },
    git_repo_cwd = true,
  },
  config = true,
}
