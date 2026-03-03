return {
  {
    "mason-org/mason.nvim",
    -- see colorscheme.lua for highlights
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
