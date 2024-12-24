local api = require("wezterm")
local act = api.action

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
	tab_bar = {
		background = "rgba(0% 0% 0% 0%)",
		active_tab = {
			bg_color = "rgba(0% 0% 0% 0%)",
			fg_color = "#7fb4ca",
		},
		inactive_tab = {
			bg_color = "rgba(0% 0% 0% 0%)",
			fg_color = "#727169",
		},
		new_tab = {
			bg_color = "rgba(0% 0% 0% 0%)",
			fg_color = "#727169",
		},
	},
}

return {
	font_size = 12,
	window_background_opacity = 0.85,
	text_background_opacity = 1,
	force_reverse_video_cursor = true,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 0,
	},
	enable_scroll_bar = false,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	colors = kanagawa,

	-- Key binding
	disable_default_key_bindings = true,
	keys = {
		{ key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
		{ key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },

		{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },

		{ key = "X", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },

		{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
		{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "PageUp", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
		{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
		{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "PageDown", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },
		{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },
		{ key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },
		{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
		{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
	},
}
