return {
  url = "git@github.com:cdaddr/ts-autotag.nvim.git",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    filetypes = {
      "typescript",
      "javascript",
      "xml",
      "html",
      "templ",
      "svelte",
    },
    auto_close = {
      enabled = true,
    },
    auto_rename = {
      enabled = true,
    },
  },
}
