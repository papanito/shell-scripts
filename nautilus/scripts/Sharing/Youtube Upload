#! /bin/bash
# Use /usr/local/bin/bash on FreeBSD
#
#Script: Youtube video uploader
#Autor: Valentin "angenoir" COMTE, small modifications by Andrew @ webupd8.org
#Version: 0.2
# Special thanks to addikt1ve for his mastery !
# Small script intended to be used from Nautilus.
# Allow you to upload vidéos to youtube by using the google tools in cli.
# Requires: zenity, googlecl, gdata-python-client (aka python-gdata) >= 1.2.4
#
#/!\ IMPORTANTE NOTE ! Please, run this script once in a term to configure your youtube account => google youtube post '/path/to/your/video/' and answer to the questions asked and allow googlecl to use your youtube infos, then you could use this script without any problem ! /!\
#This script is under the General Public License, so feel free to ameliorate it and share it !


FORMATS="mp4 avi 3gp mov wmv"
ZENITY=$(which zenity)
GOOGLE="google youtube post"

# Check if we have selected any files...
if [ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    $ZENITY --error --text="No video selected."
    exit 0;
fi

# Ask for output file category
output_category=Enter the category
output_category=$(zenity --list --text="choose a category" --title="Choose a category" --radiolist  --column "Pick" --column "Category" TRUE Film FALSE Autos FALSE Music FALSE Travel FALSE Shortmov FALSE Videoblog FALSE Games FALSE Comedy FALSE Entertainment FALSE Education FALSE Howto FALSE Nonprofit FALSE Tech FALSE Movies FALSE Trailers)

output_tags=Enter tags, separated by a coma
output_tags=$($ZENITY --entry --text "Add tags to your video, separated by coma" --entry-text "example, example1, bla, etc.")

# Execute the command.
$GOOGLE --tags "$output_tags" --category "$output_category" $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS

#Check, if process still exist then show a pop-up window.
pid_youtube=$(pidof /usr/bin/python /usr/bin/google youtube post)
pid_youtube2=$(kill -0 "$pid_youtube")
while kill -0 $pid_youtube >/dev/null 
do sleep 1 
done
zenity --info --text "Upload complete !"
