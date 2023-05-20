#! /usr/bin/env bash

docker system prune -a -f
pacman -Sc --noconfirm
