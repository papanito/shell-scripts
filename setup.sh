#!/bin/bash
# read the option and store in the variable, $option
declare -A targetdir

targetdir["scripts"]=~/bin
targetdir["nautilus"]=~/.local/share/nautilus/

RESTOW=
ADOPT=

# Function: Print a help message.
usage() {
  echo "Usage: $0 -R PACKAGNAME|all" 1>&2 
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

while getopts "aRDp:" option; do
   case ${option} in
      a )
         echo "do an 'adopt'"
         ADOPT="--adopt --override='.*'"
         ;;
      R )
         echo "do a 'restow' i.e. stow -D followed by stow -S"
         RESTOW="-R"
         ;;
      D )
         echo "delete i.e. stow -D followed by stow -S"
         DELETE="-R"
         ;;
      \? )
         exit_abnormal
      ;;
      *)
         exit_abnormal
      ;;
    esac
done

SOURCE=$(pwd)

pushd $SOURCE

shift $(($OPTIND - 1))
if [ ! $1 ]
then
   echo "no packages specified. syou can use 'all' if you want to install all from the profile or use one of these:"
   echo $(ls)
   exit_abnormal
else
   PACKAGE=$1
   if [ $PACKAGE == "all" ]
   then
      echo "Install all available packages"
      for filename in $(find . -maxdepth 1 -mindepth 1 -type d -printf '%f\n'); do
         echo stow $RESTOW $DELETE $ADOPT $filename -t ${targetdir[$filename]}
         stow $RESTOW $DELETE $ADOPT $filename -t ${targetdir[$filename]}
      done
   elif [ -d "./$PACKAGE" ]
   then
      echo stow $RESTOW $DELETE $ADOPT $PACKAGE -t ${targetdir[$PACKAGE]}
      stow $RESTOW $DELETE $ADOPT $PACKAGE -t ${targetdir[$PACKAGE]}
   else
      echo "package '$PACKAGE' missing"
   fi
fi

popd