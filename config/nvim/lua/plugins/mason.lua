return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- ensure_installed = {
      --   "lua_ls",
      --   "prettier",
      --   "sql-formatter",
      --   "stylua",
      --   "svelte-language-server",
      --   "tailwindcss-language-server",
      --   "vtsls",
      -- }
    },
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
}
