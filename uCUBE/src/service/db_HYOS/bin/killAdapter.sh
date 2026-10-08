#! /bin/sh

. ./set_env.sh
echo "SEAdapter Stop Sequence Begin"

# 1. Usage of this script
#
usage()
{
    echo
    echo "USAGE ::"
    echo "killAdapter.sh -f <Configxmlfilepath> "
    echo
    echo "Example to stop the Adapter of all the queue in configuration:: "
    echo "killAdapter.sh -d . -a all"
    echo
    echo "Example to stop the Adapter of the specified queue in configuration:: "
    echo "killAdpter.sh -f ~/ucube/config/cfg/http/M00Z_M00Z_TS01.xml"
    echo
}

# 2. Check if the number of command line arguments.
#

if [ $# -lt 2 ]
then
    usage
    exit
fi

#3. Parsing function to parse the command line arguments of the script
#
function parse_args # [args ...]
{
        typeset opt

        while getopts 'f:d:a:?' opt
        do
                case "$opt" in
                f)
                        # Name of the Configfile resource.
			flag=true
                        Configfile=$OPTARG
                        ;;
                a)
                        allfalg=$OPTARG
                        ;;
                d)
                        dir=$OPTARG
                        ;;
                ?)
                        usage
                        exit
                        ;;
                esac

        done
}

# 4. Parse the command line arguments of the script
#
#this option means $@ The entire list of arguments, treated as a series of words.
#

parse_args $@

# 5. Check the existence of Config Xml file
#
if [  "$flag" = "true" ]
then
        echo "Stop all the lines of System."
        Configfile=`echo $Configfile | sed 's/\.xml//'`
        for temp in `ls $Configfile*.xml`
        do
        if [ -f $temp ]
        then
		temp=`ls $temp | sed 's/^.*\/\([a-zA-Z0-9._]*\).*$/\1/'`
                echo kill Adpater configfile : $temp
                pidfile=`find $UCUBE_HOME/bin/log/pid -name *.pid | grep $temp`
                if [ -f "$pidfile" ]
                then
                                pid=`cut -d" " -f3 $pidfile`
                                kill $pid

                                echo delete Adapter pidFile : $pidfile
                                rm $pidfile
                fi
        fi
        done
        exit

fi

# 6. kill the communication of all Adapter
# To kill all the Adapter in the special directory
#
if [ "$allfalg" != "all" ] ;
 then
        echo "All the lines option is not set "
else
        echo "Stop all the lines of System."
        for temp in `ls $dir/*.xml`
        do
        if [ -f $temp ]
        then
                echo kill Adpater configfile : $temp
                temp=`basename $temp`
                pidfile=`find $UCUBE_HOME/bin/log/pid | grep $temp`
                if [ -n "$pidfile" ]
                then
                        if [ -f "$pidfile" ]
                        then
                                pid=`cut -d" " -f3 $pidfile`
                                kill $pid

                                echo delete Adapter pidFile : $pidfile
                                rm $pidfile
                        fi
                fi
        fi
        done
        exit

fi

# 7.  kill SEAdapter using the command below.
#
#
echo kill Adpater configfile : $Configfile
pidfile=`find $UCUBE_HOME/bin/log/pid -name *.pid | grep $Configfile`

if [ -n "$pidfile" ]
then
        if [ -f "$pidfile" ]
        then
		pid=`cut -d" " -f3 $pidfile`
		kill $pid

		echo delete Adapter pidFile : $pidfile
		rm $pidfile
        fi
fi
