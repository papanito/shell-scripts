#!/bin/bash -e
set -eo pipefail

### Variables - start
DEBUG=0
ERR_MSG="ERROR, please check log"
### Variables - end

### Main functions - start
trap 'ret=$?; printf "%s\n" "$ERR_MSG" >&2; exit "$ret"' ERR

die() {
    echo -e "$*" 1>&2 ; exit 1; 
}

usage() {
    echo "EXPLAIN WHAT THE SCRIPT DOES"
    echo
    echo "Syntax: $0 [-c CONTEXT|-n NAMESPACE]"
    echo
    echo "-c CONTEXT      kubectl context" 1>&2
    echo "-n NAMESPACE    namespace in which you want to migrated" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
    usage
    exit 1
}

text_separator() {
   ch="-"
   len="80"
   if [ "$#" -eq 2 ]; then
      ch=$1
   elif [ "$#" -gt 2 ]; then
      ch=$1
      len=$2
   fi 
   printf '%*s\n' "$len" | tr ' ' "$ch"
}

need() {
   which "$1" &>/dev/null || die "Binary '$1' is missing but required\n$2"
}

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