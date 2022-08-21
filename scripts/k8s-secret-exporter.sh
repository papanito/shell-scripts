#!/bin/bash

REMOVE_META=".metadata.managedFields,.status,.metadata.annotations,.metadata.resourceVersion,.metadata.selfLink,.metadata.uid,.metadata.creationTimestamp,.metadata.ownerReferences"

# Function: Print a help message.
usage() {
    echo "This script exports all secrets from a context if secret is not managed by Helm"
    echo "The script assumes you have yq installed and all your contexts (clusters) in a single KUBECONFIG"
    echo "Usage:"
    echo "- $0 -c CONTEXT -n NAMESPACE" 1>&2
    echo "- $0 -c CONTEXT -n NAMESPACE -i CONTEXT_FOR_IMPORT" 1>&2
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

if [ ! -z $IMPORT_CONTEXT ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "Are you sure you want to import the secrets from $CONTEXT to $IMPORT_CONTEXT? Type 'yes'"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    read DO_IMPORT
fi

for ns in $NAMESPACES; do
    # we ignore some specific ns
    if [[ "$ns" != "cattle"* && \
          "$ns" != "kube"* && \
          "$ns" != "fleet-system"* && \
          "$ns" != *"prometheus"* && \
          "$ns" != "metallb" ]]; then
        echo -e "\n===================================\n$ns\n==================================="
        for selector in $TYPES_TO_EXPORT; do
            secrets=$(kubectl get secrets --field-selector "$selector" \
              -l !app.kubernetes.io/managed-by,!heritage,!managed-by,!io.cattle.field/appId \
              --no-headers -o custom-columns=":metadata.name" \
              -n $ns --context $CONTEXT);
            if [[ ("$secrets" != "") ]] ; then
                if [ "$DO_IMPORT" = "yes" ]; then
                    echo -e "** create $ns in $IMPORT_CONTEXT **"
                    kubectl create namespace $ns --context $IMPORT_CONTEXT 2>/dev/null
                    sleep 5
                fi
                echo -e "** Get secrets $selector **\n";
                for secret in $secrets; do
                    # ignore secrets we create via UI - they are for all namespaces
                    if [[ ( "$secret" != "wildcard-ingress-cert") && ( "$secret" != "sc-ca-cert") ]]; then
                        echo "${ns}_${secret}.yaml"
                        kubectl get secret $secret -n $ns --context $CONTEXT -o yaml \
                        | yq eval "del($REMOVE_META)" - \
                        > "${TARGET}/${ns}_${secret}.yaml";

                        if [ "$DO_IMPORT" = "yes" ]; then
                            echo -e "** import into $ns of $IMPORT_CONTEXT **"
                            kubectl apply -f "${TARGET}/${ns}_${secret}.yaml" --context $IMPORT_CONTEXT
                        fi
                    fi;
                done;
            fi;
        done;
    fi;
done
