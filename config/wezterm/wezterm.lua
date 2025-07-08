-- Import the wezterm module
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font_size = 16
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 16.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font = wezterm.font({family = 'JetBrainsMono Nerd Font' })

-- config.use_resize_increments = true
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.00
-- config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
	font = wezterm.font({ family = 'JetBrainsMono Nerd Font' }),
	font_size = 12,
}
config.window_padding = {
  left=16, right=16, top=16, bottom=16
}
config.show_new_tab_button_in_tab_bar = false
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

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if not (title and #title > 0) then
    title = tab_info.active_pane.title or 'Tab'
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local RED = '#f38ba8'
  local PINK = '#f5c2e7'
  local MID = '#45475a'
  local DARK = '#313244'
  local DARKER = '#11111b'
  local PURPLE = '#7f849c'
  local MAROON = '#f4a6c7'
  local SLASH = wezterm.nerdfonts.ple_forwardslash_separator
  local RIGHT_SOLID = wezterm.nerdfonts.ple_upper_left_triangle
  local LEFT_SOLID = wezterm.nerdfonts.ple_lower_right_triangle

  local fg = function(color) return { Foreground = { Color = color } } end
  local bg = function(color) return { Background = { Color = color } } end
  local text = function(txt) return { Text = (txt or '') } end

  local format = {}
  local c = function(option) return table.insert(format, option) end

  local next_tab = tabs[tab.tab_index + 2]
  local prev_tab = tabs[tab.tab_index]
  local title = tab_title(tab)
  local number = tostring(tab.tab_index + 1)

  c(bg('none'))
  if tab.is_active then
    c(fg(PINK))
    c(text(LEFT_SOLID))

    c(bg(PINK))
    c(fg(DARKER))
    c(text(number))

    if #panes > 1 then
      local active
      for _, pane in pairs(panes) do
        if pane.is_active then
          active = pane.pane_index + 1
        end
      end
      if active then
        c(fg(PINK))
        c(bg(MAROON))
        c(text(RIGHT_SOLID))

        c(fg(DARKER))
        c(bg(MAROON))
        c(text(tostring(active)))

        c(fg(MAROON))
        c(bg(RED))
        c(text(RIGHT_SOLID))
      end
    else
      c(bg(PINK))
      c(fg(RED))
      c(text(LEFT_SOLID))
    end

    c(bg(RED))
    c(fg(DARKER))
    c(text(' '))
    c(text(title))


    c(text(' '))

    c(bg(RED))
    c(fg(DARKER))
    c(text(SLASH))
    c(text(SLASH))

    c(bg('none'))
    c(fg(RED))
    c(text(RIGHT_SOLID))
  else
    c(fg(MID))
    c(text(LEFT_SOLID))

    c(bg(MID))
    c(fg(DARKER))
    c(text(number))

    c(bg(DARK))
    c(fg(MID))
    c(text(RIGHT_SOLID))

    c(fg(PURPLE))
    c(text(' '))
    c(text(title))
    c(text(' '))

    c(bg('none'))
    c(fg(DARK))
    c(text(RIGHT_SOLID))
  end


  return format
end)

config.use_fancy_tab_bar = false
config.tab_max_width = 40
config.mouse_wheel_scrolls_tabs = false
config.swallow_mouse_click_on_window_focus = true
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
    background = '#1e1e2e'
  },
}

return config
