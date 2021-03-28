#!/usr/bin/env bash
LOG_FILE="$1"
 
function getRequestPerDay {
    echo "Requests per day:"
    grep -Eo '[0-9]+/[A-Za-z]+/[0-9]+' $LOG_FILE | sort | uniq -c | awk '{print $1 " " $2}' | sort -rnk 1
}

function getRequestPerIP {
    echo "Requests per IP:"
    ## the pattern may be more specific
    grep -Eo '^[0-9]+.[0-9]+.[0-9]+.[0-9]+' $LOG_FILE | sort | uniq -c | awk '{print $1 " " $2}'| sort -rnk 1
}

getRequestPerDay
getRequestPerIP
