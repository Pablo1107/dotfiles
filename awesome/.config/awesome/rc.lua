require 'awm-global-libraries'

require 'awm-error-handling'

require 'awm-autostart-apps'

require 'awm-settings'

require 'awm-tags'

-- {{{ Wallpaper
-- if beautiful.wallpaper then
--     for s = 1, screen.count() do
--         gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--     end
-- end
-- }}}

-- {{{ Menu
-- TODO: Make a xfce-like menu
--mymainmenu = awful.menu.new({ items = require("menugen").build_menu(),
                              --theme = { height = 16, width = 130 }})
--mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     --menu = mymainmenu })
-- applications menu
--freedesktop.utils.terminal = terminal -- default: "xterm"

--menu_items = freedesktop.menu.new()

-- myawesomemenu = {
--    { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help-about' }) },
--    { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", freedesktop.utils.lookup_icon({ icon = 'preferences-desktop' }) },
--    { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'system-reboot' }) },
--    { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'application-exit' }) }
-- }

require 'awm-exit-screen'

myawesomemenu = {
   { "manual", terminal .. " -e 'man awesome'" },
   { "edit config", "subl3 " .. config_file},
   { "edit theme", "subl3 " .. theme_dir .. "/theme.lua" },
   { "restart", awesome.restart },
   --{ "quit", function () awesome.quit() end }
   { "quit", function () exit_screen_show() end }
}

--table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
--table.insert(menu_items, { "shutdown", function() awful.util.spawn_with_shell("oblogout") end, freedesktop.utils.lookup_icon({icon = 'system-shutdown'}) })
--table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'utilities-terminal'}) })

--mymainmenu = awful.menu({ items = menu_items })
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
									{ "Applications", xdgmenu },
									{ "open terminal", terminal } }
						})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
	
-- end freedesktop
-- }}}

require 'awm-statusbar'

require 'awm-bindings'

require 'awm-rules'

require 'awm-signals'
