-- Import the wezterm module
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 16
config.color_scheme = 'Kanagawa (Gogh)'
config.font_size = 16.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.use_fancy_tab_bar = false

config.window_background_opacity = 1.00
-- config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
	font = wezterm.font({ family = 'JetBrains Mono' }),
	font_size = 12,
	active_titlebar_bg = 'red',
}

wezterm.on('update-status', function(window)
	-- Grab the utf8 character for the "powerline" left facing
	-- solid arrow.
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Grab the current window's configuration, and from it the
	-- palette (this is the combination of your chosen colour scheme
	-- including any overrides).
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = 'none' } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = ' ' .. wezterm.hostname() .. ' ' },
	}))
end)

config.keys = {
	{
		mods = 'CMD',
		key = "LeftArrow",
		action = wezterm.action.SendKey {
			key = 'Home',
		}
	},
	{
		mods = 'CMD',
		key = "RightArrow",
		action = wezterm.action.SendKey {
			key = 'End',
		}
	},
	{
		mods = 'CMD',
		key = "d",
		action = wezterm.action.SplitPane { direction = 'Right' }
	},
	{
		mods = 'CMD',
		key = "D",
		action = wezterm.action.SplitPane { direction = 'Down' }
	},
}

for key, dir in pairs({ L = 'Right', H = 'Left', J = 'Down', K = 'Up' }) do
	config.keys[#config.keys + 1] = {
		mods = 'CMD|SHIFT',
		key = key,
		action = wezterm.action.ActivatePaneDirection(dir)
	}
end

for i = 1, 9 do
	config.keys[#config.keys + 1] = {
		mods = 'CMD',
		key = tostring(i),
		action = wezterm.action.ActivatePaneByIndex(i - 1)
	}

	config.keys[#config.keys + 1] = {
		mods = 'OPT',
		key = tostring(i),
		action = wezterm.action.ActivateTab(i - 1)
	}
end

config.colors = {
  tab_bar = {
		background = '#1a1a22',
    active_tab = {
      bg_color = '#2d4f67',
      fg_color = '#dcd7ba',
      -- bg_color = '#1a1a22',
      -- fg_color = '#ff9e3b',

    --   intensity = 'Normal',
    --   underline = 'None',
    --   italic = false,
    --   strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#1a1a22',
      fg_color = '#54546d',
    },
    --
    -- inactive_tab_hover = {
    --   bg_color = '#3b3052',
    --   fg_color = '#909090',
    --   italic = true,
    -- },
    --
    new_tab = {
      bg_color = '#1a1a22',
      fg_color = '#dcd7ba',
    },
    --
    -- new_tab_hover = {
    --   bg_color = '#3b3052',
    --   fg_color = '#909090',
    --   italic = true,
    -- },
  },
}

return config
