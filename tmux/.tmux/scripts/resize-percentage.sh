#!/bin/bash
dflag=
pflag=
while getopts d:p: name;
do
    case $name in
    d)    dflag=1
          dimension=$OPTARG;;
    p)    pflag=1
          percentage="$OPTARG";;
    ?)   printf "Usage: %s: [-d dimension] [-p percentage]\n" $0
          exit 2;;
    esac
done

if [ ! -z "$pflag" ]; then
    if ! [ "$percentage" -eq "$percentage" ] 2> /dev/null; then
        printf "Percentage (-p) must be an integer" >&2
        exit 1
    fi
fi

if [ ! -z "$dflag" ]; then
    if [ $dimension != 'width' ] && [ $dimension != 'height' ] ; then
        printf "dimension should be width or height" >&2
        exit 1
    fi
fi

if [ "$dimension" = "width" ]; then
    PANE_SIZE=$(expr $(tmux display -p '#{window_width}') \* $percentage \/ 100)
    tmux resize-pane -x $PANE_SIZE
fi

if [ "$dimension" = "height" ]; then
    PANE_SIZE=$(expr $(tmux display -p '#{window_height}') \* $percentage \/ 100)
    tmux resize-pane -y $PANE_SIZE
fi

exit 0
