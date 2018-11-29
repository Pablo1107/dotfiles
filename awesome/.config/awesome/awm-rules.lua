-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        keys = clientkeys,
        buttons = clientbuttons,
        size_hints_honor = false,
        screen = awful.screen.focused,
        opacity = 1,
        maximized = false,
        floating = false,
    }, callback = awful.client.setslave },

    { rule = { },
    except = { name = "feh [1 of 1] - /tmp/mpdcover.png" },
    properties = {
        focus = awful.client.focus.filter,
        raise = true,
    } },

    -- Floating clients.
    { rule_any = {
        instance = {
            "copyq"
        },
        class = {
            "Xfce4-screenshooter",
            "MPlayer",
            "Pcmanfm",
            "pinentry",
            "Viewnior"
        },

        name = {
            "Event Tester",  -- xev.
            "alsamixer",
            "Java",
            "Mezclar carpeta"
        },
        role = {
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            "GtkFileChooserDialog", -- e.g. when you choose a file to open
            "Organizer" -- Firefox Downloads Window
        }
      }, properties = { floating = true } },

    { rule_any = { class = { "Xfce4-panel", "Xfdesktop" } },
    properties = { focus = false, raise = false, border_width = 0 } },
    --{ rule = { class = "Conky" },
    --properties = { border_width = 0 } },
    --{ rule = { class = "Gnome-system-monitor" },
    --callback = awful.titlebar.hide },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule_any = { class = { "Firefox" } },
    properties = { tag = tags[1][1], } },
    { rule = { class = "Firefox", instance = "Dialog" },  -- other dialogs (add class firefox to rules?)
    properties = { floating = true } },
    -- Set subl3 to always map on tags number 2 of screen 1
    { rule_any = { 
        class = {
            "Subl", 
            "NetBeans IDE 8.2",
            "Apache NetBeans IDE 9.0",
            "kdenlive"
        },
        name = {
            "Starting NetBeans IDE",
            "Starting Apache NetBeans IDE"
        }
    }, properties = { tag = tags[1][2], } },
    -- Set rhythmbox to always map on tags number 4 of screen 1
    { rule = { class = "Rhythmbox" },
    properties = { tag = tags.names[4] } },
    { rule = { name = "feh [1 of 1] - /tmp/mpdcover.png" },
    properties = { tag = tags.names[4] } },
    -- Programs to open on folder and documents tag
    { rule_any = { 
        class = {
            "Nautilus",
            "libreoffice"
        }
    }, properties = { tag = tags[1][5] } },
    -- Set Steam to always map on tags number 6 of screen 1
    { rule_any = { class = { "Steam", "Lutris" } },
    properties = { tag = tags[1][6], } },
    { rule_any = { class = { "Wine" } },
    properties = { tag = tags[1][6],} },
}
-- }}}