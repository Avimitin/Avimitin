local api = require("wezterm")
local action = api.action

local kanagawa = {
	foreground = "#dcd7ba",
	background = "#0A0E14",
	cursor_bg = "#c8c093",
	cursor_fg = "#c8c093",
	cursor_border = "#c8c093",
	selection_fg = "#c8c093",
	selection_bg = "#2d4f67",
	scrollbar_thumb = "#16161d",
	split = "#16161d",
	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}

return {
	font = api.font_with_fallback({
		"BlexMono Nerd Font Mono",
		"Noto Sans CJK SC",
		"Noto Color Emoji",
		"Broot Icons Visual Studio Code",
	}),
	font_size = 10,
	window_background_opacity = 0.80,
	text_background_opacity = 0.80,
	force_reverse_video_cursor = true,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 0,
	},
	enable_scroll_bar = false,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	keys = {
		{
			key = "=",
			mods = "CTRL",
			action = api.action.SplitVertical({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "-",
			mods = "CTRL",
			action = api.action.SplitHorizontal({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "j",
			mods = "CTRL|SHIFT",
			action = action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CTRL|SHIFT",
			action = action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = action.ActivatePaneDirection("Right"),
		},
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = action.ActivatePaneDirection("Left"),
		},
		{
			key = "g",
			mods = "CTRL|SHIFT",
			action = action.SpawnCommandInNewTab({
				args = { "lazygit" },
			}),
		},
	},
	colors = kanagawa,
}
