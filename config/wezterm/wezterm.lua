-- Import the wezterm module
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local MAX_TAB_WIDTH = 48

config.tab_max_width = MAX_TAB_WIDTH
config.initial_cols = 160
config.initial_rows=48

local lightdark = 'light'
local home = os.getenv('HOME')
if home then
  local f = io.open('/Users/brian/.config/lightdark')
  if f then
    lightdark = f:read('*l')
    print(lightdark)
  end
end
-- print(io.open('/Users/brian/.config/lightdark'))

if lightdark == 'light' then
  config.color_scheme = 'Catppuccin Latte'
else
  config.color_scheme = 'Catppuccin Macchiato'
end
config.font_size = 18.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font = wezterm.font_with_fallback{
  {
    family = 'TX-02',
    stretch = 'SemiCondensed',
    weight = 300
  },
  {
    family = 'JetBrainsMono Nerd Font Mono',
    scale = 1.2,
    weight = 300,
  }
}
-- config.use_cap_height_to_scale_fallback_fonts = true

-- 1234567890

-- config.use_resize_increments = true
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 1.00
-- config.macos_window_background_blur = 10
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
	font = wezterm.font({ family = 'TX-02', stretch = 'SemiCondensed' }),
	font_size = 14,
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
  local MAX_WIDTH = MAX_TAB_WIDTH - 12
  local title = tab_info.active_pane.title or tab_info.tab_title

  -- If no explicit title, use current working directory
  if not (title and #title > 0) or title == 'zsh' then
    local cwd = tab_info.active_pane.current_working_dir
    if cwd then
      -- Extract just the directory name
      title = 'zsh ' .. cwd.file_path:gsub(wezterm.home_dir, '~')
    else
      title = tab_info.active_pane.title or 'Tab'
    end
  end

  if #title > MAX_WIDTH then
    title = string.sub(title, 1, MAX_WIDTH) .. '…'
  end

  return title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- catpucciin colours - I tweaked some though
  local GRAY, DARKGRAY, LIGHTGRAY
  local RED = '#f38ba8'
  local PINK = '#f5c2e7'
  local GRAY = '#313244'
  local DARKGRAY = '#11111b'
  local PURPLE = '#7f849c'
  local MAROON = '#f4a6c7'
  local BLUE = '#8AADF4'
  local LAVENDAR = '#b7bdf8'
  local NONE = 'none'
  local BLACK = "#11111b"
  if lightdark == 'dark' then
    GRAY = '#313244'
    DARKGRAY = '#11111b'
    LIGHTGRAY = '#45475a'
  else
    LIGHTGRAY = '#acb0be'
    GRAY = '#ccd0da'
    DARKGRAY = '#eff1f5'
  end

  SEPARATOR = wezterm.nerdfonts.ple_forwardslash_separator    -- \ue0bb 
  UPPER_LEFT = wezterm.nerdfonts.ple_upper_left_triangle -- \ue0bc 
  LOWER_RIGHT = wezterm.nerdfonts.ple_lower_right_triangle -- \ue0ba 

  local fg = function(color) return { Foreground = { Color = color } } end
  local bg = function(color) return { Background = { Color = color } } end
  local text = function(txt) return { Text = (txt or '') } end

  local format = {}
  local c = function(...)
    if ... then
      for i,v in ipairs(table.pack(...)) do
        table.insert(format, v)
      end
    end
  end

  -- local old_fgcolor = NONE
  -- local old_bgcolor = NONE
  -- local section = function(fgcolor, bgcolor, ...)
  --   c(fg(bgcolor), bg(old_bgcolor), text(LOWER_RIGHT))
  --   c(fg(fgcolor), bg(bgcolor), ...)
  -- end

  local next_tab = tabs[tab.tab_index + 2]
  local prev_tab = tabs[tab.tab_index]
  local title = tab_title(tab)
  local number = tostring(tab.tab_index + 1)

  c(bg(NONE))
  if tab.is_active then
    c(fg(BLUE), bg(NONE), text(LOWER_RIGHT))
    c(fg(BLACK), bg(BLUE), text(SEPARATOR), text(' '), text(number), text(' '))

    if #panes > 1 then
      local active
      for _, pane in pairs(panes) do
        if pane.is_active then
          active = pane.pane_index + 1
        end
      end
      if active then
        c(fg(BLUE), bg(LAVENDAR), text(UPPER_LEFT))
        c(fg(BLACK), bg(LAVENDAR), text(tostring(active)))
        c(fg(LAVENDAR), bg(PINK), text(UPPER_LEFT))
      end
    else
      c(fg(PINK), bg(BLUE), text(LOWER_RIGHT))
    end

    c(fg(BLACK), bg(PINK), text(' '), text(title), text(' '))
    c(fg(PINK), bg(RED), text(UPPER_LEFT))
    c(fg(BLACK), text(SEPARATOR), text(SEPARATOR))
    c(fg(RED), bg(NONE), text(UPPER_LEFT))
  else
    c(fg(LIGHTGRAY), bg(NONE), text(LOWER_RIGHT))
    c(fg(DARKGRAY), bg(LIGHTGRAY), text(number))
    c(fg(LIGHTGRAY), bg(GRAY), text(UPPER_LEFT))
    c(fg(PURPLE), text(' '), text(title), text(' '))
    c(fg(GRAY), bg(NONE), text(UPPER_LEFT))
  end


  return format
end)

config.use_fancy_tab_bar = false
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

  { mods = 'CMD|SHIFT', key = 'o', action = wezterm.action.Multiple {
      wezterm.action.SendKey { key = 'Space' },
      wezterm.action.SendKey { key = 'Space' },
    },
  },

  { mods = 'CMD|SHIFT', key = 'f', action = wezterm.action.Multiple {
      wezterm.action.SendKey { key = 'Space' },
      wezterm.action.SendKey { key = '/' },
    },
  },

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
    background = 'none'
  },
}

return config
