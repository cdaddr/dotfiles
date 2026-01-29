return {
  "tronikelis/ts-autotag.nvim",
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
