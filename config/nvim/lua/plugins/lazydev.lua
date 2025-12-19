return {
  {
    "folke/lazydev.nvim",
    dependencis = { 'DrKJeff16/wezterm-types' },
    ft = "lua",
    --@type lazydev.Config
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "LazyVim",
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
}
