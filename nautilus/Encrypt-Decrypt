#!/bin/sh
# 
# Filename: Encrypt-Decrypt(gpg)
# Date: 2008/02/02 15:10:34
# Licence: GNU GPL
# Dependency: zenity, gpg
# Author: Martin Langasek <cz4160@gmail.com>

case $LANG in
  cs* )
    err_title="Chyba"
    err_files="Neoznačen soubor"
    encrypt="Šifrovat"
    decrypt="Dešifrovat"
    file_msg="soubor:"
    pass_msg="Vložte heslo";;
  * )
    err_title="Error"
    err_files="No file selected"
    encrypt="Encrypt"
    decrypt="Decrypt"
    file_msg="file:"
    pass_msg="Enter passphrase";;
esac

if [ "$1" != "" ]
then
  i=1
  file=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed ''$i'!d'`
  while [ "$file" != "" ]
  do    
    ext=`echo "$file" | grep [.]gpg$ 2>&1`
    if [ "$ext" != "" ]
    then
      pass_decrypt=`zenity --entry --entry-text "$pass_decrypt" --hide-text --title "$pass_msg" --text "$decrypt $file_msg ${file##*/}" "" 2>&1`
      if [ "$pass_decrypt" != "" ]
      then
        output=${file%.*}
        echo "$pass_decrypt" | gpg -o "$output" --batch --passphrase-fd 0 -d "$file"
      fi
    else
      pass_encrypt=`zenity --entry --hide-text --entry-text "$pass_encrypt" --title "$pass_msg" --text "$encrypt $file_msg ${file##*/}" "" 2>&1`
      if [ "$pass_encrypt" != "" ]
      then
        echo "$pass_encrypt" | gpg --batch --passphrase-fd 0 --cipher-algo aes256 -c "$file"
      fi
    fi
    i=$(($i+1))
    file=`echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | sed ''$i'!d'`
  done
else
  zenity --error --title "$err_title" --text "$err_files"
fi
