return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  opts = {},
    -- stylua: ignore
  keys = {
    { "<d-e>", function() require("nvim-tree.api").tree.open({ path = "." }) end, mode = { "n" }, desc = "NvimTreeOpen (cwd)", },
    { "<d-E>", function() require("nvim-tree.api").tree.open(vim.fn.expand('%:h')) end, mode = { "n" }, desc = "NvimTreeOpen (buffer dir)", },
  },
}
