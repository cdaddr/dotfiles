return {
  "kylechui/nvim-surround",
  -- event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      surrounds = {
        ["d"] = {
          add = { "{[", "]}" },
          find = "%{%[.-%]%}",
          delete = "^(%{%[)().-(%]%})()$",
        },
      },
    })
  end,
}
