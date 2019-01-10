local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local lain      = require("lain")
local vicious   = require("vicious")
local gears     = require("gears")
local shape     = require("gears.shape")

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Wibox

markup = lain.util.markup
separators = lain.util.separators

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = wibox.widget.textclock(" %a %d %b  %H:%M")

-- calendar
-- lain.widgets.calendar:attach(mytextclock, { font_size = 10 })

-- Pacman Notifier
pacwidget = wibox.widget.textbox()

pacwidget_t = awful.tooltip({ objects = { pacwidget},})

awful.spawn.easy_async("checkupdates", function(stdout, stderr, reason, exit_code)
    naughty.notify { text = stdout }
    vicious.register(
        pacwidget,
        vicious.widgets.pkg,
        function(widget,args)
            local s = stdout
            local str = ''
            local i = 0

            for line in string.gmatch(s,'[^\r\n]+') do
                str = str .. line .. "\n"
                i = i + 1
            end
            pacwidget_t:set_text(str)
            return "ᗧ: " .. i .. " act. pendientes "
        end, 1800, "Arch")

        --'1800' means check every 30 minutes
end)

-- {{{ Wibar
local markup = lain.util.markup
local blue   = "#80CCE6"
local space3 = markup.font("Tamsyn 3", " ")

-- -- Clock and Calendar
local mytextclock = wibox.widget.textclock(markup("#b5beca", space3 .. "%A %d %b %y ł %T   " .. markup.font("Tamsyn 4", " ")), 1)
-- local clock_icon = wibox.widget.imagebox(beautiful.clock)
-- local clockbg = wibox.container.background(mytextclock, beautiful.bg_focus, shape.rectangle)
-- local clockwidget = wibox.container.margin(clockbg, 0, 3, 5, 5)

-- local mytextcalendar = wibox.widget.textclock(markup("#FFFFFF", space3 .. "%d %b " .. markup.font("Tamsyn 5", " ")))
-- local calendar_icon = wibox.widget.imagebox(beautiful.calendar)
-- local calbg = wibox.container.background(mytextcalendar, beautiful.bg_focus, shape.rectangle)
-- local calendarwidget = wibox.container.margin(calbg, 0, 0, 5, 5)
local cal = lain.widget.cal {
   attach_to = { mytextclock },
   notification_preset = { fg = "#FFFFFF", bg = beautiful.notification_bg, position = "top_middle", font = "Monospace 10" }
}

--[[ Mail IMAP check
-- commented because it needs to be set before use
local mail = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = "#FFFFFF"
        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup(blue, mail) .. markup("#FFFFFF", count))
    end
})
--]]

-- MPD
local mpd_icon = awful.widget.launcher({ image = beautiful.mpd, command = musicplr })
local prev_icon = wibox.widget.imagebox(beautiful.prev)
local next_icon = wibox.widget.imagebox(beautiful.nex)
local stop_icon = wibox.widget.imagebox(beautiful.stop)
local pause_icon = wibox.widget.imagebox(beautiful.pause)
local play_pause_icon = wibox.widget.imagebox(beautiful.play)
mpd = lain.widget.mpd({
    music_dir = "/home/pablo1107/Musica",
    settings = function ()
        if mpd_now.state == "play" then
            mpd_now.artist = mpd_now.artist:gsub("&.-;", string.lower)
            mpd_now.title = mpd_now.title:gsub("&.-;", string.lower)
            widget:set_markup(markup.font("Tamsyn 4", " ")
                              .. markup.font(beautiful.taglist_font,
                              " " .. mpd_now.artist
                              .. " - " ..
                              mpd_now.title .. "  ") .. markup.font("Tamsyn 5", " "))
            play_pause_icon:set_image(beautiful.pause)
        elseif mpd_now.state == "pause" then
            widget:set_markup(markup.font("Tamsyn 4", " ") ..
                              markup.font(beautiful.taglist_font, " Pausado... ") ..
                              markup.font("Tamsyn 5", " "))
            play_pause_icon:set_image(beautiful.play)
        else
            widget:set_markup("")
            play_pause_icon:set_image(beautiful.play)
        end
    end
})
local musicbg = wibox.container.background(mpd.widget, beautiful.bg_focus, shape.rectangle)
local musicwidget = wibox.container.margin(musicbg, 0, 0, 5, 5)

musicwidget:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.spawn.with_shell(musicplr) end)))
prev_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.spawn.with_shell("mpc prev || ncmpc prev || pms prev")
    mpd.update()
