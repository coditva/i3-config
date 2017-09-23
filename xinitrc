#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


# set the background
feh --bg-scale ~/.wallpaper.jpg &

# turn off the cpu default bell
xset -b

# enable window compositing
compton --shadow --fading --fade-delta=1 --blur-background --paint-on-overlay --alpha-step=0.1 --inactive-opacity-override --daemon

# enable touchpad basics
xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Tapping Enabled" 1 &
xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Natural Scrolling Enabled" 1 &

# start i3 and keep it running
exec i3
