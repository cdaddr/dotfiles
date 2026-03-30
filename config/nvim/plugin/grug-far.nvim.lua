vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

require("grug-far").setup({})

vim.api.nvim_create_user_command("Grug", function()
  require("grug-far").open({ transient = true })
end, { desc = "Open grug-far (transient)" })
