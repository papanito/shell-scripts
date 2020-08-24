#!/bin/bash

#Script Type: Nautilus Script
#Title: Extract Audio
#Dependencies: ffmpeg, zenity
#Author: jim lewellyn (styyle14)

#General Info:
#In naultius scripts, the variable $1 is given to the first file selected, then variable number increases as order of files selected does
#In naultius scripts, the variable $# is given to the number of files selected
#The usage of the action: "shift" decreases $# by 1 makes each variable shift down 1 (e.g. the contents of variable $2 become the contents of variable $1 and so forth)
#zenity is used to create pop-up windows to guide the user through the process (usage is fairly obvious)

#this title will be used for all zenity pop-up windows
title="Extract Audio"

#this part tests to see if ffmpeg is installed, andif not close the script with an error
test_ffmpeg=`which ffmpeg | grep -c "ffmpeg"`
if [ "$test_ffmpeg" -eq "0" ]; then
	zenity --error --title="::Error::" --text="You do not have ffmpeg installed.
	This package is a dependency of this script.
	Please install ffmpeg and try again."
	exit
fi

#this is necessary to handle files with spaces in the name
#default is IFS=$" \t\n" (notice the literal space before "\t")
IFS=$'\t\n'

#this variable defines the text to be used for selections in zenity windows where the user will then type in their own input option
option1="Define your own"

#these options define the height and width of each zenity window so that the ok button appears in the same place for all windows
#not used on windows where user input his/her own value
height="500"
width="500"

#these functions create zenity windows to help define the name, format, bitrate, and number of channels
define_name (){
	filename=${1%.*}
	name=`zenity --height="$height" --width="$width" --title="$title" --text="How would you like to name your file?" --list --radiolist --column="" \
		--column="Name" \
		TRUE "$option1" \
		FALSE "$filename" `

	if [ "$name" = "$option1" ]; then 
		name=`zenity --title="$title" --text="Name of new file (without extension):" --entry `
	fi

	if [ ! "$name" ]; then 
		zenity --error --title="::Error::" --text="Please choose a name for the new audio file and try again." 
		exit
	fi
}
define_format (){
	format=`zenity --height="$height" --width="$width" --title="$title" --text="Which audio format would you like to convert to?" --list --radiolist --column="" \
		--column="Name" \
		TRUE "mp3" \
		FALSE "ogg" \
		FALSE "flac" \
		FALSE "wav" \
		FALSE "wma" \
		FALSE "$option1" `

	if [ "$format" = "$option1" ]; then 
		format=`zenity --title="$title" --text="Type the extension of the audio format you wish to use:
		(Must be ffmpeg compatible)" --entry `
	fi

	if [ ! "$format" ]; then 
		zenity --error --title="::Error::" --text="Please choose a format for the new audio file and try again." 
		exit
	fi
}
define_bitrate (){
	bitrate=`zenity --height="$height" --width="$width" --title="$title" --text="At what bitrate would you like to encode this file?
	Currently this script only handles mp3 and wma bitrates.
	(The other formats have VBR's)" --list --radiolist --column="" \
	--column="Name" \
	FALSE "64" \
	TRUE "128" \
	FALSE "192" \
	FALSE "240" \
	FALSE "320" \
	FALSE "$option1" `

	if [ "$bitrate" = "$option1" ]; then 
		bitrate=`zenity --title="$title" --text="Type the bitrate you wish to use:
	(Must be ffmpeg compatible)" --entry `
	fi

	if [ ! "$bitrate" ]; then 
		zenity --error --title="::Error::" --text="Please choose a bitrate for the new audio file and try again." 
		exit
	fi
}
define_channels (){
	channels=`zenity --height="$height" --width="$width" --title="$title" --text="How many channels would you like your file to have?" --list --radiolist --column="" \
	--column="Name" \
	FALSE "1" \
	TRUE "2" \
	FALSE "$option1" `

	if [ "$channels" = "$option1" ]; then 
		bitrate=`zenity --title="$title" --text="Type the number of channels you wish to use:
	(Must be ffmpeg compatible)" --entry `
	fi

	if [ ! "$channels" ]; then 
		zenity --error --title="::Error::" --text="Please choose a number of channels for the new audio file and try again." 
		exit
	fi
}

