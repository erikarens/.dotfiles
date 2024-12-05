return {
  "f-person/git-blame.nvim",
  -- load the plugin at startup
  event = "VeryLazy",
  opts = {
    enabled = true,
    message_template = " <author> • <date> • <<sha>>",
    date_format = "%m-%d-%Y",
    virtual_text_column = 1,
  },
}
