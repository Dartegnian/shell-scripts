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
