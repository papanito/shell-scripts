#!/bin/bash
# Send notifications to a google chat channel about systemd service status
SERVICE=
URL=

# Function: Print a help message.
usage() {
  echo "Usage: $0 -u url -s servicename" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
  usage
  exit 1
}

if [ "$#" != "4" ]; then
   exit_abnormal
fi

while getopts ":u:s:" option; do
   case ${option} in
      s )
         SERVICE=$OPTARG
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

status=$(systemctl status --full $SERVICE)
status=$(sed "s:'::g" <<< "$status")

if [[ $URL =~ "https://chat.googleapis.com/v1/spaces" ]]; then
   curl --data "{'text':'*$SERVICE@$(hostname)*\n\`\`\`$status\`\`\`'}" --header 'Content-Type: application/json; charset=UTF-8' --request POST  $URL
fi
