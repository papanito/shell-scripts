#!/bin/bash
#########################################################
#							#
# This are NScripts v3.6				#
#							#
# Licensed under the GNU GENERAL PUBLIC LICENSE 3	#
#							#
# Copyright 2007 - 2009 Christopher Bratusek		#
#							#
#########################################################

zenity --question --title "Shredder" --text "Really want to shred the selected file(s)?
Shredding means  to *absolutely* delete them!\n
The file is beeing overwritten 50 times and is then very difficult to recover!
\nThe following files are marked to be shred:
$(echo $NAUTILUS_SCRIPT_SELECTED_URIS | sed -e 's/\%20/\ /g' -e 's/.*\///g')"

if (( $? == 0 )); then
	for file in $NAUTILUS_SCRIPT_SELECTED_URIS; do

		shortfile=$(echo $file | sed -e 's/\%20/\ /g' -e 's/.*\///g')
		file_name=$(echo $file | sed -e 's/file:\/\///g' -e 's/\%20/\ /g')

		shred -u -z -n 50 --random-source=/dev/urandom "$file_name"
		if (( $? == 0 )); then
			zenity --info --text="$shortfile has been shred" --title "Success"
		else	zenity --info --text="$shortfile couldn't be shred" --title "Failure"
		fi
	done
fi
