#!/bin/bash
TMP=/tmp/$$
FILE=$TMP/classes.dex
DEXDUMP=`which dexdump`
DEBUG_FILE=$TMP/$$

ONECHAR=0
TWOCHAR=0
OTHER=0 

function help() {
    cat <<EOF
Usage: verify_proguard [-s|-v] [apkfile] 
   -s: output summary message. 
   -v: output verbose message. 
EOF
}

if [ $# -lt 1 -o $# -gt 2 ]; then
    help
    exit 1
fi

if [ $# -eq 2 ]; then
    case $1 in
	-s)
	    summary=true
	    shift
	    ;;
	-v)
	    verbose=true
	    shift
	    ;;
	*)
	    help
	    exit 2
    esac
fi

if [ -f $1 ]; then
    if [ -e "/usr/bin/unzip" ]; then
	mkdir -p $TMP
	/usr/bin/unzip $1 classes.dex -d $TMP >/dev/null 2>&1
    else
	echo "/usr/bin/unzip not exist."
	exit 3
    fi
else
    echo "$1 not exist."
    exit 4
fi

if [ "$DEXDUMP" != "" ]; then
    $DEXDUMP -h $FILE |grep -B 2 PRIVATE |grep name > $DEBUG_FILE
    for line in `cat $DEBUG_FILE|grep name |sed -e 's/name.*:.*'\''\(.*\)'\''/\1/' |sed -e 's/^ *//'|awk '{print $1}'`
    do
	long=`echo -n $line |wc -c` 
	case $long in
	    1)
		ONECHAR=$(($ONECHAR + 1))
		;;
	    2)
		TWOCHAR=$(($TWOCHAR + 1))
		;;
	    *)
		OTHER=$(($OTHER + 1))
	esac
    done
else
    echo "dexdump not exist." 
    exit 5
fi

function print_summary () {
    echo -e "ONECHAR:\t$ONECHAR"
    echo -e "TWOCHAR:\t$TWOCHAR"
    echo -e "OTHER:\t\t$OTHER"
}

function print_verbose () {
    if [ -f $DEBUG_FILE ]; then
	cat $DEBUG_FILE
    fi
}

function clean () {
    if [ -d "$TMP" ]; then
	rm -r $TMP
    fi
}

function result () {
    local ans=`dc <<< "$ONECHAR $TWOCHAR + sa $OTHER la + sb la lb 2k / 100 *p " 2>/dev/null`
    ans=`echo $ans |awk -F'.' '{print $1}'`
    if [ $ans -gt 50 ]; then
	echo "It has been proguard.."
    else
	echo -e "It is \033[1;31mnot\033[0m been proguard.."
    fi
}

if [ "$summary" == "true" ]; then
    echo 'summary:'
    print_summary
fi

if [ "$verbose" == "true" ]; then
    echo 'verbose:'
    print_verbose
fi

result
clean 
exit 0

