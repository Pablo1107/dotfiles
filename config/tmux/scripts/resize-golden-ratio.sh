#!/bin/sh
dflag=
while getopts d: name;
do
    case $name in
    d)    dflag=1
          dimension=$OPTARG;;
    ?)   printf "Usage: %s: [-d dimension]\n" $0
          exit 2;;
    esac
done

if [ ! -z "$dflag" ]; then
    if [ $dimension != 'width' ] && [ $dimension != 'height' ] ; then
        printf "dimension should be width or height" >&2
        exit 1
    fi
fi

if [ "$dimension" = "width" ]; then
    PANE_SIZE=$(expr $(tmux display -p '#{window_width}') \* 618 \/ 1000)
    tmux resize-pane -x $PANE_SIZE
fi

if [ "$dimension" = "height" ]; then
    PANE_SIZE=$(expr $(tmux display -p '#{window_height}') \* 618 \/ 1000)
    tmux resize-pane -y $PANE_SIZE
fi

exit 0
