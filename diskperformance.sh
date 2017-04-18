#!/bin/bash
writetodisk() {
	COUNTER=0
	while [ $COUNTER -lt $MAX ]; do
		dd if=/dev/zero of=$OUTPUTDIR/testfile bs=1G count=1 oflag=direct | tee $OUTPUTDIR/$LOGFILE
		let COUNTER=COUNTER+1
	done
}
#global parameters
MAX=10
OUTPUTDIR=/root
LOGFILE=diskperformance.log

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
      # Should not occur
        echo "Unknown error while processing options"
	exit
        ;;
    esac
done

#output directory has to be specified
if [ "$1" != "" ]; then
    device=`df /root | grep -oe "/dev/[A-Za-z]*"`
    echo "directory $1 selected for test. disk under test is $device"
    OUTPUTDIR=$1
else
    echo "no directory selected, assuming default which is $OUTPUTDIR"
fi

writetodisk