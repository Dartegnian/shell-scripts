#! /bin/sh

git_directory="/home/${USER}/SYGtech/goteki-git/darts-dots"

# User configs
cp -r ~/.config/alacritty/ ${git_directory}/pc/home_pc/config/
cp -r  ~/.config/bspwm/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/cava/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/ckb-next/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/compton/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/picom/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/dunst/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/mpd/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/nomacs/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/rofi/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/sxhkd/ ${git_directory}/pc/home_pc/config/
rsync -av --exclude=".*" ~/.config/polybar/ ${git_directory}/pc/home_pc/config/polybar/ &> /dev/null

# Home directory configs
cp ~/.tmux.conf ${git_directory}/pc/home_pc/config/tmux/tmux.conf
cp ~/.zshrc ${git_directory}/pc/home_pc/zsh/
cp $XDG_CONFIG_HOME/alsa/asoundrc/asound.conf ${git_directory}/pc/home_pc/pulseaudio/

# System-wide configs
cp /etc/X11/xorg.conf ${git_directory}/pc/home_pc/X.Org/
cp /etc/nginx/nginx.conf ${git_directory}/pc/home_pc/nginx/
cp /etc/pulse/daemon.conf ${git_directory}/pc/home_pc/pulseaudio/
cp /etc/asound.conf ${git_directory}/pc/home_pc/pulseaudio/
cp /etc/default/grub ${git_directory}/pc/home_pc/grub/
cp /etc/mkinitcpio.conf ${git_directory}/pc/home_pc/mkinitcpio/

# GNU/Linux + AUR packages
paru -Qq > ${git_directory}/pc/home_pc/gloriousArchPackages.txt
paru -Qqe > ${git_directory}/pc/home_pc/gloriousUserPackages.txt

# NPM packages
npm list -g --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${git_directory}/pc/home_pc/npm/globalPackages.txt
