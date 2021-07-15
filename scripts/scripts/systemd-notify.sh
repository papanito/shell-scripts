#!/bin/bash
# Send notifications to desktop using notify-send (libnotify)
SERVICE=

# Function: Print a help message.
usage() {
  echo "Usage: $0 -s servicename" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

if [ "$#" != "2" ]; then
   exit_abnormal
fi

while getopts ":s:" option; do
   case ${option} in
      s )
         SERVICE=$OPTARG
         ;;
      \? )
         exit_abnormal
      ;;
      *)
         exit_abnormal
      ;;
    esac
done
status=$(systemctl status --full $SERVICE)
status=$(sed "s:'::g" <<< "$status")

notify-send --app-name=$SERVICE $SERVICE@$(hostname) "$status"
