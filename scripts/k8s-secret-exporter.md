# k8s-secret-exporter.sh

Export secrets of a given ns into one file per secret

## Overview

Export secrets of a given ns in a given context into one file per secret
Optionally import these to the same ns in another cluster (context)
The script removes some basic metadata and only a selected list of secret types

## Index

* [need](#need)

### need

Helper function to check if a given tool is installed, otherwise die

#### Arguments

* **$1** (string): name of the binary
* **$2** (string): additional text to the error message (e.g. where to download)

