vim.pack.add({ 'https://github.com/kylechui/nvim-surround' })
require('nvim-surround').setup({
  surrounds = {
    ["d"] = {
      add = { "{[", "]}" },
      find = "%{%[.-%]%}",
      delete = "^(%{%[)().-(%]%})()$",
    },
  },
})
