-- {{{ Autostart applications
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
     findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--run_once("urxvtd -f -q -o")
run_once("compton -b")
run_once("mpd")
run_once("xfce4-clipman")
--run_once("xsetroot -name 'Openzone Black Slim' left_ptr")
--run_once("conky")
--run_once("pcmanfm -d &")
--run_once("xrdb /home/sergio/.Xresources")
--run_once("xsetroot -name 'Openzone Black Slim' left_ptr")
--run_once("/home/sergio/.bin/screen_locker_script.sh")
--run_once("unclutter -root")
-- }}}