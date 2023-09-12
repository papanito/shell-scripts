#!/usr/bin/env bash
# Send notifications to a google chat channel
SUMMARY=
TEXT=
URL=

# Function: Print a help message.
usage() {
  echo "Usage: $0 -u <URL> -s <SUMMARY> -t <text>" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

if [ "$#" != "6" ]; then
   exit_abnormal
fi

while getopts ":u:s:t:" option; do
   case ${option} in
      s )
         SUMMARY=$OPTARG
         ;;
      t )
         TEXT=$OPTARG
         ;;
      u )
         echo "Send to $OPTARG"
         URL=$OPTARG
         ;;
      \? )
         exit_abnormal
      ;;
      *)
         exit_abnormal
      ;;
    esac
done

if [[ $URL =~ "https://chat.googleapis.com/v1/spaces" ]]; then
   echo $SUMMARY $TEXT $URL
   curl --data "{'text':'*$SUMMARY*\n$TEXT'}" --header 'Content-Type: application/json; charset=UTF-8' --request POST  $URL
fi
