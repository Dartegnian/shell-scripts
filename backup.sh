#! /usr/bin/env bash

git_directory="/home/${USER}/SYGtech/goteki-git/darts-dots"
device_category="pc"
distro_name=$(cat /etc/*-release | grep DISTRIB_ID.* | grep -o -P "[^DISTRIB_ID=].*" | sed 's/"//g'| awk '{print tolower($0)}')
computer_name="main-pc"
backup_folder_location="${git_directory}/${device_category}/${distro_name}-${computer_name}"
conf_folder_location="${backup_folder_location}/config"
etc_folder_location="${backup_folder_location}/etc"
misc_folder_location="${backup_folder_location}/misc"

# User configs
# cp -r ~/.config/compton/ ${conf_folder_location}/
# cp -Lr ~/.config/dunst/ ${conf_folder_location}/
cp -r ~/.config/mpv/ ${conf_folder_location}/
cp -r ~/.config/rofi/ ${conf_folder_location}/
cp ~/.config/tmux/tmux.conf ${conf_folder_location}/tmux/tmux.conf
rsync -av --exclude="/plugins" ~/.config/ranger/ ${conf_folder_location}/ranger/ &> /dev/null
rsync -av --exclude=".*" ~/.config/polybar/ ${conf_folder_location}/polybar/ &> /dev/null

# MPD
cp ~/.config/mpd/mpd.conf ${conf_folder_location}/mpd/
cp ~/.config/ncmpcpp/config ${conf_folder_location}/ncmpcpp/

# Zsh
cp ~/.config/zsh/.zshrc ${conf_folder_location}/zsh/
rsync -av --exclude=".*" ~/.config/zsh/sources/ ${conf_folder_location}/zsh/sources/ &> /dev/null

# System-wide configs
cp /etc/fstab ${etc_folder_location}/fstab/
cp /etc/X11/xorg.conf ${etc_folder_location}/X.Org/
cp /etc/nginx/nginx.conf ${etc_folder_location}/nginx/
cp /etc/pulse/daemon.conf ${etc_folder_location}/pulseaudio/
cp /etc/asound.conf ${etc_folder_location}/pulseaudio/
cp /etc/default/grub ${etc_folder_location}/grub/
cp /etc/makepkg.conf ${etc_folder_location}/makepkg/
cp /etc/mkinitcpio.conf ${etc_folder_location}/mkinitcpio/
cp /etc/pacman.conf ${etc_folder_location}/pacman/
cp -R /etc/pacman.d/hooks ${etc_folder_location}/pacman/
cp /etc/xdg/reflector/reflector.conf ${etc_folder_location}/reflector/
cp -R /etc/pam.d/login ${etc_folder_location}/pam.d/
cp /etc/ntp.conf ${etc_folder_location}/ntp/

# GNU/Linux + AUR packages
paru -Qq > ${backup_folder_location}/gloriousArchPackages.txt
paru -Qqe > ${backup_folder_location}/gloriousUserPackages.txt

# NPM packages
npm list --location=global --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${misc_folder_location}/npm/globalPackages.txt
