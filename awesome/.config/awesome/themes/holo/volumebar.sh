#!/bin/bash
volumebarunmuted="$HOME/.config/awesome/themes/holo/icons/volumebarunmuted.png"
volumebarmuted="$HOME/.config/awesome/themes/holo/icons/volumebarmuted.png"
volumebar="$HOME/.config/awesome/themes/holo/icons/volumebar.png"

isMuted="$(pacmd list-sinks | awk '/muted/ {print $2}' <(pacmd list-sinks))"

barwidth="$(expr $1 \* 61 / 100)"
if [ $barwidth != "0" ]; then
	if [ $isMuted = "no" ]; then
		convert $volumebarunmuted -resize $barwidth! $volumebar
	else
		convert $volumebarmuted -resize $barwidth! $volumebar
	fi
else
	if [ $isMuted = "no" ]; then
		convert $volumebarunmuted -resize 1! $volumebar
	else
		convert $volumebarmuted -resize 1! $volumebar
	fi
fi
echo "$volumebar"
