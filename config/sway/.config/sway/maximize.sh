#!/bin/bash

# un/maximize script for i3 and sway
# bindsym $mod+m exec ~/.config/i3/maximize.sh

WRKSPC_FILE=~/.config/wrkspc
RESERVED_WORKSPACE=10
MSG=swaymsg
if [ "$XDG_SESSION_TYPE" == "x11"]
then
	MSG=i3-msg
fi

# using xargs to remove quotes
CURRENT_WORKSPACE=$($MSG -t get_workspaces | jq '.[] | select(.focused==true) | .name' | xargs)

if [ -f "$WRKSPC_FILE" ]
then # restore window back
  if [ "$CURRENT_WORKSPACE" != "$RESERVED_WORKSPACE" ]
  then
    RESERVED_WORKSPACE_EXISTS=$($MSG -t get_workspaces | jq '.[] .num' | grep "^$RESERVED_WORKSPACE$")
    if [ -z "$RESERVED_WORKSPACE_EXISTS" ]
    then
      notify-send "Reserved workspace $RESERVED_WORKSPACE does not exist. Noted."
      rm -f $WRKSPC_FILE
    else
      notify-send "Clean your workspace $RESERVED_WORKSPACE first."
    fi
  else
    # move the window back
    $MSG move container to workspace number $(cat $WRKSPC_FILE)
    $MSG workspace number $(cat $WRKSPC_FILE)
    notify-send "Returned back to workspace $(cat $WRKSPC_FILE)."
    rm -f $WRKSPC_FILE
  fi
else # send window to the reserved workspace
  if [ "$CURRENT_WORKSPACE" == "$RESERVED_WORKSPACE" ]
  then
    notify-send "You're already on reserved workspace $RESERVED_WORKSPACE."
  else
    # remember current workspace
    echo $CURRENT_WORKSPACE > $WRKSPC_FILE
    $MSG move container to workspace number $RESERVED_WORKSPACE
    $MSG workspace number $RESERVED_WORKSPACE
    notify-send "Saved workspace $CURRENT_WORKSPACE and moved to workspace $RESERVED_WORKSPACE."
  fi
fi
