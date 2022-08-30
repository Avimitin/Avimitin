local api = require("wezterm")

return {
	font = api.font("BlexMono Nerd Font Mono"),
	font_size = 11,
	window_background_opacity = 0.8,
	force_reverse_video_cursor = true,
	window_padding = {
		left = 0,
		right = 2,
		top = 0,
		bottom = 0,
	},
	enable_scroll_bar = true,
	use_fancy_tab_bar = false,
	keys = {
		{
			key = "n",
			mods = "CTRL|SHIFT",
			action = api.action.SplitVertical({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "n",
			mods = "CTRL",
			action = api.action.SplitHorizontal({
				domain = "CurrentPaneDomain",
			}),
		},
	},
	colors = {
		foreground = "#dcd7ba",
		background = "#1f1f28",

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
	},
}
