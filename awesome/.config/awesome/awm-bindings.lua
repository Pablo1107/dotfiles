local drop    = require("scratch.drop")
local mpdwidget = mpd

-- {{{ Key bindings
globalkeys = awful.util.table.join(
	awful.key({ modkey } , "r" , function () awful.util.spawn('rofi -show run')    end),
	-- Terminals
    --awful.key({ altkey } , "Return" , function () awful.util.spawn('urxvtc')    end),
    --awful.key({ modkey, "Shift" } , "e" , function () awful.util.spawn('pcmanfm')    end),
    --awful.key({ modkey } , "e" , function () awful.util.spawn('urxvtc -bg "#272727" -depth 24 -e ranger')    end),
    --awful.key({ modkey } , "e" , function () awful.util.spawn('urxvtc -e ranger')    end),
    awful.key({},"XF86Calculator", function () awful.util.spawn('galculator')    end),
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
    awful.key({ }, "Print", function() awful.util.spawn("xfce4-screenshooter") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wiboxes
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            s.mybottomwibox.visible = not s.mybottomwibox.visible
        end
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Toggle gaps
    awful.key({ modkey }, "g", function () 
        if awful.tag.getgap() == beautiful.useless_gap then
            awful.tag.setgap(0)
        else
            awful.tag.setgap(beautiful.useless_gap)
        end
    end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "f", function () awful.util.spawn("nautilus") end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
    awful.key({ modkey,	          }, "x",      function () drop("termite") end),

    -- Widgets popups
    --awful.key({ altkey,           }, "c",      function () lain.widgets.calendar:show(7) end),
    --awful.key({ altkey,           }, "h",      function () fswidget.show(7) end),

    --Volume
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        --awful.util.spawn("amixer set Master 5%+",false) 
        --awful.util.spawn(string.format("amixer -c %s set %s 1+", volumewidget.card, volumewidget.channel),false)
        --awful.util.spawn("amixer set Master 1%+")
        awful.util.spawn("amixer -D pulse set Master 2%+")
        -- volumewidget.update()
    end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
        --awful.util.spawn("amixer set Master 5%-",false) 
        -- awful.util.spawn(string.format("amixer -c %s set %s 1-", volumewidget.card, volumewidget.channel),false)
        --awful.util.spawn("amixer set Master 1%-")
        awful.util.spawn("amixer -D pulse set Master 2%-")
        -- volumewidget.update()
    end),
    awful.key({ }, "XF86AudioMute", function ()
        --awful.util.spawn("amixer sset Master toggle",false) 
        -- awful.util.spawn(string.format("amixer -c %s set %s toggle", volumewidget.card, volumewidget.channel),false)
        --awful.util.spawn("amixer set Master toggle")
        awful.util.spawn("amixer -D pulse set Master toggle")
        -- volumewidget.update()
    end),

    ---- ALSA volume control
    --awful.key({ altkey }, "Up",
        --function ()
            --awful.util.spawn(string.format("amixer -c %s set %s 1+", volumewidget.card, volumewidget.channel))
            --volumewidget.update()
        --end),
    --awful.key({ altkey }, "Down",
        --function ()
            --awful.util.spawn(string.format("amixer -c %s set %s 1-", volumewidget.card, volumewidget.channel))
            --volumewidget.update()
        --end),
    --awful.key({ altkey }, "m",
        --function ()
            --awful.util.spawn(string.format("amixer -c %s set %s toggle", volumewidget.card, volumewidget.channel))
            ----awful.util.spawn(string.format("amixer set %s toggle", volumewidget.channel))
            --volumewidget.update()
        --end),
    --awful.key({ altkey, "Control" }, "m",
        --function ()
            --awful.util.spawn(string.format("amixer -c %s set %s 100%%", volumewidget.card, volumewidget.channel))
            --volumewidget.update()
        --end),

        --Brillo
        awful.key({ }, "XF86MonBrightnessDown", function ()
            awful.util.spawn("xbacklight -dec 5",false) 
        end),
        awful.key({ }, "XF86MonBrightnessUp", function ()
            awful.util.spawn("xbacklight -inc 5",false) 
        end),
         
        -- MPD control
        awful.key({ }, "XF86AudioNext", function ()
            awful.util.spawn_with_shell("mpc next",false) 
            mpdwidget.update()
        end),
        awful.key({ }, "XF86AudioPrev", function ()
            awful.util.spawn_with_shell("mpc prev",false) 
            mpdwidget.update()
        end),
        awful.key({ }, "XF86AudioPlay", function ()
            awful.util.spawn_with_shell("mpc toggle",false) 
            mpdwidget.update()
        end),
        awful.key({ }, "XF86AudioStop", function ()
            awful.util.spawn_with_shell("mpc stop",false) 
            mpdwidget.update()
        end),

    --awful.key({ altkey, "Control" }, "Up",
        --function ()
            --awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
            --mpdwidget.update()
        --end),
    --awful.key({ altkey, "Control" }, "Down",
        --function ()
            --awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
            --mpdwidget.update()
        --end),
    --awful.key({ altkey, "Control" }, "Left",
        --function ()
            --awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
            --mpdwidget.update()
        --end),
    --awful.key({ altkey, "Control" }, "Right",
        --function ()
            --awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
            --mpdwidget.update()
        --end),

    -- Copy to clipboard
    --awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
    --awful.key({ modkey }, "z", function () awful.util.spawn("thunar") end),

    --Screen locker
    --awful.key({ modkey, "Shift", "Control"   }, "l", function () awful.util.spawn('i3lock -i "/home/sergio/Imágenes/Wallpapers/GIMP/Arch_blue.png" -d -I 5 -e -c 333333')    end),
    --awful.key({ modkey, "Shift", "Control"   }, "l", function () awful.util.spawn('i3lock-wrapper -d -I 5 -e') end),
    awful.key({ modkey, }, "p", function () awful.util.spawn('/home/sergio/.bin/lock-screen' ) end),

    -- Menubar
    awful.key({ modkey }, "a", function() menubar.show() end),
    awful.key({ modkey }, "r", function() awful.util.spawn('gmrun',false) end)

    -- Prompt
    --awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    -- awful.key(
    --     { modkey }, "z" },
    --         function ()
    --           awful.prompt.run({ prompt = "Run Lua code: " },
    --           mypromptbox[mouse.screen].widget,
    --           awful.util.eval, nil,
    --           awful.util.getdir("cache") .. "/history_eval")
    --         end
    --     
    -- )
)


clientkeys = awful.util.table.join(
    -- awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}