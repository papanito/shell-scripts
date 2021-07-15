#!/bin/bash
# Send notifications to desktop using notify-send (libnotify)
SERVICE=

# Function: Print a help message.
usage() {
  echo "Usage: $0 -s servicename -f" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

if [ "$#" -lt "2" ]; then
   exit_abnormal
fi

while getopts ":s:f" option; do
   case ${option} in
      s )
         SERVICE=$OPTARG
         ;;
      f )
         FULLSTATUS=true
         ;;
      \? )
         exit_abnormal
      ;;
      *)
         exit_abnormal
      ;;
    esac
done
if [ -v FULLSTATUS ]; then
   status=$(systemctl status --full $SERVICE)
else
   status=$(systemctl status $SERVICE | grep Active)
fi
status=$(sed "s:'::g" <<< "$status")

notify-send --app-name=$SERVICE $SERVICE@$(hostname) "$status"
