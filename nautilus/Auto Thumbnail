#!/bin/sh

# Dialog box to choose thumb's size
SIZE=`zenity --list --title="Choose the thumbnail's size" --radiolist --column="Check" --column="Size" "" "100X100" "" "320x240" "" "640x480" "" "800x600" "" "1024x768"`

if [ "${SIZE}" == "" ]; then    
zenity --error --text="Size not defined by user.
Please choose a size to use. "
exit 1
fi

# How many files to make the progress bar
PROGRESS=0
NUMBER_OF_FILES=`find -iname "*.jpg" -maxdepth 1 | wc -l`
let "INCREMENT=100/$NUMBER_OF_FILES"

mkdir -p thumbnails

# Creating thumbnails. Specific work on picture should be add there as convert's option
(for i in *.jpg *.JPG; do
echo "$PROGRESS";
echo "# Resizing $i";
convert -resize "${SIZE}"  -bordercolor black -quality 90 "${i}" thumbnails/"${i}"
let "PROGRESS+=$INCREMENT"
done
) | zenity  --progress --title "$Creating thumbnails..." --percentage=0

#process png
# How many files to make the progress bar
PROGRESS=0
NUMBER_OF_FILES=`find -iname "*.png" -maxdepth 1 | wc -l`
let "INCREMENT=100/$NUMBER_OF_FILES"

mkdir -p thumbnails

# Creating thumbnails. Specific work on picture should be add there as convert's option
(for i in *.png *.PNG; do
echo "$PROGRESS";
echo "# Resizing $i";
convert -resize "${SIZE}"  -bordercolor black -quality 90 "${i}" thumbnails/"${i}"
let "PROGRESS+=$INCREMENT"
done
) | zenity  --progress --title "$Creating thumbnails..." --percentage=0
