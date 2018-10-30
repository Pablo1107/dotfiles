-- For the the tag's icon you have to install ttf-font-awesome

local awful = require("awful")
-- {{{ Tags 
tags = {
   names = { "", "", "", "", "", ""},
   layout = { layouts[2], layouts[3], layouts[3], layouts[3], layouts[6], layouts[5] }
}
for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
	-- tags[s] = awful.tag(tags.names, s, layouts[1])
end
-- }}}