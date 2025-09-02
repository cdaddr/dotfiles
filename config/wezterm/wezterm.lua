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
-- 1234567890
config.font = wezterm.font_with_fallback{
  {
    family = 'TX-02',
    stretch = 'SemiCondensed',
    weight = 300
  },
  {
    family = 'JetBrainsMono Nerd Font Mono',
    weight = 300,
  }
}
-- config.use_cap_height_to_scale_fallback_fonts = true

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

local TABBAR = '#1e2030'

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local GRAY, DARKGRAY, LIGHTGRAY, OVERLAY, SURFACE
  local palette = {
    rosewater = "#f4dbd6",
    flamingo = "#f0c6c6",
    pink = "#f5bde6",
    mauve = "#c6a0f6",
    red = "#ed8796",
    maroon = "#ee99a0",
    peach = "#f5a97f",
    yellow = "#eed49f",
    green = "#a6da95",
    teal = "#8bd5ca",
    sky = "#91d7e3",
    sapphire = "#7dc4e4",
    blue = "#8aadf4",
    lavender = "#b7bdf8",
    text = "#cad3f5",
    subtext1 = "#b8c0e0",
    subtext0 = "#a5adcb",
    overlay2 = "#939ab7",
    overlay1 = "#8087a2",
    overlay0 = "#6e738d",
    surface2 = "#5b6078",
    surface1 = "#494d64",
    surface0 = "#363a4f",
    base = "#24273a",
    mantle = "#1e2030",
    crust = "#181926",
    black = "#000000",
    none = TABBAR
  }

  LOWER_LEFT = '\u{231D}'
  LEFT_BORDER = '\u{258f}'
  LEFT_BORDER_THICK = '\u{258c}'
  RIGHT_BORDER = '\u{1fb87}'

  local fg = function(color) return { Foreground = { Color = color } } end
  local bg = function(color) return { Background = { Color = color } } end
  local text = function(...) local args = {...};  return { Text = (args and table.concat(args, '') or '') } end

  local format = {}
  local c = function(...)
    if ... then
      for i,v in ipairs(table.pack(...)) do
        table.insert(format, v)
      end
    end
  end

  local super = function(n)
    local sup = {
        utf8.char(0x00B9), -- ¹
        utf8.char(0x00B2), -- ²
        utf8.char(0x00B3), -- ³
        utf8.char(0x2074), -- ⁴
        utf8.char(0x2075), -- ⁵
        utf8.char(0x2076), -- ⁶
        utf8.char(0x2077), -- ⁷
        utf8.char(0x2078), -- ⁸
        utf8.char(0x2079)  -- ⁹
    }
    local sub = {
      utf8.char(0x2081), -- ₁
      utf8.char(0x2082), -- ₂
      utf8.char(0x2083), -- ₃
      utf8.char(0x2084), -- ₄
      utf8.char(0x2085), -- ₅
      utf8.char(0x2086), -- ₆
      utf8.char(0x2087), -- ₇
      utf8.char(0x2088), -- ₈
      utf8.char(0x2089)  -- ₉
    }

    if n >= 1 and n <= 9 then
      return sub[n]
    else
      return '\u{208a}' -- subscript ₊
    end
  end

  local next_tab = tabs[tab.tab_index + 2]
  local prev_tab = tabs[tab.tab_index]
  local title = tab_title(tab)
  local number = tostring(tab.tab_index + 1)

  local bg_tab, fg_tab, bg_number, fg_border
  if tab.is_active then
    bg_tab = bg(palette.lavender)
    fg_tab = fg(palette.black)
    bg_number = bg(palette.blue)
    fg_border = fg(palette.lavender)

  else
    bg_tab = bg(palette.surface0)
    fg_tab = fg(palette.overlay2)
    bg_number = bg(palette.surface1)
    fg_border = fg(palette.surface2)
  end

  c(bg_number, fg_border, text(LEFT_BORDER))
  c(bg_number, fg_tab, text(number, ' '))

  if tab.is_active and #panes > 1 then
    local active
    for _, pane in pairs(panes) do
      if pane.is_active then
        active = pane.pane_index + 1
      end
    end
    if active then
      c(text(super(active)))
    end
  end

  c(bg_tab, fg_tab)
  c(text(' ', title, ' '))
  if tab.is_active then
    c(fg_tab, text(LOWER_LEFT))
  else
    c(text(' '))
  end

  c(bg(palette.none), text(' '))

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
    background = TABBAR
  },
}

return config
