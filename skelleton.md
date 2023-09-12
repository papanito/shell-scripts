# skeleton.sh

Brief description fo what the script does

## Overview

Detailed description of what the script does

* `-s <SERVICENAME>` name of the service
* `-u <URL>` Url to Google chat channel webhook (https://chat.googleapis.com/v1/spaces/xxxx)
* `-f` Show full status

## Index

* [die](#die)
* [usage](#usage)
* [exit_abnormal](#exit_abnormal)
* [text_separator](#text_separator)
* [need](#need)

### die

print error message in case the function dies unexpectedly

#### Arguments

* **$1** (string): error message to display

### usage

Print a help message.

#### Arguments

* **$0** (string): name of the binary

### exit_abnormal

Print usage message and exit with 1

_Function has no arguments._

#### Exit codes

* **1**: Always

### text_separator

Helper function to separate output with a given character

#### Arguments

* **$1** (string): (optional) character for separation, default is `-`
* **$2** (int): (optional) how much characters to print, default is 80

### need

Helper function to check if a given tool is installed, otherwise die

#### Arguments

* **$1** (string): name of the binary
* **$2** (string): additional text to the error message (e.g. where to download)

