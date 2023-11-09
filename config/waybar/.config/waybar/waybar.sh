#!/usr/bin/env sh

# Terminate already running bar instances
killall -q .waybar-wrapped

# Wait until the processes have been shut down
while pgrep -x .waybar-wrapped >/dev/null; do sleep 1; done

# Launch main
waybar
