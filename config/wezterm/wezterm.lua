-- Import the wezterm module
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 16
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 16.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.use_resize_increments = true
config.window_background_opacity = 1.00
-- config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
	font = wezterm.font({ family = 'JetBrains Mono' }),
	font_size = 12,
}
config.window_padding = {
  left=16, right=16, top=16, bottom=16
}
config.enable_scroll_bar = false

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

  local date = wezterm.strftime '%Y-%m-%d %I:%M:%S'

	window:set_right_status(wezterm.format({
		-- First, we draw the arrow...
		{ Background = { Color = 'none' } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		-- Then we draw our text
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = ' ' .. date .. ' ' .. wezterm.hostname() .. ' ' },
	}))
end)

config.use_fancy_tab_bar = false
config.tab_max_width = 40
config.mouse_wheel_scrolls_tabs = false
config.underline_position = "-8"
config.underline_thickness = "1px"

config.quit_when_all_windows_are_closed = false

config.keys = {
  -- home/end
	{ mods = 'CMD', key = "LeftArrow", action = wezterm.action.SendKey { key = 'Home', } },
	{ mods = 'CMD', key = "RightArrow", action = wezterm.action.SendKey { key = 'End', } },

  -- split
	{ mods = 'CMD', key = "d", action = wezterm.action.SplitPane { direction = 'Right' } },
	{ mods = 'CMD', key = "D", action = wezterm.action.SplitPane { direction = 'Down' } },

  -- command palette
	{ mods = 'CMD|SHIFT', key = "P", action = wezterm.action.ActivateCommandPalette },

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
		background = '#181825',
    active_tab = {
      -- fg_color = '#cdd6f4',
      -- fg_color = '#f5c2e7',
      fg_color = '#b4befe',
      bg_color = '#1e1e2e',
      -- bg_color = '#2d4f67',
      -- fg_color = '#dcd7ba',
      -- bg_color = '#1a1a22',
      -- fg_color = '#ff9e3b',

      intensity = 'Normal',
      -- underline = 'Single',
      italic = false,
    --   strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#11111b',
      fg_color = '#6c7086',
      intensity = 'Half',
      -- underline = 'Single',
      -- italic = true,
    },
    --
    -- inactive_tab_hover = {
    --   bg_color = '#3b3052',
    --   fg_color = '#909090',
    --   italic = true,
    -- },
    --
    new_tab = {
      bg_color = '#11111b',
      fg_color = '#9399b2',
      intensity = 'Half',
      -- fg_color = '#dcd7ba',
    },

    new_tab_hover = {
      bg_color = '#11111b',
      fg_color = '#cdd6f4',
      intensity = 'Half',
    },
  },
}

return config
