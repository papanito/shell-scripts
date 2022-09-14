#!/bin/bash -e
# @file skeleton.sh
# @brief Brief description fo what the script does
# @description
#     Detailed description of what the script does
#
#     * `-s <SERVICENAME>` name of the service
#     * `-u <URL>` Url to Google chat channel webhook (https://chat.googleapis.com/v1/spaces/xxxx)
#     * `-f` Show full status

set -eo pipefail

### Variables - start
DEBUG=0
ERR_MSG="ERROR, please check log"
### Variables - end

### Main functions - start
trap 'ret=$?; printf "%s\n" "$ERR_MSG" >&2; exit "$ret"' ERR

# @description print error message in case the function dies unexpectedly
# @arg $1 string error message to display
die() {
    echo -e "$*" 1>&2 ; exit 1; 
}

# @description Print a help message.
# @arg $0 string name of the binary
usage() {
   cat <<'END'
EXPLAIN WHAT THE SCRIPT DOES

Usage: $0 -s <SERVICENAME> -u <URL> -f
     -s <SERVICENAME> name of the service
     -u <URL> Url to Google chat channel webhook (https://chat.googleapis.com/v1/spaces/xxxx)
     -f Show full status
END
}

# @description Print usage message and exit with 1
# @noargs
# @exitcode 1 Always
exit_abnormal() {
   usage
   exit 1
}

## Ensure you have https://gitlab.com/papanito/shell-helper-library setup, I use some helper functions from this "libary"


### Main Functions - end

### Custom Functions - start
# Custom fucntions go here
### Custom Functions - end

### Check for required tools

need "yq" "BINARY=yq_linux_amd64 && VERSION=v4.25.1 && wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}.tar.gz -O - | tar xz && sudo mv ${BINARY} /usr/bin/yq"
need "pv-migrate" "BINARY=linux_x86_64 && VERSION=v0.12.1 && wget https://github.com/utkuozdemir/pv-migrate/releases/download/\${VERSION}/pv-migrate_\${VERSION}_\${BINARY}.tar.gz -O - | tar xz && sudo mv pv-migrat /usr/bin/pv-migrate"
need "kubectl"

### Read arguments
while getopts "hc:n:ad" options; do
    case ${options} in
        c )
            CONTEXT=${OPTARG}
            echo "Context '$CONTEXT' selected"
        ;;
        n )
            NAMESPACE=${OPTARG}
            echo "Namespace '$NAMESPACE' selected"
        ;;
        h) exit_abnormal;;
        \? ) exit_abnormal;;
        *) exit_abnormal;;
    esac
done

if [ ! "$NAMESPACE" ] || ! [ "$CONTEXT" ] ; then
  echo -e "arguments -c and -n must be provided"
  exit_abnormal
fi

### Main Script

## TODO