#!/usr/bin/env zsh

update_space() {
    SPACE_ID=$(aerospace list-workspaces --focused)

    case $SPACE_ID in
    # 1)
    #     ICON=󰅶
    #     ICON_PADDING_LEFT=7
    #     ICON_PADDING_RIGHT=7
    #     ;;
    *)
        ICON=$SPACE_ID
        ICON_PADDING_LEFT=9
        ICON_PADDING_RIGHT=10
        ;;
    esac

    sketchybar --set $NAME \
        icon=$ICON \
        icon.padding_left=$ICON_PADDING_LEFT \
        icon.padding_right=$ICON_PADDING_RIGHT
}

update_space
