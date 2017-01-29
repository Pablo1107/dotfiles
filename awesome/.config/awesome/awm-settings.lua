local awful = require("awful")
local beautiful = require("beautiful")
-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))

theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/holo"
-- beautiful init
beautiful.init(theme_dir .. "/theme.lua")

naughty_on = true

-- common
modkey     = "Mod4"
altkey     = "Mod1"
--terminal   = "urxvtc -e tmux" or "xterm"
terminal   = "termite"
--terminal   = "urxvtc -e /home/sergio/.bin/tmux_attach.sh" or "xterm"
editor     = os.getenv("EDITOR") or "nano" or "vi"
editor_cmd = terminal .. " -e " .. editor
config_file=awful.util.getdir("config") .. "/rc.lua"
 
function edit(file)
	awful.util.spawn("subl3 " .. file)
end

-- user defined
browser    = "luakit"
gui_editor = "subl3"
graphics   = "gimp"
--iptraf     = terminal .. " -g 180x54-20+34 -e sudo iptraf-ng -i all "
musicplr   = "termite -e ncmpcpp"

layouts = {
    awful.layout.suit.floating,
    lain.layout.centerwork,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- --lain.layout.termfair
    -- --lain.layout.uselessfair
}

awful.layout.layouts = layouts
-- }}}