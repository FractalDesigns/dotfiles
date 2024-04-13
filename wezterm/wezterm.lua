local wezterm = require 'wezterm'
-- local mux = wezterm.mux
--
-- wezterm.on('gui-startup', function(cmd)
  -- local project_dir = wezterm.home_dir .. '/code/learning_rust'
  -- local tab, main_pane, window = mux.spawn_window {
  --   workspace = 'test',
  --   cwd = project_dir,
  -- }
--   local second_pane = main_pane:split {
--     direction = 'Right',
--     size = 0.3,
--     cwd = project_dir,
--   }
--
--   --main_pane:send_text 'echo "this is 1st pane"\n'
--   -- second_pane:send_text 'echo "this is 2st pane"\n'
-- end)
--

return {
	-- color_scheme = 'termnial.sexy',

  -- default_prog = { 'tmux', 'new', '-s', 'foo', '-c', '~/code/learning_rust/' },
  default_prog = { 'tmux', 'new', '-c', wezterm.home_dir .. '/code/learning_rust/' },
	color_scheme = 'Catppuccin Mocha',
	enable_tab_bar = false,
	font_size = 16.0,
	-- macos_window_background_blur = 40,
	macos_window_background_blur = 30,
	
	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
	-- window_background_image_hsb = {
	-- 	brightness = 0.01,y
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	-- window_background_opacity = 0.92,
	window_background_opacity = 1.0,
	-- window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	-- window_decorations = 'RESIZE',
	keys = {
		{
			key = 'f',
			mods = 'CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
	},
	mouse_bindings = {
	  -- Ctrl-click will open the link under the mouse cursor
	  {
	    event = { Up = { streak = 1, button = 'Left' } },
	    mods = 'CTRL',
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


