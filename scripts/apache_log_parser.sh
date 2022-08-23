#!/usr/bin/env bash
# @file apache_log_parser.sh
# @brief Parses logs from apache web server
# @description
#     Example bash script which gets some information out form apache logs or any other logs with similar format.
#
#     **This is just an example, without aim for completeness**
# @arg $1 string name of the logfile to parse
LOG_FILE="$1"

# @description Get requests per day from `LOG_FILE`
#
# Counts lines with date `dd/MMM/YY(YY)`
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 If an empty string passed
function getRequestPerDay() {
    echo "Requests per day:"
    grep -Eo '[0-9]+/[A-Za-z]+/[0-9]+' $LOG_FILE | sort | uniq -c | awk '{print $1 " " $2}' | sort -rnk 1
}

# @description Get requests per day from `LOG_FILE`
#
# Counts unique ip v4 (`xxx.xxx.xxx.xxx`)
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 If an empty string passed
function getRequestPerIP() {
    echo "Requests per IP:"
    ## the pattern may be more specific
    grep -Eo '^[0-9]+.[0-9]+.[0-9]+.[0-9]+' $LOG_FILE | sort | uniq -c | awk '{print $1 " " $2}' | sort -rnk 1
}

getRequestPerDay
getRequestPerIP
