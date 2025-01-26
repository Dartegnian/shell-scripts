#!/bin/sh
# Script to run video wallpapers on both HDMI-1 (bottom) and HDMI-2 (top) monitors with subtitles turned off

# Kill any existing xwinwrap processes
killall xwinwrap

# Start xwinwrap with mpv for the bottom monitor (HDMI-1)
xwinwrap -g 1920x1080+0+1080 -fdt -ni -b -un -- mpv --no-stop-screensaver --loop --no-audio --no-border --no-osc --no-osd-bar --no-sub --no-input-default-bindings -wid WID "$1" > /dev/null 2>&1 &

# Start xwinwrap with mpv for the top monitor (HDMI-2)
#xwinwrap -g 1920x1080+0+0 -fdt -ni -b -un -- mpv --no-stop-screensaver --loop --no-audio --no-border --no-osc --no-osd-bar --no-sub --no-input-default-bindings -wid WID "$2" > /dev/null 2>&1 &

