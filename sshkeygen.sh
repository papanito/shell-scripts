#!/usr/bin/env bash
# @file sshkeygen.sh
# @brief Creates ssh keys following my naming conventions
# @description
#     Creates ssh keys following my naming conventions `id_<purpose>_<user>@<servername>.<key_algorithm>`. It always creates a passphrase and stores it in bw.
#     * `-s <SERVER>` name of the target server
#     * `-u <USER>` name of the user to connect target system
#     * `-t <TYPE>` type of the key
#     * `-p <PURPOSE>` purpose of the key
#     * `-k <KEYLENGTH>` length of the key`

set -eo pipefail
set -o errexit
set -o errtrace
shopt -s inherit_errexit

### Variables - start
DEBUG=0
SSH_DIR="$HOME/.ssh"
ERR_MSG="ERROR, please check log"
TYPE="ed25519"
PW_LENGTH=20
### Variables - end

### Main functions - start
trap 'ret=$?; printf "%s\n" "$ERR_MSG" >&2; exit "$ret"' ERR

# @description print error message in case the function dies unexpectedly
# @arg $1 string error message to display
die() {
    echo -e "$*" 1>&2 ; exit 1; 
}

need () {
    which "$1" &> /dev/null || echo "Binary '$1' is missing but required\n$2" || exit 1
}

# @description Print a help message.
# @arg $0 string name of the binary
usage() {
   cat <<EOF
Creates ssh keys following my naming conventions `id_<purpose>_<user>@<servername>.<key_algorithm>`. It always creates a passphrase and stores it in bw.

Usage: $0 -s <SERVER> -u <USER>
     -s <SERVER> name of the target server
     -u <USER> name of the user to connect target system
     -t <TYPE> type of the key
     -p <PURPOSE> purpose of the key
     -k <KEYLENGTH> length of the key
EOF
}

# @description Print usage message and exit with 1
# @noargs
# @exitcode 1 Always
exit_abnormal() {
   usage
   exit 1
}

## Ensure you have https://gitlab.com/papanito/shell-helper-library setup, I use some helper functions from this "libary"


### Main Functions - end

### Custom Functions - start
# Custom fucntions go here
### Custom Functions - end

### Check for required tools
need "gum"
need "bw"

### Read arguments
while getopts "hs:u:t:p:k:" options; do
    case ${options} in
        t )
            TYPE=${OPTARG}
        ;;
        s )
            SERVER=${OPTARG}
        ;;
        u )
            USER=${OPTARG}
        ;;
        p )
            PURPOSE=${OPTARG}
        ;;
        k )
            KEYLENGTH=${OPTARG}
        ;;
        h) exit_abnormal;;
        \? ) exit_abnormal;;
        *) exit_abnormal;;
    esac
done

if [ ! "$TYPE" ] ; then
  TYPE=`gum choose ecdsa ecdsa-sk ed25519 ed25519-sk rsa dsa` 
fi

if [ ! "$SERVER" ] ; then
  SERVER=`gum input --prompt="Username to access $TARGET: "` 
fi

if [ ! "$USER" ] ; then
  USER=`gum input --prompt="Username to access $TARGET: "` 
fi

if [ ! "$PURPOSE" ] ; then
  PURPOSE=`gum choose ssh` 
fi

case $TYPE in
  rsa)
    KEYLENGTH_OPTION="-b" # -b “Bits”
    KEYLENGTH_DEFAULT="4096"
    ;;
  ecdsa-sk)
    KEYLENGTH_OPTION="-b" # -b “Bits”
    KEYLENGTH_DEFAULT="521"
    ;;
  ecdsa)
    KEYLENGTH_OPTION="-b" # -b “Bits”
    KEYLENGTH_DEFAULT="521"
    ;;
  ed25519)
    KEYLENGTH_OPTION="-a" # rounds
    KEYLENGTH_DEFAULT="100"
    ;;
  ed25519-sk)
    KEYLENGTH_OPTION="-a" # rounds
    KEYLENGTH_DEFAULT="100"
    ;;
esac

if [ ! "$KEYLENGTH" ] ; then
  KEYLENGTH=`gum input --prompt="Length of the key/rounds: " --value $KEYLENGTH_DEFAULT` 
fi

### Main Script
KEYNAME="id_${PURPOSE}_${USER}@${SERVER}.${TYPE}"
COMMENT="$USER@$SERVER from $HOSTNAME"
PASSPHRASE=`bw generate -p --length $PW_LENGTH`

echo "ssh-keygen -t $TYPE $KEYLENGTH_OPTION $KEYLENGTH -C $COMMENT -N $PASSPHRASE -f $SSH_DIR/$KEYNAME"

LOGIN_INFO=`bw get template item.login | jq ".username=\"$USER\" | .password=\"$PASSPHRASE\""`
FOLDER=`bw get folder "SSH" | jq '.id' -r` 

ssh-keygen -t $TYPE $KEYLENGTH_OPTION $KEYLENGTH -C "$USER@$SERVER from $HOSTNAME" -N "$PASSPHRASE" -f $SSH_DIR/$KEYNAME

bw get template item | jq ".name=\"SSH KEY $KEYNAME\" | .login=$LOGIN_INFO | .notes=\"$COMMENT\" | .fodlerId=\"$FOLDER\"" | bw encode | bw create item

ssh-add $SSH_DIR/$KEYNAME

echo "Attach $KEYNME.pub to bw"
ITEM=`bw get item "SSH KEY $KEYNAME" | jq '.id' -r`
bw create attachment --itemid $ITEM --file $KEYNAME.pub
