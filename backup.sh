#! /bin/sh

git_directory="/home/${USER}/SYGtech/git_gtech/darts-dots"

cp -r ~/.config/alacritty/ ${git_directory}/pc/home_pc/config/
cp -r  ~/.config/bspwm/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/cava/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/ckb-next/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/compton/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/mpd/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/nomacs/ ${git_directory}/pc/home_pc/config/
rsync -av --exclude=".*" ~/.config/polybar/ ${git_directory}/pc/home_pc/config/polybar/ &> /dev/null
cp -r ~/.config/rofi/ ${git_directory}/pc/home_pc/config/
cp -r ~/.config/sxhkd/ ${git_directory}/pc/home_pc/config/

cp ~/.tmux.conf ${git_directory}/pc/home_pc/tmux
cp ~/.zshrc ${git_directory}/pc/home_pc/zsh
cp /etc/X11/xorg.conf ${git_directory}/pc/home_pc/X.Org/
cp /etc/pulse/daemon.conf ${git_directory}/pc/home_pc/pulseaudio
cp /etc/asound.conf ${git_directory}/pc/home_pc/pulseaudio
cp ~/.asoundrc/asound.conf ${git_directory}/pc/home_pc/pulseaudio

yay -Qq > ${git_directory}/pc/home_pc/gloriousArchPackages.txt
yay -Qqe > ${git_directory}/pc/home_pc/gloriousUserPackages.txt

npm list -g --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${git_directory}/pc/home_pc/npm/globalPackages.txt
