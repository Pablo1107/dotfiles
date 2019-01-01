gears     	= require("gears")
awful     	= require("awful")
awful.rules = require("awful.rules")
              require("awful.autofocus")
wibox     	= require("wibox")
beautiful 	= require("beautiful")
-- naughty   = require("naughty")
lain      	= require("lain")
menubar 	= require("menubar")
--local freedesktop = require('freedesktop')
--freedesktop.utils.icon_theme = 'Numix Circle'
xdg_menu 	= require("archmenu")

-- Desktop Notification
-- if naughty_on then
    naughty   = require("naughty")
-- end

local volnoti_id = nil
volnotify = function (msg)
	awful.spawn.easy_async_with_shell("/home/pablo1107/.config/awesome/themes/holo/volumebar.sh " .. msg, function(stdout, stderr, reason, exit_code)
        volnoti_id = naughty.notify({
	    	icon = stdout:gsub("%s+", ""),
	    	height = 20,
	    	font = "Tamsyn 7",
	    	text = msg:gsub("%s+", "") .. "%",
	    	timeout = 1,
	    	position = "top_left",
	    	replaces_id = volnoti_id
	    }).id
    end)
end

local brightnoti_id = nil
brightnotify = function (msg)
	awful.spawn.easy_async_with_shell("/home/pablo1107/.config/awesome/themes/holo/brightnessbar.sh " .. msg, function(stdout, stderr, reason, exit_code)
        brightnoti_id = naughty.notify({
	    	icon = stdout:gsub("%s+", ""),
	    	height = 20,
	    	font = "Tamsyn 7",
	    	text = msg:gsub("%s+", "") .. "%",
	    	timeout = 1,
	    	position = "top_left",
	    	replaces_id = brightnoti_id
	    }).id
    end)
end