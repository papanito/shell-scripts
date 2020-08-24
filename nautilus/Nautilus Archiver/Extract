#!/bin/bash

# This script tests the file type of the file then extracts
# it with the correct program. If the program supports it, 
# it will prompt you for a directory to extract it to.
#
# Distributed under the terms of GNU GPL version 2 or later
#
# Copyright (C) Keith Conger <acid@twcny.rr.com>
#
# Install in your ~/Nautilus/scripts directory.
# You need to be running Nautilus 1.0.3+, gnome-utils, unrar, 
# unace, unarj and unzip. The rest should already be installed.

DEFAULT_DIR=~/tmp/

UNRAR_PATH=/usr/local/bin	#Path to unrar binary.
UNZIP_PATH=/usr/bin		#Path to unzip binary.
UNACE_PATH=/usr/local/bin	#Path to unace binary.
UNARJ_PATH=/usr/bin		#Path to unarj binary.
BUNZIP2_PATH=/usr/bin		#Path to bzip2 binary.
GUNZIP_PATH=/usr/bin		#Path to gunzip binary.
TAR_PATH=/bin		        #Path to tar binary.

FILE_TYPE=$(file -b $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|awk '{ print $1}')
MIME_TYPE=$(file -b $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)

if [ "$FILE_TYPE" = "bzip2" ]; then
	TAR_TEST=$(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|grep .tar.)
	if [ $TAR_TEST = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
		$BUNZIP2_PATH/bzcat $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|tar xv >> /tmp/extract-script.log
		gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
		rm /tmp/extract-script.log
	else
		$BUNZIP2_PATH/bunzip2 -d $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
		gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
		rm /tmp/extract-script.log
	fi
elif [ "$FILE_TYPE"  = "RAR" ]; then
	DIR=$(gdialog --title "Extract compressed file to..." --inputbox "Directory to extract to:" 200 400 "$DEFAULT_DIR" 2>&1)
	mkdir $DIR
	$UNRAR_PATH/unrar x -kb $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS $DIR/ >> /tmp/extract-script.log
	gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
	rm /tmp/extract-script.log
elif [ "$FILE_TYPE" = "Zip" ]; then
	DIR=$(gdialog --title "Extract compressed file to..." --inputbox "Directory to extract to:" 200 400 "$DEFAULT_DIR" 2>&1)
	mkdir $DIR
	$UNZIP_PATH/unzip $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS -d $DIR/ >> /tmp/extract-script.log
	gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
	rm /tmp/extract-script.log
elif [ "$FILE_TYPE" = "gzip" ]; then
	TAR_TEST=$(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|grep .tar.)
	if [ $TAR_TEST = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
		TAR="1"
	fi

	TAR_TEST=$(echo $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS|grep .tgz)
	if [ $TAR_TEST = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS ]; then
		TAR="1"
	fi
	
	if [ $TAR = 1 ]; then
		$TAR_PATH/tar zxvf $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
		gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
		rm /tmp/extract-script.log
	else
		$GUNZIP_PATH/gunzip $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
		gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
		rm /tmp/extract-script.log
	fi
elif [ "$FILE_TYPE" = "ARJ" ]; then
	$UNARJ_PATH/unarj x $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
	gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
	rm /tmp/extract-script.log
elif [ "$FILE_TYPE" = "ACE" ]; then
	$UNACE_PATH/unace x -y $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
	gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
	rm /tmp/extract-script.log
elif [ "$FILE_TYPE" = "GNU" ]; then
	$TAR_PATH/tar xvf $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS >> /tmp/extract-script.log
	gdialog --separate-output --title "Extraction Log" --textbox /tmp/extract-script.log 50 70 2>&1
	rm /tmp/extract-script.log
else
	echo -e "\007"
	gdialog --separate-output --title "File error" --msgbox " File $1 is not a known archive type. File type reported as: $MIME_TYPE " 50 100 2>&1
fi
