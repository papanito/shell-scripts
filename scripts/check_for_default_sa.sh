#!/usr/bin/env bash
set -eE

handle_error() {
    echo "false"
}
# Function: Print a help message.
usage() {
    echo "Check which default service accounts are not actively used"
    echo "-c CONTEXT kubectl context" 1>&2
    echo "-d log details, otherwise only true or false are retruned"
}

# Function: Exit with error.
exit_abnormal() {
    usage
    exit 1
}


trap 'handle_error' ERR

DEBUG=0
CONTEXT=$(kubectl config current-context)

while getopts "hdc:" options; do
    case ${options} in
        c )
            CONTEXT=${OPTARG}
            echo "Context '$CONTEXT' selected"
        ;;
        d )
            DEBUG=1
        ;;
        h) exit_abnormal;;
        \? ) exit_abnormal;;
        *) exit_abnormal;;
    esac
done

resources=$(kubectl get serviceaccounts --all-namespaces -o json --context $CONTEXT | jq -r '.items[] | select(.metadata.name=="default") | select((.automountServiceAccountToken == null) or (.automountServiceAccountToken == true))' | jq .metadata.namespace)
count_sa=$(echo $resources | wc -l)
if [[ ${count_sa} -gt 0 ]]; then
    if [ $DEBUG -eq 1 ]; then
        for ns in $resources; do echo $ns; done
    else
        echo "false"
    fi
    exit
fi

for ns in $(kubectl get ns --no-headers -o custom-columns=":metadata.name")
do
    for result in $(kubectl get clusterrolebinding,rolebinding -n $ns -o json  --context $CONTEXT | jq -r '.items[] | select((.subjects[].kind=="ServiceAccount" and .subjects[].name=="default") or (.subjects[].kind=="Group" and .subjects[].name=="system:serviceaccounts"))' | jq -r '"\(.roleRef.kind),\(.roleRef.name)"')
    do
        read kind name <<<$(IFS=","; echo $result)
        resources=$(kubectl get $kind $name -n $ns -o json --context $CONTEXT | jq -r '.rules[] | select(.resources[] != "podsecuritypolicies")')
        resource_count=$(echo $resources | wc -l)
        if [[ ${resource_count} -gt 0 ]]; then
            if [ $DEBUG -eq 1 ]; then
                for ns in $resources; do echo $ns; done
            else
                echo "false"
            fi
            exit
        fi
    done
done


echo "true"