local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local lain      = require("lain")
local vicious   = require("vicious")

-- {{{ Wibox

markup = lain.util.markup
separators = lain.util.separators

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

-- calendar
-- lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

-- Pacman Notifier
pacwidget = wibox.widget.textbox()

pacwidget_t = awful.tooltip({ objects = { pacwidget},})

vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return "ᗧ: " .. args[1] .. " act. pendientes "
                end, 1800, "Arch")

                --'1800' means check every 30 minutes

-- MPD
mpdicon = wibox.widget.imagebox(beautiful.widget_music)
--mpdicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end)))
mpdwidget = lain.widgets.mpd({
    cover_size=150,
    music_dir="/home/sergio/.config/mpd/music/",
    default_art="/home/sergio/Música/default_cover.gif",
    settings = function()
        if mpd_now.state == "play" then
            artist = " " .. mpd_now.artist .. " - "
            title  = mpd_now.title  .. " "
            mpdicon:set_image(beautiful.widget_music_on)
            elseif mpd_now.state == "pause" then
                artist = " mpd "
                title  = "paused "
            else
                artist = ""
                title  = ""
                mpdicon:set_image(beautiful.widget_music)
            end
            mpd_notification_preset = {
                title   = "Now playing",
                timeout = 10,
                text    = string.format("%s - %s\n%s", mpd_now.artist,
                mpd_now.album, mpd_now.title)
            }
            widget:set_markup(markup("#FFFFFF", artist) .. title)
        end
    })

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_battery)
batwidget = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            widget:set_markup(" AC ")
            baticon:set_image(beautiful.widget_ac)
            return
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(beautiful.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(beautiful.widget_battery_low)
        else
            baticon:set_image(beautiful.widget_battery)
        end
        widget:set_markup(" " .. bat_now.perc .. "% ")
    end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volicon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end)))
-- volicon:buttons(awful.util.table.join(awful.button({ }, 5, function () awful.util.spawn(string.format("amixer -c %s set %s 1+", volumewidget.card, volumewidget.channel),false) end)))
-- volicon:buttons(awful.util.tab|le.join(awful.button({ }, 4, function () awful.util.spawn(string.format("amixer -c %s set %s 1-", volumewidget.card, volumewidget.channel),false) end)))
volumewidget = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(beautiful.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(beautiful.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(beautiful.widget_vol_low)
        else
            volicon:set_image(beautiful.widget_vol)
        end

        widget:set_text(" " .. volume_now.level .. "% ")
    end
})

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
neticon:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn_with_shell(iptraf) end)))
netwidget = lain.widgets.net({
    settings = function()
        widget:set_markup(markup("#ffffff", " " .. net_now.received)
                          .. " " ..
                          markup("#ffffff", " " .. net_now.sent .. " "))
    end
})

-- Separators
spr = wibox.widget.textbox(' ')
arrl = wibox.widget.imagebox()
arrl:set_image(beautiful.arrl)
arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha") 
arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus) 
arrr_dl = separators.arrow_right(beautiful.bg_focus, "alpha") 
arrr_ld = separators.arrow_right("alpha", beautiful.bg_focus) 

-- Create a wibox for each screen and add it
mywibox = {}
mybottomwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ 
                                                      theme={ width=250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout.forced_width = 700;
    left_layout:add(mylauncher)
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    -- left_layout:add(arrr_dl)

    -- Widgets that are aligned to the upper right
    local right_layout_toggle = true
    local function right_layout_add (...)  
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
                right_layout:add(wibox.widget.background(n ,beautiful.bg_focus))
            end
        else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end
    
    right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    -- right_layout:add(spr)
    -- right_layout:add(arrl)
    right_layout_add(mpdicon, mpdwidget)
    right_layout_add(volicon, volumewidget)
    --right_layout_add(mailicon, mailwidget)
    right_layout_add(memicon, memwidget)
    right_layout_add(cpuicon, cpuwidget)
    right_layout_add(tempicon, tempwidget)
    --right_layout_add(fsicon, fswidget)
    right_layout_add(pacwidget)
    -- right_layout_add(baticon, batwidget)
    right_layout_add(neticon,netwidget)
    right_layout_add(mytextclock, spr)
    right_layout_add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)

    -- Create the bottom wibox
    -- mybottomwibox[s] = awful.wibox({ position = "bottom", screen = s, height = 18 })
    --
    -- Widgets that are aligned to the bottom left
    --bottom_left_layout = wibox.layout.fixed.horizontal()
    --bottom_left_layout:add(mylauncher)

    -- Widgets that are aligned to the bottom right
    --bottom_right_layout = wibox.layout.fixed.horizontal()

    -- Now bring it all together (with the tasklist in the middle)
    -- bottom_layout = wibox.layout.align.horizontal()
    --bottom_layout:set_left(bottom_left_layout)
    -- bottom_layout:set_middle(mytasklist[s])
    --bottom_layout:set_right(bottom_right_layout)
    -- mybottomwibox[s]:set_widget(bottom_layout)

    -- Create a borderbox above the bottomwibox
    --lain.widgets.borderbox(mybottomwibox[s], s, { position = "top", color = "#0099CC" } )
end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}