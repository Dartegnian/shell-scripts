#! /bin/sh

git_directory="/home/${USER}/SYGtech/goteki-git/darts-dots"
device_category="pc"
distro_name=$(cat /etc/*-release | grep DISTRIB_ID.* | grep -o -P "[^DISTRIB_ID=].*" | sed 's/"//g'| awk '{print tolower($0)}')
computer_name="main-pc"
backup_folder_location="${git_directory}/${device_category}/${distro_name}-${computer_name}"

# User configs
cp -r ~/.config/alacritty/ ${backup_folder_location}/config/
cp -r  ~/.config/bspwm/ ${backup_folder_location}/config/
cp -r ~/.config/cava/ ${backup_folder_location}/config/
# cp -r ~/.config/ckb-next/ ${backup_folder_location}/config/
cp -r ~/.config/compton/ ${backup_folder_location}/config/
cp -r ~/.config/picom/ ${backup_folder_location}/config/
cp -r ~/.config/dunst/ ${backup_folder_location}/config/
cp -r ~/.config/mpd/ ${backup_folder_location}/config/
cp -r ~/.config/nomacs/ ${backup_folder_location}/config/
cp -r ~/.config/rofi/ ${backup_folder_location}/config/
cp -r ~/.config/sxhkd/ ${backup_folder_location}/config/
rsync -av --exclude="/plugins" ~/.config/ranger/ ${backup_folder_location}/config/ranger/ &> /dev/null
rsync -av --exclude=".*" ~/.config/polybar/ ${backup_folder_location}/config/polybar/ &> /dev/null

# Home directory configs
cp ~/.tmux.conf ${backup_folder_location}/config/tmux/tmux.conf
cp ~/.zshrc ${backup_folder_location}/zsh/
cp $XDG_CONFIG_HOME/alsa/asoundrc/asound.conf ${backup_folder_location}/pulseaudio/

# System-wide configs
cp /etc/X11/xorg.conf ${backup_folder_location}/X.Org/
cp /etc/nginx/nginx.conf ${backup_folder_location}/nginx/
cp /etc/pulse/daemon.conf ${backup_folder_location}/pulseaudio/
cp /etc/asound.conf ${backup_folder_location}/pulseaudio/
cp /etc/default/grub ${backup_folder_location}/grub/
cp /etc/mkinitcpio.conf ${backup_folder_location}/mkinitcpio/
cp /etc/pacman.conf ${backup_folder_location}/pacman/
cp -R /etc/pacman.d/hooks ${backup_folder_location}/pacman/
cp /etc/xdg/reflector/reflector.conf ${backup_folder_location}/reflector/

# GNU/Linux + AUR packages
paru -Qq > ${backup_folder_location}/gloriousArchPackages.txt
paru -Qqe > ${backup_folder_location}/gloriousUserPackages.txt

# NPM packages
npm list -g --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${backup_folder_location}/npm/globalPackages.txt
