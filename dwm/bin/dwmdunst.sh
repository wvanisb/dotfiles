#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Launch dunst daemon
if [[ `pidof dunst` ]]; then
	pkill dunst
fi

dunst -config /usr/share/archcraft/dwm/dunstrc &
