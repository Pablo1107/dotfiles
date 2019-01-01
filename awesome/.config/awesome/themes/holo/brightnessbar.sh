#!/bin/bash
brightnessbarfull="$HOME/.config/awesome/themes/holo/icons/volumebarunmuted.png"
brightnessbar="$HOME/.config/awesome/themes/holo/icons/volumebar.png"

isMuted="$(pacmd list-sinks | awk '/muted/ {print $2}' <(pacmd list-sinks))"

barwidth="$(expr $1 \* 61 / 100)"
if [ $barwidth != "0" ]; then
	convert $brightnessbarfull -resize $barwidth! $brightnessbar
else
	convert $brightnessbarfull -resize 1! $brightnessbar
fi
echo "$brightnessbar"
