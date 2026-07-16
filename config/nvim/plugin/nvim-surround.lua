-- deferred: surround edits; default keys apply until this loads (a beat post-UI)
later(function()
  vim.pack.add({ "https://github.com/kylechui/nvim-surround" })
  require("nvim-surround").setup({
    surrounds = {
      ["d"] = {
        add = { "{[", "]}" },
        find = "%{%[.-%]%}",
        delete = "^(%{%[)().-(%]%})()$",
      },
    },
  })
end)
