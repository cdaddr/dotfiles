return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = true,
    },
    ensure_installed = {
      "prettier",
      "sql-formatter",
      "stylua",
      "svelte-language-server",
      "tailwindcss-language-server",
      "vtsls",
    }
  },
}
