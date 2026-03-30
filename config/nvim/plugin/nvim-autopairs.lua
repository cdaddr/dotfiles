vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
require('nvim-autopairs').setup({
  check_ts = true,
  enable_check_bracket_line = true,
  ignored_next_char = [=[[%w%%%'%[%(%{%%)%]%}"%.%`%$]]=],
  map_cr = true,
})
