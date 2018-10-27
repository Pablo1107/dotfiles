require 'awm-global-libraries'

require 'awm-error-handling'

require 'awm-autostart-apps'

require 'awm-settings'

require 'awm-tags'

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
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

myawesomemenu = {
   { "manual", terminal .. " -e 'man awesome'" },
   { "edit config", "subl3 " .. config_file},
   { "edit theme", "subl3 " .. theme_dir .. "/theme.lua" },
   { "restart", awesome.restart },
   { "quit", function () awesome.quit() end }
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

-- {{{ Signals
-- signal function to execute when a new client appears.
local sloppyfocus_last = {c=nil}
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    client.connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            -- Skip focusing the client if the mouse wasn't moved.
            --if c ~= sloppyfocus_last.c then
                client.focus = c
                --sloppyfocus_last.c = c
            --end
        end
    end)

    if not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.centered(c)
        --awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.floatingbutton(c))
        left_layout:add(awful.titlebar.widget.stickybutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=18}):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    -- c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    c.border_width = 0
                else
                    -- c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}

