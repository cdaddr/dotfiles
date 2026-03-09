return {
  "AckslD/nvim-neoclip.lua",
  event = "TextYankPost",
  dependencies = { "kkharji/sqlite.lua" },
  opts = {
    history = 50,
    enable_persistent_history = true,
    continuous_sync = false,
    -- disable built-in telescope/fzf-lua integrations
    keys = { telescope = {}, fzf = {} },
  },
  keys = {
    { "<leader>sy", function() require("config.pickers").neoclip() end, desc = "Yank History" },
  },
}
