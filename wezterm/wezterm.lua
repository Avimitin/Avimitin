local api = require("wezterm")

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
		"mononoki Nerd Font Mono",
		"Noto Sans CJK SC",
		"Noto Color Emoji"
	}),
	font_size = 12,
	window_background_opacity = 0.65,
	text_background_opacity = 0.65,
	force_reverse_video_cursor = true,
	window_padding = {
		left = 0,
		right = 15,
		top = 0,
		bottom = 0,
	},
	enable_scroll_bar = true,
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
	},
	colors = kanagawa
}
