-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = {
    border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons,
    size_hints_honor = false },
    callback = awful.client.setslave},
    { rule_any = { class = { "Xfce4-panel", "Xfdesktop" } },
    properties = { focus = false, raise = false, border_width = 0 } },
    { rule = { class = "MPlayer" },
    properties = { floating = true } },
    { rule = { name = "alsamixer" },
    properties = { floating = true } },
    { rule = { name = "Preferencias de Firefox" },
    properties = { floating = true } },
    { rule = { class = "Pcmanfm" },
    properties = { floating = true } },
    { rule = { class = "pinentry" },
    properties = { floating = true } },
    { rule = { class = "gimp" },
    properties = { floating = true } },
    --{ rule = { class = "Conky" },
    --properties = { border_width = 0 } },
    --{ rule = { class = "Gnome-system-monitor" },
    --callback = awful.titlebar.hide },
    { rule = { class = "Viewnior" },
    properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
    properties = { tag = tags[1][1] } },
    -- Set subl3 to always map on tags number 2 of screen 1
    { rule_any = { class = { "Subl3", "NetBeans IDE 8.2" }, name = { "Starting NetBeans IDE" } },
    properties = { tag = tags[1][2] } },
    -- Set rhythmbox to always map on tags number 2 of screen 1
    { rule = { class = "Rhythmbox" },
    properties = { tag = tags[1][4] } },
    { rule = { class = "Nautilus" },
    properties = { tag = tags[1][5] } },
}
-- }}}