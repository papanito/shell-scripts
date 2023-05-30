#!/bin/bash
# @file k8s-ingress-exporter.sh
# @brief Export ingresses of a given ns into one file per ingress
# @description
#     Export ingresses of a given ns in a given context into one file per ingress
#     Optionally import these to the same ns in another cluster (context)
#     The script removes some basic metadata

set -eo pipefail
set -o unset
set -o errexit
set -o errtrace
shopt -s inherit_errexit

### Variables - start
REMOVE_META=".metadata.managedFields,.status,.metadata.annotations,.metadata.resourceVersion,.metadata.selfLink,.metadata.uid,.metadata.creationTimestamp,.metadata.ownerReferences"
### Variables - end


### Main functions - start
trap 'ret=$?; printf "%s\n" "$ERR_MSG" >&2; exit "$ret"' ERR

# @description print error message in case the function dies unexpectedly
# @arg $1 string error message to display
# @internal
die() {
    echo -e "$*" 1>&2 ; exit 1; 
}

# @description Print a help message.
# @arg $0 string name of the binary
# @internal
usage() {
   cat <<'END'
This script exports all ingress from a context if it's is not managed by Helm
The script assumes you have yq installed and all your contexts (clusters) in a single KUBECONFIG.
Use $NAMESPACE=ALL to do it for all namespaces

Usage:
- $0 -c CONTEXT -n NAMESPACE
- $0 -c CONTEXT -n NAMESPACE -i CONTEXT_FOR_IMPORT
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

# @description Helper function to check if a given tool is installed, otherwise die
# @arg $1 string name of the binary
# @arg $2 string additional text to the error message (e.g. where to download)
# @internal
need() {
   which "$1" &>/dev/null || die "Binary '$1' is missing but required\n$2"
}

need "yq" ""

while getopts "hc:n:i:" options; do
    case ${options} in
        c )
            CONTEXT=${OPTARG}
            echo "Context '$CONTEXT' selected"
        ;;
        i )
            IMPORT_CONTEXT=${OPTARG}
            echo "Import exported ingresss to context '$IMPORT_CONTEXT'"
        ;;
        n )
            NAMESPACES=${OPTARG}
            if [ $NAMESPACES == "ALL" ]; then
                NAMESPACES=$(kubectl get ns  --no-headers -o custom-columns=":metadata.name" --context $CONTEXT)
                echo "All namespaces selected"
            else
                echo "Namespace '$NAMESPACES' selected"
            fi
        ;;
        h) exit_abnormal;;
        \? ) exit_abnormal;;
        *) exit_abnormal;;
    esac
done

if [ ! "$NAMESPACES" ] || ! [ "$CONTEXT" ] ; then
  echo -e "arguments -c and -n must be provided"
  exit_abnormal
fi

TARGET="./$CONTEXT"

if [[ ! -d "$TARGET" ]]; then
    mkdir -p $TARGET
fi

for ns in $NAMESPACES; do
    # we ignore some specific ns
    if [[ "$ns" != "cattle"* && \
          "$ns" != "kube"* && \
          "$ns" != "fleet-system"* && \
          "$ns" != *"prometheus"* && \
          "$ns" != "metallb" ]]; then
        echo -e "\n===================================\n$ns\n==================================="
        ingresses=$(kubectl get ingress \
        -l app.kubernetes.io/managed-by!=Helm \
        --no-headers -o custom-columns=":metadata.name" \
            -n $ns --context $CONTEXT);
        if [[ ("$ingresses" != "") ]] ; then
            if [ "$DO_IMPORT" = "yes" ]; then
                echo -e "** create $ns in $IMPORT_CONTEXT **"
                kubectl create namespace $ns --context $IMPORT_CONTEXT 2>/dev/null
                sleep 5
            fi
            echo -e "** Get ingress **\n";
            for ingress in $ingresses; do
                echo "${ns}_${ingress}.yaml"
                kubectl get ingress $ingress -n $ns --context $CONTEXT -o yaml \
                | yq eval "del($REMOVE_META)" - \
                > "${TARGET}/${ns}_${ingress}.yaml";

                if [ "$DO_IMPORT" = "yes" ]; then
                    echo -e "** import into $ns of $IMPORT_CONTEXT **"
                    kubectl apply -f "${TARGET}/${ns}_${ingress}.yaml" --context $IMPORT_CONTEXT
                fi
            done;
        fi;
    fi;
done

ingresses=$(kubectl get ingress \
            -l app.kubernetes.io/managed-by!=Helm \
            --no-headers -o custom-columns=":metadata.name" \
            -n $NAMESPACE --context $CONTEXT);
if [[ ("$ingresses" != "") ]] ; then
    for ingress in $ingresses; do
        echo "${ns}_${ingress}.yaml"
        kubectl get ingress $ingress -n $ns --context $CONTEXT -o yaml \
        | yq eval "del($REMOVE_META)" - \
        > "${TARGET}/${ns}_${ingress}.yaml";
    done;
fi;