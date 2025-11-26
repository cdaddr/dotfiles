return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
    },
    ensure_installed = {
      "lua_ls",
      "prettier",
      "sql-formatter",
      "stylua",
      "svelte-language-server",
      "tailwindcss-language-server",
      "vtsls",
    }
  },
}
