#! /bin/sh

gitDirectory="/home/${USER}/SYGtech/git_gtech/darts-dots"

cp -r ~/.config/alacritty/ ${gitDirectory}/pc/home_pc/config/
cp -r  ~/.config/bspwm/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/cava/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/ckb-next/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/compton/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/mpd/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/nomacs/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/polybar/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/rofi/ ${gitDirectory}/pc/home_pc/config/
cp -r ~/.config/sxhkd/ ${gitDirectory}/pc/home_pc/config/

cp ~/.tmux.conf ${gitDirectory}/pc/home_pc/tmux
cp ~/.zshrc ${gitDirectory}/pc/home_pc/zsh

yay -Qq > ${gitDirectory}/pc/home_pc/gloriousArchPackages.txt
yay -Qqe > ${gitDirectory}/pc/home_pc/gloriousUserPackages.txt

npm list -g --depth=0 --parseable=true | sed -n -e 's/^.*node_modules\///p' > ${gitDirectory}/pc/home_pc/npm/globalPackages.txt