end)))
next_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    awful.spawn.with_shell("mpc next || ncmpc next || pms next")
    mpd.update()
end)))
stop_icon:buttons(awful.util.table.join(awful.button({}, 1,
function ()
    play_pause_icon:set_image(beautiful.play)
    awful.spawn.with_shell("mpc stop || ncmpc stop || pms stop")
    mpd.update()
end)))
play_pause_icon:buttons(awful.util.table.join(

awful.button({}, 1,
function ()
    awful.spawn.with_shell("mpc toggle || ncmpc toggle || pms toggle")
    mpd.update()
end),

awful.button({ "Shift" }, 1,
function ()
    naughty.notify({ text = "Fading music..." })
    awful.spawn.easy_async("mpc-fade",
    function(stdout, stderr, reason, exit_code)
        mpd.update()
    end)
end)

))

-- Battery

local bat = lain.widget.bat({
    settings = function()
        bat_header = " BAT: "
        bat_p      = bat_now.perc .. " % "
        if bat_now.ac_status == 1 then
            bat_p = bat_p .. "Plugged "
        end
        widget:set_markup(markup(blue, bat_header) .. bat_p)
    end
})
local batbg = wibox.container.background(bat.widget, beautiful.bg_focus, shape.rectangle)
local batwidget = wibox.container.margin(batbg, 0, 0, 5, 5)

awful.spawn.easy_async_with_shell(
  "upower -i /org/freedesktop/UPower/devices/battery_BAT0 | " ..
  "awk '/power supply/ { print $3 }' | tr -d ' \t\n\r'",
  function(stdout, stderr, reason, exit_code)
    if string.find(stdout, "no") then
      batwidget.visible = false
    end
  end
)

-- ALSA volume bar
volume = lain.widget.alsabar({
    notifications = { font = "Monospace", font_size = 10 },
    --togglechannel = "IEC958,3",
    width = 75, height = 2, border_width = 0,
    colors = {
        background = "#383838",
        unmute     = "#80CCE6",
        mute       = "#FF9F9F"
    },
})

volume.bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn(string.format("%s -e alsamixer", terminal))
    end),
    awful.button({}, 2, function() -- middle click
        os.execute(string.format("%s set %s 100%%", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 3, function() -- right click
        os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
        volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
        os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
        volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
        os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
        volume.update()
    end)
))

local volumebg = wibox.container.background(volume.bar, beautiful.bg_focus, shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, 0, 0, 5, 5)
volumebg.shape_border_width = 7
volumebg.shape_border_color = beautiful.bg_focus

-- MEM
local memicon = wibox.widget.imagebox(beautiful.mem)
local mem = lain.widget.mem({
    settings = function()
        -- widget:set_text(" " .. mem_now.used .. "MB ")
        widget:set_markup(markup.font("Tamsyn 1", " ") .. mem_now.used .. " MB " .. markup.font("Tamsyn 2", " "))
    end
})
local membg = wibox.container.background(mem.widget, beautiful.bg_focus, shape.rectangle)
local memwidget = wibox.container.margin(membg, 0, 0, 5, 5)


-- CPU
local cpuicon = wibox.widget.imagebox(beautiful.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        -- widget:set_text(" " .. cpu_now.usage .. "% ")
        widget:set_markup(markup.font("Tamsyn 1", " ") .. cpu_now.usage .. " % " .. markup.font("Tamsyn 2", " "))
    end
})
local cpubg = wibox.container.background(cpu.widget, beautiful.bg_focus, shape.rectangle)
local cpuwidget = wibox.container.margin(cpubg, 0, 0, 5, 5)

-- Coretemp
-- local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
local tempico = wibox.widget.textbox('<span font="Tamsyn 7">ł</span>')
local tempicobg = wibox.container.background(tempico, beautiful.bg_focus, shape.rectangle)
local tempicon = wibox.container.margin(tempicobg, 0, 0, 5, 5)
local temp = lain.widget.temp({
    settings = function()
        widget:set_text(" " .. coretemp_now .. "°C ")
    end
})
local tempbg = wibox.container.background(temp.widget, beautiful.bg_focus, shape.rectangle)
local tempwidget = wibox.container.margin(tempbg, 0, 0, 5, 5)

-- Net
local netdown_icon = wibox.widget.imagebox(beautiful.net_down)
local netup_icon = wibox.widget.imagebox(beautiful.net_up)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font("Tamsyn 1", " ") .. net_now.received .. " - "
                          .. net_now.sent .. markup.font("Tamsyn 2", " "))
    end
})
local netbg = wibox.container.background(net.widget, beautiful.bg_focus, shape.rectangle)
local networkwidget = wibox.container.margin(netbg, 0, 0, 5, 5)

