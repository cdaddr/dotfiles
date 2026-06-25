vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
require('nvim-autopairs').setup({
  check_ts = true,
  enable_check_bracket_line = true,
  -- NB: keep closing/opening brackets OUT of this set. Listing `)]}` here makes
  -- autopairs refuse to add a pair when the cursor sits before one, which breaks
  -- the common `foo(x => {<CR>` case (no `}` inserted, no indent). This matches
  -- the upstream default.
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  map_cr = true,
})
