return {
  "catppuccin/nvim", name = "catppuccin", priority = 1000,
  config = function()
    require ('catppuccin').setup{
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.20,
      },
      integrations = {
        treesitter = true,
        mini = {
          enabled = true,
          blink = true,
        },
        notify = true,
        snacks = {
          enabled = true,
        },
        which_key = true,
      }
    }
  end
}