-- System tray
local systraywidget = wibox.widget.systray()
local systray       = wibox.container.margin(systraywidget, 0, 0, 5, 5)

-- Weather
local myweather = lain.widget.weather({
    city_id = 2643743, -- placeholder (London)
    notification_preset = { font = "Monospace 9", position = "bottom_right" },
})

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- shows used (percentage) and remaining space in home partition
--local fsroothome = lain.widget.fs({
--    settings  = function()
--        widget:set_text(" : " ..  fs_now["/home"].percentage .. "% (" ..
--        round(fs_now["/home"].free, 2) .. " " .. fs_now["/home"].units .. " left)")
--    end,
--    notification_preset = { font = "Monospace 9", position = "bottom_left" }
--
--})
--local fsrhbg = wibox.container.background(fsroothome.widget, beautiful.bg_focus, shape.rectangle)
--local fsrhwidget = wibox.container.margin(fsrhbg, 5, 0, 5, 5)

-- output example: "/home: 37% (239.4 Gb left)"

-- Separators
local first = wibox.widget.textbox('<span font="Tamsyn 7"> </span>')
local spr_small = wibox.widget.imagebox(beautiful.spr_small)
local spr_very_small = wibox.widget.imagebox(beautiful.spr_very_small)
local spr_right = wibox.widget.imagebox(beautiful.spr_right)
local spr_bottom_right = wibox.widget.imagebox(beautiful.spr_bottom_right)
local spr_left = wibox.widget.imagebox(beautiful.spr_left)
local bar = wibox.widget.imagebox(beautiful.bar)
local bottom_bar = wibox.widget.imagebox(beautiful.bottom_bar)

-- Create a wibox for each screen and add it
local taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local barcolor  = gears.color({
    type  = "linear",
    from  = { 32, 0 },
    to    = { 32, 32 },
    stops = { {0, beautiful.bg_focus }, {0.25, "#505050"}, {1, beautiful.bg_focus} }
})

awful.screen.connect_for_each_screen(function(s)
    -- Quake application
    s.quake = lain.util.quake({ app = terminal })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons, {bg_focus = barcolor})

    mytaglistcont = wibox.container.background(s.mytaglist, beautiful.bg_focus, shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, 0, 0, 5, 5)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, { bg_focus = beautiful.bg_focus, shape = shape.rectangle, shape_border_width = 5, shape_border_color = beautiful.tasklist_bg_normal, align = "center" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        expand = "none",
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            s.mytag,
            -- spr_small,
            s.mylayoutbox,
            -- spr_small,
            s.mypromptbox,
        },
        mytextclock, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mail,
            -- spr_right,
            musicwidget,
            bar,
            prev_icon,
            next_icon,
            stop_icon,
            play_pause_icon,
            bar,
            mpd_icon,
            --bar,
            --spr_very_small,
            volumewidget,
            spr_left,
        },
    }

    -- s.mywibox:set_expand(none)

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 32 })
    -- s.borderwibox = awful.wibar({ position = "bottom", screen = s, height = 1, bg = beautiful.fg_focus, x = 0, y = 33})

    -- Add widgets to the wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            fsrhwidget,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            calendarwidget,
            pacwidget,
            -- spr_bottom_right,
            systray,
            netdown_icon,
            networkwidget,
            netup_icon,
            -- bottom_bar,
            memicon,
            memwidget,
            cpuicon,
            cpuwidget,
            tempicon,
            tempwidget,
            batwidget,
            -- bottom_bar,
            -- calendar_icon,
            -- calendarwidget,
            -- bottom_bar,
            spr_left,
        },
    }

    -- -- Add widgets to the bottom wibox
    -- s.mybottomwibox:setup {
    --     layout = wibox.layout.align.horizontal,
    --     { -- Left widgets
    --         layout = wibox.layout.fixed.horizontal,
    --         mylauncher,
    --     },
    --     s.mytasklist, -- Middle widget
    --     { -- Right widgets
    --         layout = wibox.layout.fixed.horizontal,
    --         spr_bottom_right,
    --         netdown_icon,
    --         networkwidget,
    --         netup_icon,
    --         bottom_bar,
    --         cpu_icon,
    --         cpuwidget,
    --         bottom_bar,
    --         -- calendar_icon,
    --         -- calendarwidget,
    --         bottom_bar,
    --     },
    -- }
end)
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}
