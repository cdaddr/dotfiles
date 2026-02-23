return {
  "MagicDuck/grug-far.nvim",
  lazy = false,
  init = function()
    require("grug-far").setup({})
    -- :Grug command
    vim.api.nvim_create_user_command("Grug", function()
      require("grug-far").open({ transient = true })
    end, { desc = "Open grug-far (transient)" })
  end,
}
