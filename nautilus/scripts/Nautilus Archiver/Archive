#!/bin/bash

# AUTHOR:	Tony Mattsson <tony_mattsson@home.se>
# VERSION:	1.21
# LICENSE:	GPL (http://www.gnu.org/licenses/gpl.html)
# REQUIRES:	bzip2, gzip, lzop, 7za, zip, star, pv, zenity, sed, cat, fgrep, mawk, split
# NAME:		Star compression script
# DESCRIPTION:	A bash shell script that easily creates archives from Gnome Nautilus
#               * It uses the fast and posix compatible star for creation of tar archives
#               * It can create tar archives and tar compressed with bzip2, gzip or lzop
#               * It also creates 7zip and standard zip archives 
#               * It can create selected archives in a batch or make multipart archives.
#


# Check if more unusual commands are there
if [ $(basename `which pv`) != "pv" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'pv' cannot be found."
exit
fi
if [ $(basename `which lzop`) != "lzop" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'lzop' cannot be found."
exit
fi
if [ $(basename `which star`) != "star" ]; then
zenity --error --title "Star compression script" --text="Necessary command 'star' cannot be found."
exit
fi
if [ $(basename `which 7za`) != "7za" ]; then
zenity --error --title "Star compression script" --text="Necessary command '7za' cannot be found."
exit
fi

# Did the user select any file at all?
if [ $# == 0 ]; then
zenity --error --title "Star compression script" --text="You did not select a file
or folder for compression."
exit
fi

# Try to cut past Nautilus bug concerning compression in the home directory
if [ $NAUTILUS_SCRIPT_CURRENT_URI == "x-nautilus-desktop:///" ]; then
   cd "$HOME/Desktop"
fi

# Define functions
# Make a multipart archive
CreateMultipart() {
Selected=`(zenity --list \
          --title="Star compression script" \
          --column="" --column="Select multipart type" \
          --height=229 \
          --width=280 \
          --radiolist \
            TRUE "Create multipart tar.bz2 archive" \
            FALSE "Create multipart tar.gz archive" \
            FALSE "Create multipart tar.lzo archive" \
            FALSE "Create multipart tar archive" \
            FALSE "Create multipart 7z archive")`

if [ "$?" == 1 ] ; then exit ; fi

PartSize=`(zenity --entry \
        --title="Star compression script" \
        --text="Enter part size (eg. 10M)")`

if [ "$?" == 1 ] ; then exit ; fi

DesiredSize=`echo "$PartSize" | egrep -o '^[0-9]*[kKmMgGtT][bB]?'`
if [ ! $DesiredSize ]; then
zenity --info --text="You didn't enter a
a valid size for the part.
Valid sizes are:
k = Kilobytes
M = Megabytes
G = Gigabytes
T = Terabytes
Eg. 124k or 25M"
exit
fi
PartNumber=`echo $DesiredSize | egrep -o '^[0-9]*'`
PartFactor=`echo $DesiredSize | egrep -o '[kKmMgGtT]'`

case "$PartFactor" in
    'k'|'K')
         let "PartSize=$PartNumber*1024";
         ;;
    'm'|'M')
         let "PartSize=$PartNumber*1048576";
         ;;
    'g'|'G')
         let "PartSize=$PartNumber*1073741824";
         ;;
    't'|'T')
         let "PartSize=$PartNumber*1099511627776";
         ;;
esac
FileSize=`du -sb "$File" | mawk '{print $1}'`

if [ $FileSize -lt $PartSize ]; then
zenity --error  --title="Star compression script" \
               --text="The size of the part is bigger than
the size of \"$File\".
Enter a smaller size of the part."
exit
fi

Selected=`echo "$Selected" | fgrep -m 1 -o -e "tar.bz2" -e "tar.gz" -e "tar.lzo" -e "tar" -e "7z"`

# Create multipart tar.bz2 of a file or folder
if [ "$Selected" == "tar.bz2" ]
    then
(star -c "$File" | pv -n -s $FileSize | bzip2 -c - | split -a 3 -d -b "$PartSize" - "$File.tar.bz2.part.") 2>&1 | zenity --progress --title "Star compression script" --text "Creating multipart archive: $File.tar.bz2" --percentage=0 --auto-close
  fi

# Create multipart 7z of a file or folder
if [ "$Selected" == "7z" ]
    then
(7za a -r -v"$PartSize"b "$File.7z" "$File") 2>&1 | zenity --progress --title "Star compression script" --text "Creating multipart archive: $File.7z" --pulsate --auto-close
  fi

