#!/bin/zsh
set -x

STEP="5"
UNIT="%"

SETVOL="/usr/bin/amixer -q sset Master"
STATE=$(amixer get Master | grep Left | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]')

case "$1" in
    "up")
        $SETVOL $STEP$UNIT+
        ;;
    "down")
        $SETVOL $STEP$UNIT-
        ;;
    "mute")
        $SETVOL toggle
        ;;
esac

STATE=$(amixer get Master | grep Left | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]')
VOLUME=$(amixer get Master | grep 'Front Left:' | grep -E -o "[0-9]+%" | tr -d %)


if [ $VOLUME -eq 0 ]; then
  	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_00.png"' | awesome-client
	echo 'volnoti()' | awesome-client
else
	if [ $VOLUME -gt 95 ] && [ $VOLUME -le 999 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_100.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 0 ] && [ $VOLUME -le 5 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_05.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 5 ] && [ $VOLUME -le 10 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_10.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 10 ] && [ $VOLUME -le 15 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_15.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 15 ] && [ $VOLUME -le 20 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_20.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 20 ] && [ $VOLUME -le 25 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_25.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 25 ] && [ $VOLUME -le 30 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_30.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 30 ] && [ $VOLUME -le 35 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_35.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 35 ] && [ $VOLUME -le 40 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_40.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 40 ] && [ $VOLUME -le 45 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_45.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 45 ] && [ $VOLUME -le 50 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_50.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 50 ] && [ $VOLUME -le 55 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_55.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 55 ] && [ $VOLUME -le 60 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_60.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 60 ] && [ $VOLUME -le 65 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_65.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 65 ] && [ $VOLUME -le 70 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_70.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 70 ] && [ $VOLUME -le 75 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_75.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 75 ] && [ $VOLUME -le 80 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_80.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 80 ] && [ $VOLUME -le 85 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_85.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 85 ] && [ $VOLUME -le 90 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_90.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

	if [ $VOLUME -gt 90 ] && [ $VOLUME -le 95 ]; then
	echo 'volnotiicon="/home/tpflug/.config/awesome/icons/noti/bar_95.png"' | awesome-client
	echo 'volnoti()' | awesome-client
	return 0
	fi

fi

exit 0
