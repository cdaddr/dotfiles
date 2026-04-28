-- only load in kitty with a real UI; fails with "failed to open stdout" in headless
if not vim.env.KITTY_WINDOW_ID or #vim.api.nvim_list_uis() == 0 then return end

vim.pack.add({ 'https://github.com/3rd/image.nvim' })
require('image').setup({ processor = "magick_cli" })
