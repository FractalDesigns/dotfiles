local wezterm = require("wezterm")

return {
	font_dirs = { os.getenv("HOME") .. "/.local/share/fonts" },
	--window_decorations = "None",
	audible_bell = "Disabled",
	set_environment_variables = {
		PATH = "/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:" .. os.getenv("PATH"),
	},
	window_close_confirmation = "NeverPrompt",
	default_prog = { "tmux", "new", "-c", wezterm.home_dir .. "/code" },
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 16.0,
	-- font = wezterm.font("JetBrains Mono"),
	font = wezterm.font("Victor Mono"), --installed from https://rubjo.github.io/victor-mono/

	-- font_dirs = { "~/.local/share/fonts/" },
	macos_window_background_blur = 30,
	window_background_opacity = 1.0,
	keys = {
		{
			key = "f",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
	window_padding = {
		left = 2,
		right = 2,
		top = 0,
		bottom = 0,
	},
}
