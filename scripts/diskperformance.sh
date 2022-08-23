#!/bin/bash
writetodisk() {
    COUNTER=0
    device=`df $OUTPUTDIR | grep -oe "/dev/[A-Za-z]*"`
    echo "directory $OUTPUTDIR selected for test. disk under test is $device"
    while [ $COUNTER -lt $MAX ]; do
        dd if=/dev/zero of=$OUTPUTDIR/$TESTFILE bs=1G count=1 oflag=direct | tee ~/$LOGFILE
        let COUNTER=COUNTER+1
    done

    rm $OUTPUTDIR/$TESTFILE
}

#global parameters
MAX=10
OUTPUTDIR=/root
LOGFILE=diskperformance.log
TESTFILE=diskperformance.test

usage="$(basename "$0") [-h] [-n <loops>]  <outputdir> 
where:
    -h          show this help text
    -n <loops>  number of loops for write test. default us $MAX
    <outputdir> directory on which to write
"

while getopts "hn:" optname
  do
    case "$optname" in
      "h")
        echo "$usage"
        exit
        ;;
      "n")
        echo "test will be repeatet $OPTARG times"
        MAX=$OPTARG
        ;;
      "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
        echo "Unknown error while processing options"
        exit
        ;;
    esac
done

#output directory has to be specified
dir=${@:$OPTIND}
if [ "$dir" != "" ]; then
    OUTPUTDIR=$dir
else
    echo "no directory selected, assuming default which is $OUTPUTDIR"
fi

writetodisk
