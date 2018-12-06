#!/bin/sh

echo "Start work"

mkdir cache
today_dir=$(date +"%d.%m.%Y")
echo ${today_dir}
mkdir ${today_dir}

trap ctrl_c INT

function ctrl_c() {
	echo "Work day finish you have $(ls ${today_dir} | wc -l) screens"
	zip -r ${today_dir}.zip ${today_dir}
	exit 0
}

while [[ 1 ]]; do
	date=$(date "+%Y%m%dT%H%M%S")
	countOfMonitors=$(system_profiler SPDisplaysDataType | grep 'Online: Yes' | wc -l)

	screens=()

	for ((i=0;i<countOfMonitors;i++));
	do
    		screens[$i]="cache/screen_$i.png"
	done

	declare screens

	screencapture "${screens[@]}"

	convert "${screens[@]}" +append ${today_dir}/${date}.png
	echo "$(ls ${today_dir} | wc -l) screens"
	sleep 600
done