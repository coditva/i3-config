#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the top bar
polybar --config="$HOME/.config/i3/polybar/config" top &


echo "Bars launched..."
