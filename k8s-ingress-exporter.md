# k8s-ingress-exporter.sh

Export ingresses of a given ns into one file per ingress

## Overview

Export ingresses of a given ns in a given context into one file per ingress
Optionally import these to the same ns in another cluster (context)
The script removes some basic metadata

## Index

* [need](#need)

### need

Helper function to check if a given tool is installed, otherwise die

#### Arguments

* **$1** (string): name of the binary
* **$2** (string): additional text to the error message (e.g. where to download)

