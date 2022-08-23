# apache_log_parser.sh

Parses logs from apache web server

## Overview

Example bash script which gets some information out form apache logs or any other logs with similar format.

**This is just an example, without aim for completeness**

## Index

* [getRequestPerDay](#getrequestperday)
* [getRequestPerIP](#getrequestperip)

### getRequestPerDay

Get requests per day from `LOG_FILE`

Counts lines with date `dd/MMM/YY(YY)`

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an empty string passed

### getRequestPerIP

Get requests per day from `LOG_FILE`

Counts unique ip v4 (`xxx.xxx.xxx.xxx`)

_Function has no arguments._

#### Exit codes

* **0**: If successful.
* **1**: If an empty string passed

