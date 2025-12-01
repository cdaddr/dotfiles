-- Theme loader for WezTerm
-- Loads the generated theme file from config/current-theme.lua

local home = os.getenv('HOME')
local theme_file = home .. '/.dotfiles/config/current-theme.lua'

-- Load the theme
local theme = dofile(theme_file)

return theme
