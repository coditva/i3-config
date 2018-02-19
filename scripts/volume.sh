#!/bin/bash

# some config
urgency="low"
expire_time=1


# return volume as an integer (without '%')
function parse_volume() {
    echo "$(echo $out | grep -E -o '[0-9]{1,3}?' | tail -1)"
}

# check if muted
function is_muted() {
    echo "$(echo $out | grep -E -o '\[[a-z]*\]' | grep -E -o '[a-z][a-z][a-z]?'| head -1)"
}

# returns icon according to the integer passed
function get_icon() {
    icon_base="notification-audio-volume"
    if [[ "$1" -lt 33 ]]; then
        echo "$icon_base-low"
    elif [[ "$1" -lt 66 ]]; then
        echo "$icon_base-medium"
    else
        echo "$icon_base-high"
    fi
}

# send a notification
function send_notification() {
    notify-send --icon "$icon" \
        --hint int:value:$volume \
        --urgency $urgency \
        --expire-time $expire_time \
        Volume
}


# take action according to args
function take_action() {
    case "$1" in
        "toggle" )
            amixer set Master toggle;;
        "+" )
            amixer set Master $2%+;;
        "-" )
            amixer set Master $2%-;;
    esac
}


out=$(take_action $1 $2)
volume=$(parse_volume)
muted=$(is_muted)
case "$muted" in
    "off" )
        volume=0
        icon="notification-audio-volume-muted"
        ;;
    "on" )
        icon=$(get_icon $volume)
        ;;
esac
send_notification
