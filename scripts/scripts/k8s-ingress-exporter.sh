#!/bin/bash

REMOVE_META=".metadata.managedFields,.status,.metadata.annotations,.metadata.resourceVersion,.metadata.selfLink,.metadata.uid,.metadata.creationTimestamp,.metadata.ownerReferences"

# Function: Print a help message.
usage() {
    echo "This script exports all secrets from a context if secret is not managed by Helm"
    echo "Usage: $0 -c CONTEXT" 1>&2
}

# Function: Exit with error.
exit_abnormal() {
    usage
    exit 1
}

TYPES_TO_EXPORT="type=Opaque type=kubernetes.io/tls type=microsoft.com/smb"

if ! command -v yq &> /dev/null
then
    echo "yq could not be found, but is required for this script to run."
    exit
fi

while getopts "hc:n:i:" options; do
    case ${options} in
        c )
            CONTEXT=${OPTARG}
            echo "Context '$CONTEXT' selected"
        ;;
        i )
            IMPORT_CONTEXT=${OPTARG}
            echo "Import exported secrets to context '$IMPORT_CONTEXT'"
        ;;        
        h) exit_abnormal;;
        \? ) exit_abnormal;;
        *) exit_abnormal;;
    esac
done

if [ ! [ "$CONTEXT" ] ; then
  echo -e "arguments -c must be provided"
  exit_abnormal
fi

TARGET="./$CONTEXT"

if [[ ! -d "$TARGET" ]]; then
    mkdir -p $TARGET
fi

ns=istio-system
ingresses=$(kubectl get ingress \
            -l app.kubernetes.io/managed-by!=Helm \
            --no-headers -o custom-columns=":metadata.name" \
            -n $ns --context $CONTEXT);
if [[ ("$ingresses" != "") ]] ; then
    for ingress in $ingresses; do
        echo "${ns}_${ingress}.yaml"
        kubectl get ingress $ingress -n $ns --context $CONTEXT -o yaml \
        | yq eval "del($REMOVE_META)" - \
        > "${TARGET}/${ns}_${ingress}.yaml";
    done;
fi;