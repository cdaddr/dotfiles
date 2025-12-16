-- Import the wezterm module
local wezterm = require 'wezterm'
local theme = require 'theme'
local config = wezterm.config_builder()

local MAX_TAB_WIDTH = 48

config.tab_max_width = MAX_TAB_WIDTH
config.initial_cols = 160
config.initial_rows=48

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

-- Use theme from generated config
config.color_scheme = theme.wezterm
config.font_size = 17.0
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
    weight = "Regular",
    scale = 1.2
  }
}
-- 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
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

-- Load theme colors
local colors = theme.colors

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local palette = {
    primary = colors.primary,
    accent = colors.accent,
    muted = colors.muted,
    error = colors.error,
    fg_inverse = colors.fg_inverse,
    bg_light = colors.bg_light,
    bg_lighter = colors.bg_lighter,
    bg_dark = colors.bg_dark,
    none = colors.bg_dark
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
    bg_tab = bg(palette.accent)
    fg_tab = fg(palette.fg_inverse)
    bg_number = bg(palette.primary)
    fg_border = fg(palette.accent)

  else
    bg_tab = bg(palette.bg_light)
    fg_tab = fg(palette.muted)
    bg_number = bg(palette.bg_light)
    fg_border = fg(palette.bg_lighter)
  end

  c(bg_number, fg_border, text(LEFT_BORDER))
  c(bg_number, fg_tab, text(number))

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

  c(text(' '))

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

config.quit_when_all_windows_are_closed = false

config.enable_kitty_keyboard = true
config.keys = {}
-- map CMD+letter to <Space>w<letter> so I can remap them in nvim
-- wezterm prefix is <leader>wz, matching my nvim config
-- this only performed if the active process is neovim
-- local letter = string.byte("A")
-- while letter <= string.byte("z") do
--   local char = string.char(letter)
--   table.insert(config.keys,
--     { mods = "CMD",
--       key = char,
--       action = wezterm.action_callback(function(window, pane)
--         local process = pane:get_foreground_process_info()
--         if process and process.name and process.name:find("nvim") then
--           window:perform_action(
--             wezterm.action.Multiple {
--               wezterm.action.SendKey { key = 'Space' },
--               wezterm.action.SendKey { key = 'w' },
--               wezterm.action.SendKey { key = 'z' },
--               wezterm.action.SendKey { key = char }},
--           pane)
--         end
--       end)
--     })
--   letter = letter + 1
-- end

local keys = {
  { mods = 'NONE', key = 'Delete', action = wezterm.action.SendKey{ key = "Delete" }},
  { mods = 'NONE', key = 'Escape', action = wezterm.action.SendKey{ key = "Escape" }},
  -- home/end
	{ mods = 'CMD', key = "LeftArrow", action = wezterm.action.SendKey { key = 'Home', } },
	{ mods = 'CMD', key = "RightArrow", action = wezterm.action.SendKey { key = 'End', } },

  -- split
	{ mods = 'CMD', key = "d", action = wezterm.action.SplitPane { direction = 'Right', size = { Percent = 25 } } },
	{ mods = 'CMD', key = "D", action = wezterm.action.SplitPane { direction = 'Down', size = { Percent = 25 } } },
	{ mods = 'CMD', key = "\\", action = wezterm.action.SplitPane { direction = 'Right' } },
	{ mods = 'CMD', key = "-", action = wezterm.action.SplitPane { direction = 'Down' } },
  { mods = 'CMD', key = "t", action = wezterm.action.SpawnTab 'CurrentPaneDomain' },

  -- toggle zoom for output pane (bottom/right pane, only works with exactly 2 panes)
  { mods = 'CMD', key = "z", action = wezterm.action_callback(function(window, pane)
    local tab = window:active_tab()
    local panes = tab:panes_with_info()

    if #panes ~= 2 then
      window:toast_notification('wezterm', 'Zoom toggle requires exactly 2 panes', nil, 1000)
      return
    end

    -- Determine if horizontal or vertical split
    local is_horizontal = panes[1].top ~= panes[2].top

    -- Find the output pane (bottom-most for horizontal, right-most for vertical)
    local output_pane, other_pane
    if is_horizontal then
      if panes[1].top > panes[2].top then
        output_pane = panes[1]
        other_pane = panes[2]
      else
        output_pane = panes[2]
        other_pane = panes[1]
      end
    else
      if panes[1].left > panes[2].left then
        output_pane = panes[1]
        other_pane = panes[2]
      else
        output_pane = panes[2]
        other_pane = panes[1]
      end
    end

    if output_pane.is_zoomed then
      -- Output pane is zoomed, unzoom and switch to other pane
      window:perform_action(wezterm.action.TogglePaneZoomState, output_pane.pane)
      other_pane.pane:activate()
    else
      -- Switch to output pane and zoom it
      output_pane.pane:activate()
      window:perform_action(wezterm.action.TogglePaneZoomState, output_pane.pane)
    end
  end) },

  -- wezterm defaults we want to keep
  -- { mods = 'CMD', key = 'c', action = wezterm.action.CopyTo 'Clipboard' },
  -- { mods = 'CMD', key = 'v', action = wezterm.action.PasteFrom 'Clipboard' },
  -- { mods = 'CMD', key = 'n', action = wezterm.action.SpawnWindow },
  -- { mods = 'CMD', key = 'r', action = wezterm.action.ReloadConfiguration },
  -- { mods = 'CMD', key = 'w', action = wezterm.action.CloseCurrentTab{ confirm = true } },
  -- { mods = 'CMD', key = '{', action = wezterm.action.ActivateTabRelative(-1) },
  -- { mods = 'CMD', key = '}', action = wezterm.action.ActivateTabRelative(1) },
  -- { mods = 'CMD', key = 'f', action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
  { mods = 'CMD', key = 'f', action = wezterm.action.DisableDefaultAssignment},
  { mods = 'CMD|SHIFT', key = 'f', action = wezterm.action.DisableDefaultAssignment},
  { mods = 'CMD', key = 'F', action = wezterm.action.DisableDefaultAssignment},
  { mods = 'CMD|SHIFT', key = 'F', action = wezterm.action.DisableDefaultAssignment},

  -- command palette
	{ mods = 'CMD|SHIFT', key = "P", action = wezterm.action.ActivateCommandPalette },

}

for _, item in pairs(keys) do
  config.keys[#config.keys + 1] = item
end

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
    background = colors.bg_dark
  },
}
config.debug_key_events = true

return config
