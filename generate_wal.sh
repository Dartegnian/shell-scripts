#! /usr/bin/env zsh

wallpaper=""
darkman_setting=$(darkman get)

if [[ $1 ]]; then
	wallpaper=$1
	nitrogen --set-zoom-fill --save $wallpaper
else
	wallpaper=$(grep -P "file=*" /home/dartegnian/.config/nitrogen/bg-saved.cfg -m 1)
fi


if [[ $2 ]]; then
	if [[ $darkman_setting == "light" ]]; then
		wal -tnql -i "${wallpaper/file=/}"
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
	else
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
		wal -tnq -i "${wallpaper/file=/}"
	fi
else
	if [[ $darkman_setting == "light" ]]; then
		wal -tnl -i "${wallpaper/file=/}"
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
	else
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
		wal -tn -i "${wallpaper/file=/}"
	fi
fi

killall -q dunst && (dunst -conf /home/dartegnian/.config/dunst/dunstrc >/dev/null 2>&1 &)

source "${HOME}/.cache/wal/colors.sh"
transparency="90"
transparency_alt="00"
primary=$color0
secondary=$color6
tertiary=$color1
quaternary=$color4
quinary=$color3
senary=$color5
septenary=$color2

if [[ $darkman_setting == "light" ]]; then
    sed -i "s/\(active-background: #\)[0-9A-Fa-f]\{6\}/\1${primary:1}${transparency}/" /home/dartegnian/.cache/wal/colors-rofi-light.rasi
else
    sed -i "s/\(active-background: #\)[0-9A-Fa-f]\{6\}/\1${primary:1}${transparency}/" /home/dartegnian/.cache/wal/colors-rofi-dark.rasi
fi

echo "#$transparency${primary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-1
echo "#$transparency${secondary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-2
echo "#$transparency_alt${secondary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-2t
echo "#$transparency${tertiary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-3
echo "#$transparency${quaternary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-4
echo "#$transparency${quinary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-5
echo "#$transparency${senary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-6
echo "#$transparency${septenary/\#/}" >/home/dartegnian/.cache/wal/colors-polybar-bg-7

bspc config presel_feedback_color "$secondary"
pywal-discord
pywalfox update
oomox-cli -o oomox-xresources -m all /opt/oomox/scripted_colors/xresources/xresources >/dev/null
    
if [[ $(pacman -Qi wal-telegram) ]]; then
	wal-telegram
fi

# notify wallpaper image set
notify-send "Your wallpaper has been set!" $wallpaper -i $wallpaper
