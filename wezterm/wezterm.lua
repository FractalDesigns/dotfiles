local wezterm = require("wezterm")

-- Create a config object
local config = {}

-- Detect if running on macOS
local is_macos = wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin"

-- Apply settings
config.font_dirs = { os.getenv("HOME") .. "/.local/share/fonts" }
config.audible_bell = "Disabled"
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:" .. os.getenv("PATH"),
}
config.window_close_confirmation = "NeverPrompt"
-- config.default_prog = { "tmux", "new", "-c", wezterm.home_dir .. "/code", "-f", "~/.config/tmux/tmux.conf" }
config.default_prog = { "nu" }
config.color_scheme = "Catppuccin Mocha"
config.enable_tab_bar = false
config.font_size = 16.0
config.font = wezterm.font("Victor Mono")

-- config.font = wezterm.font("OpenDyslexicM Nerd font Mono")
config.warn_about_missing_glyphs = false
config.macos_window_background_blur = 30
config.window_background_opacity = 0.9
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
}
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

-- Set window decorations to RESIZE on macOS only
if is_macos then
	config.window_decorations = "RESIZE"
end

return config
