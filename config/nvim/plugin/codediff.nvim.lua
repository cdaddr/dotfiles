-- deferred (later): a diff viewer is on-demand and pulls in ~40 files; loading it
-- in the background keeps its cold-start file scans off the responsive-UI path.
later(function()
  vim.pack.add({
    "https://github.com/esmuellert/codediff.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
  })
  require("codediff").setup({
    explorer = { view_mode = "tree" },
  })
end)