#this is the primary function used in this script with options for number of channels, bitrate, name, and format
encode_audio (){
	ffmpeg -i "$1" -vn -ac "$channels" -ab "$bitrate" "$name"."$format"
}

#this large while loop encompasses the rest of the script to allow for different options to be used on consecutive files if multiple ones are selected
while [ 'true' ]; do

#makes sure at least 1 file was selected in the nautilus window
if [ $# -eq 0 ]; then
	zenity --error --title="::Error::" --text="You must select at least 1 file."
	exit 1
fi

#these variables define what is meant by default
#if changed here, their values should be updated in the first zenity window
format="mp3"
channels="2"
bitrate="128"

#these variables define what text appears in the encoding options window
#encode_type1 makes all selected files pass through the default settings listed above
encode_type1="All: Default Settings: Same Name As Original"
#encode_type2 makes all selected files pass through the default settings listed above while each time allowing the user to choose a name for the new file
encode_type2="All: Default Settings: Choose Custom Name For Each File"
#encode_type3 encodes the first selected file with default settings and then removes it from the list of selected
encode_type3="Single: Default Settings: Same Name As Original"
#encode_type4 allows for specific renaming of the the first selected file, encodes it with default settings, and removes it from the list of selected
encode_type4="Single: Default Settings: Choose Custom Name For File"
#encode_type5 allows the user to select options that will be used for all files selected while automatically naming the newly created files after the original
encode_type5="All: Custom Settings: Same Name As Original"
#encode_type6 allows the user to select options that will be used for all files selected while allowing the user to name each file before it is encoded
encode_type6="All: Custom Settings: Choose Custom Name For File"
#encode_type7 gives the user the ability to configure all options on a single file
encode_type7="Single: Custom Settinges: Choose Custom Name For File"
#this option window allows the user to choose how many and how they want their files converted

encode_type=`zenity --height="$height" --width="$width" --title="$title" --text="Would you like to use the default encoding options or choose custom options?
(Default options are: $format format, $bitrate kb/s, $channels channels)
Next File: $1
Files Left To Extract From: $#" --list --radiolist --column="" \
--column="Name" \
TRUE "$encode_type1" \
FALSE "$encode_type2" \
FALSE "$encode_type3" \
FALSE "$encode_type4" \
FALSE "$encode_type5" \
FALSE "$encode_type6" \
FALSE "$encode_type7" `

#if cancel in the first window, close script without error message
if [ ! "$encode_type" ]; then 
	exit
fi

#encode_type1 actions
if [ "$encode_type" = "$encode_type1" ]; then
	while  [ $# -gt 0 ]; do
		filename=${1%.*}
		name="$filename"
		encode_audio $1
		shift
	done
	exit
fi

#encode_type2 actions
if [ "$encode_type" = "$encode_type2" ]; then
	while  [ $# -gt 0 ]; do
		define_name $1
		encode_audio $1
		shift
	done
	exit
fi

#encode_type3 actions
if [ "$encode_type" = "$encode_type3" ]; then 
	filename=${1%.*}
	name="$filename"
	encode_audio $1
	shift
fi

#encode_type4 actions
if [ "$encode_type" = "$encode_type4" ]; then 
	define_name $1
	encode_audio $1
	shift
fi

#encode_type5 actions
if [ "$encode_type" = "$encode_type5" ]; then 
	define_format
	define_bitrate
	define_channels
	while  [ $# -gt 0 ]; do
		filename=${1%.*}
		name="$filename"
		encode_audio $1
		shift
	done
	exit
fi

#encode_type6 actions
if [ "$encode_type" = "$encode_type6" ]; then 
	define_format
	define_bitrate
	define_channels
	while  [ $# -gt 0 ]; do
		define_name $1
		encode_audio $1
		shift
	done
	exit
fi
#encode_type7 actions
if [ "$encode_type" = "$encode_type7" ]; then 
	define_name $1
	define_format
	define_bitrate
	define_channels
	encode_audio $1
	shift
fi

#if the script has encoded all selected files, this will terminate the script
if [ $# -le 0 ]; then
	exit
fi

done
exit