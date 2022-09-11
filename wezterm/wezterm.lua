local api = require("wezterm")

return {
	font = api.font_with_fallback({
		"mononoki Nerd Font Mono",
		"JetbrainsMono Nerd Font Mono",
		"Noto Sans CJK SC",
	}),
	font_size = 11,
	window_background_opacity = 0.75,
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
	color_scheme = "tokyonight-storm"
}
