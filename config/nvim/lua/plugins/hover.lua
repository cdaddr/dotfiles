return {
	"Fildo7525/pretty_hover",
}

-- function hov(f, arg)
--   return function()
--     if arg then
--       require('hover')[f](arg)
--     else
--       require('hover')[f]()
--     end
--   end
-- end
-- return {
--   'lewis6991/hover.nvim',
--   opts = {
--     providers = {
--       'hover.providers.diagnostic',
--       'hover.providers.lsp',
--       'hover.providers.gh',
--       -- 'hover.providers.dap',
--       -- 'hover.providers.man',
--       -- 'hover.providers.dictionary',
--     },
--   },
--   keys = {
--     { 'K', hov('open'), desc = "hover.nvim (open)" },
--     { 'gK', hov('enter'), desc = "hover.nvim (enter)" },
--     { '<C-p>', hov('hover_switch', 'previous'), desc = "hover.nvim (previous source)" },
--     { '<C-n>', hov('hover_switch', 'next'), desc = "hover.nvim (next source)" },
--   }
-- }
