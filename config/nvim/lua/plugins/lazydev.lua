return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    --@type lazydev.Config
    opts = function()
      local library = {

        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "LazyVim",
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "Snacks" },
      }
      local files = io.popen("fd --type d --exact-depth 2 lua ~/.local/share/nvim/lazy/")
      if files then
        for file in files:lines() do
          library[#library + 1] = file
        end
      end
      return {
        library = library,
      }
    end,
  },
}
