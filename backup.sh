#! /bin/sh

git_directory="/home/${USER}/SYGtech/goteki-git/darts-dots"
device_category="pc"
distro_name=$(cat /etc/*-release | grep DISTRIB_ID.* | grep -o -P "[^DISTRIB_ID=].*" | sed 's/"//g'| awk '{print tolower($0)}')
computer_name="main-pc"
backup_folder_location="${git_directory}/${device_category}/${distro_name}-${computer_name}"
etc_folder_location="${backup_folder_location}/etc"

# User configs
cp -r ~/.config/alacritty/ ${backup_folder_location}/config/
cp -r  ~/.config/bspwm/ ${backup_folder_location}/config/
# cp -r ~/.config/cava/ ${backup_folder_location}/config/
# cp -r ~/.config/ckb-next/ ${backup_folder_location}/config/
cp -r ~/.config/compton/ ${backup_folder_location}/config/
cp -r ~/.config/picom/ ${backup_folder_location}/config/
# cp -Lr ~/.config/dunst/ ${backup_folder_location}/config/
# cp -r ~/.config/nomacs/ ${backup_folder_location}/config/
cp -r ~/.config/mpv/ ${backup_folder_location}/config/
cp -r ~/.config/rofi/ ${backup_folder_location}/config/
cp -r ~/.config/sxhkd/ ${backup_folder_location}/config/
cp -r ~/.config/wal/ ${backup_folder_location}/config/
cp ~/.config/alsa/asoundrc/asound.conf ${etc_folder_location}/pulseaudio/
cp ~/.config/tmux/tmux.conf ${backup_folder_location}/config/tmux/tmux.conf
rsync -av --exclude="/plugins" ~/.config/ranger/ ${backup_folder_location}/config/ranger/ &> /dev/null
rsync -av --exclude=".*" ~/.config/polybar/ ${backup_folder_location}/config/polybar/ &> /dev/null

# MPD
cp ~/.config/mpd/mpd.conf ${backup_folder_location}/config/mpd/
cp ~/.config/ncmpcpp/config ${backup_folder_location}/config/ncmpcpp/
cp ~/.config/mpDris2/mpDris2.conf ${backup_folder_location}/config/mpDris2/
cp ~/.config/mpDris2/mpDris2.conf ${backup_folder_location}/config/mpDris2/
cp ~/.config/miniplayer/config ${backup_folder_location}/config/miniplayer/

# Zsh
cp ~/.config/zsh/.zshrc ${backup_folder_location}/config/zsh/
rsync -av --exclude=".*" ~/.config/zsh/sources/ ${backup_folder_location}/config/zsh/sources/ &> /dev/null

# System-wide configs
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

# GNU/Linux + AUR packages
paru -Qq > ${backup_folder_location}/gloriousArchPackages.txt
paru -Qqe > ${backup_folder_location}/gloriousUserPackages.txt

# NPM packages
npm list -g --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${backup_folder_location}/npm/globalPackages.txt
