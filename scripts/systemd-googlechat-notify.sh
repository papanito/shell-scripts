#!/usr/bin/env bash
# @file systemd-googlechat-notify.sh
# @brief Send notifications to a google chat channel about systemd service status
# @description
#     Send a notification of a systemd service satus to a google chat channel
#
#     * `-s <SERVICENAME>` name of the service
#     * `-u <URL>` Url to Google chat channel webhook (https://chat.googleapis.com/v1/spaces/xxxx)
#     * `-f` Show full status
# @set SERVICE
set -eo pipefail
set -o unset
set -o errexit
set -o errtrace
shopt -s inherit_errexit
set -o unset
set -o errexit
set -o errtrace
shopt -s inherit_errexit
SERVICE=
URL=

# @description Print a help message.
# @arg $0 string name of the binary
# @internal
usage() {
   cat <<'END'
Send notifications to a google chat channel about systemd service status

Usage: $0 -s <SERVICENAME> -u <URL> -f
     -s <SERVICENAME> name of the service
     -u <URL> Url to Google chat channel webhook (https://chat.googleapis.com/v1/spaces/xxxx)
     -f Show full status
END
}

# @description Print usage message and exit with 1
# @noargs
# @exitcode 1 Always
# @internal
exit_abnormal() {
   usage
   exit 1
}

if [ "$#" -lt "4" ]; then
   exit_abnormal
fi

while getopts ":u:s:f" option; do
   case ${option} in
   s)
      SERVICE=$OPTARG
      ;;
   u)
      echo "Send to $OPTARG"
      URL=$OPTARG
      ;;
   f)
      FULLSTATUS=true
      ;;
   \?)
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
status=$(sed "s:'::g" <<<"$status")

if [[ $URL =~ "https://chat.googleapis.com/v1/spaces" ]]; then
   curl --data "{'text':'*$SERVICE@$(hostname)*\n\`\`\`$status\`\`\`'}" --header 'Content-Type: application/json; charset=UTF-8' --request POST $URL
fi
