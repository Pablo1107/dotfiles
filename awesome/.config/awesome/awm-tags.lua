local awful = require("awful")
-- {{{ Tags
tags = {
   names = { "", "", "", "", ""},
   layout = { layouts[2], layouts[5], layouts[5], layouts[3], layouts[6] }
}
for s = 1, screen.count() do
	tags[s] = awful.tag(tags.names, s, tags.layout)
	-- tags[s] = awful.tag(tags.names, s, layouts[1])
end
-- }}}