# Create multipart tar.gz of a file or folder
if [ "$Selected" == "tar.gz" ]
    then
(star -c "$File" | pv -n -s $FileSize | gzip -c - |  split -a 3 -d -b "$PartSize" - "$File.tar.gz.part.") 2>&1 | zenity --progress --title "Star compression script" --text "Creating multipart archive: $File.tar.gz" --percentage=0 --auto-close
  fi

# Create multipart tar.lzo of a file or folder
if [ "$Selected" == "tar.lzo" ]
    then
(star -c "$File" | pv -n -s $FileSize | lzop -c -|  split -a 3 -d -b "$PartSize" - "$File.tar.lzo.part.") 2>&1 | zenity --progress --title "Star compression script" --text "Creating multipart archive: $File.tar.lzo" --percentage=0 --auto-close
  fi

# Create multipart tar of a file or folder
if [ "$Selected" == "tar" ]
    then
(star -c "$File" | pv -n -s $FileSize |  split -a 3 -d -b "$PartSize" - "$File.tar.part.") 2>&1 | zenity --progress --title "Star compression script" --text "Creating multipart archive: $File.tar" --percentage=0 --auto-close
  fi

exit
}

# Make single file archive
CreateArchive() {

# Check if the file already exists
if [ -f "$File.$Selected" ]
then
  if ! zenity --question \
          --text="\"$File.$Selected\" already exists.

Do you want to overwrite it?"
  then
    exit
  fi
fi

# Create a tar.bz2 of a file or folder
if [ "$Selected" == "$File.tar.bz2" ]
    then
(star -c "$File" | pv -n -s $FileSize | bzip2 -c - | cat > "$File.tar.bz2") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.tar.bz2" --percentage=0 --auto-close
  fi

# Create a tar.gz of a file or folder
if [ "$Selected" == "$File.tar.gz" ]
    then
(star -c "$File" | pv -n -s $FileSize | gzip -c - | cat > "$File.tar.gz") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.tar.gz" --percentage=0 --auto-close
  fi

# Create a tar.lzo of a file or folder
if [ "$Selected" == "$File.tar.lzo" ]
    then
(star -c "$File" | pv -n -s $FileSize | lzop -c -| cat > "$File.tar.lzo") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.tar.lzo" --percentage=0 --auto-close
  fi

# Create a tar of a file or folder
if [ "$Selected" == "$File.tar" ]
    then
(star -c "$File" | pv -n -s $FileSize | cat > "$File.tar") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.tar" --percentage=0 --auto-close
  fi

# Create a zip of a file or folder
if [ "$Selected" == "$File.zip" ]
    then
(zip -r -q "$File.zip" "$File") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.zip" --pulsate --auto-close
  fi

# Create a 7z of a file or folder
if [ "$Selected" == "$File.7z" ]
    then
(7za a -r "$File.7z" "$File") 2>&1 | zenity --progress --title "Star compression script" --text "Creating archive: $File.7z" --pulsate --auto-close
  fi
}


if [ $# == 1 ]; then
File=$1
WWidth=${#File}
Selected=`(zenity --list \
          --title="Star compression script" \
          --column="" --column="Select archive to create" \
          --height=275 \
          --width=$[220+$WWidth*6] \
          --radiolist \
            TRUE "$File.tar.bz2" \
            FALSE "$File.tar.gz" \
            FALSE "$File.tar.lzo" \
            FALSE "$File.tar" \
            FALSE "$File.7z" \
            FALSE "$File.zip" \
            FALSE "Multipart archive")`
if [ "$?" == 1 ] ; then exit ; fi
if [ "$Selected" == "Multipart archive" ];then
CreateMultipart
else
FileSize=`du -sb "$File" | mawk '{print $1}'`
CreateArchive
exit
fi
fi

Selected=`(zenity --list \
          --title="Star compression script" \
          --column="" --column="Create multiple archives" \
          --height=252 \
          --width=250 \
          --radiolist \
            TRUE "Create $# 'tar.bz2' archives" \
            FALSE "Create $# 'tar.gz' archives" \
            FALSE "Create $# 'tar.lzo' archives" \
            FALSE "Create $# 'tar' archives" \
            FALSE "Create $# '7z' archives" \
            FALSE "Create $# 'zip' archives")`
MultiType=`echo "$Selected" | fgrep -m 1 -o -e "tar.bz2" -e "tar.gz" -e "tar.lzo" -e "tar" -e "7z" -e "zip"`
for File in "$@"
do
FileSize=`du -sb "$File" | mawk '{print $1}'`
Selected="$File".$MultiType
CreateArchive
done

