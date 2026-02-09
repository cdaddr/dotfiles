function g(fn_name, arg)
  return function()
    if arg then
      require("grapple")[fn_name](arg)
    else
      require("grapple")[fn_name]()
    end
    require("lualine").refresh()
  end
end
return {
  "cbochs/grapple.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
  ---@type grapple.settings
  opts = {
    scope = "git", -- also try out "git_branch"
    statusline = {
      include_icon = false,
      active = "[%s]",
      inactive = " %s ",
    },
    icons = false,
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  keys = {
    { "<leader>m", g("toggle"), desc = "Grapple toggle for this buffer" },
    { "<leader><leader>", g("toggle"), desc = "Grapple toggle for this buffer" },
    { "<leader>M", g("toggle_tags"), desc = "Grapple list tags" },

    { "<leader>]", g("cycle_tags", "next"), desc = "Grapple next" },
    { "<tab>", g("cycle_tags", "next"), desc = "Grapple next" },

    { "<leader>[", g("cycle_tags", "prev"), desc = "Grapple previous" },
    { "<s-tab>", g("cycle_tags", "prev"), desc = "Grapple previous" },
  },
}
