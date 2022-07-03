#! /usr/bin/env bash

playerctl_icon=$(playerctl metadata -f '{{ mpris:artUrl  }}')
filename=""

if [[ "$playerctl_icon" == *"http"* ]]; then
	curl "$playerctl_icon" > /tmp/album-art-icon.jpg
	playerctl_icon="/tmp/album-art-icon.jpg"
fi

yad --notification --image="${playerctl_icon}" --listen &
