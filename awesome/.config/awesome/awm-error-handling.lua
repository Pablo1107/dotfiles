-- {{{ Error handling
if awesome.startup_errors then
    -- if naughty_on then
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, there were errors during startup!",
                         text = awesome.startup_errors })
    -- else
    --     awful.util.spawn("notify-send \"Oops, there were errors during startup!\" \"" .. awesome.startup_errors .. "\"")
    -- end
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        if naughty_on then
            naughty.notify({ preset = naughty.config.presets.critical,
                             title = "Oops, an error happened!",
                             text = err })
        else
            awful.util.spawn("notify-send \"Oops, an error happened!\" \"" .. err .. "\"")
        end
        in_error = false
    end)
end
-- }}}