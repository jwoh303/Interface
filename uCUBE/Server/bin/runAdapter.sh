#! /bin/bash


echo "SEAdapter Startup Sequence Begin"

# Usage of this script
#
usage()
{
    echo
    echo "USAGE ::"
    echo "runAdapter.sh -f <Configxmlfilepath> "
    echo
    echo "Example to start the Adapter of all the queue in configuration:: "
    echo "runAdapter.sh -d . -a all"
    echo
    echo "Example to start the Adapter of the specified queue in configuration:: "
    echo "runAdapter.sh -f ~/ucube/config/cfg/http/M00Z_M00Z_TS01.xml"
    echo
}

# check_process of this script
#
function check_process
{
        filename=`basename $1`

        chkfile=$UCUBE_HOME/bin/log/pid/$filename.pid
        if [ -n "$chkfile" ]
        then
                if [ -f "$chkfile" ]
                then
                        process=`ps -u \`whoami\` | grep \`awk '{print $3}' $chkfile\``
                        if [ "$process" = "" ]
                        then
                                echo "File \"$chkfile\" exist, but Procsse is not running"
                                echo "so Remove file \"$chkfile\" and Start \"$filename\" "
                                rm -rf $chkfile
                                return 1
                        else
                                echo "*****ERROR *********"
                                echo "File \"$chkfile\" exist. Maybe Adapter exist. Check the log"
                                return 0
                        fi
                else
                        return 1
                fi
        fi

}

# Check if the number of command line arguments.
#

if [ $# -lt 1 ]
then
    usage
    exit
fi

# Parsing function to parse the command line arguments of the script
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

# Parse the command line arguments of the script
#
#this option means $@ The entire list of arguments, treated as a series of words.
#

parse_args $@

# Set CLASSPATH.
#
# If the classpath already exists, prepend with classpath
# otherwise, create a classpath
CLASS_PATH=$UCUBE_HOME/lib/classes12.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/common.zip
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/edtftpj.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/fmprtl.zip
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/http_client.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jboss-system.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jbossall-client.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jbossmq.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jdom.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/log4j-1.2.11.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/saxpath.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/seadapter.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xalan.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xerces.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xml-apis.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/QueueUtil.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/sqljdbc.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/mysql-connector-java-3.1.8-bin.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/mail.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/activation-1.0.2.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/activation.jar


export CLASS_PATH
echo "CLASS_PATH set to $CLASS_PATH \n"

# Check the existence of Config Xml file and Run Adapter
#
if [ "$flag" = "true" ]
then
        echo "Starting the lines of Adapter"
        Configfile=`echo $Configfile | sed 's/\.xml//'`
	for temp in `ls $Configfile*.xml`
        do
                check_process $temp
                return_val=$?
                if [ "$return_val" -eq 1 ]
                then
                        echo run Adapter configFile : $temp
                        $JAVA_HOME/bin/java -Xms128m -Xmx256m -DCONFIG_FILE_PATH=$temp -classpath $CLASS_PATH com.posdata.eai.adapter.AdapterHandler >/dev/null &
                        filename=`basename $temp`
                        echo `date +%y/%m/%d[%H:%M:%S]` $filename $! > $UCUBE_HOME/bin/log/pid/$filename.pid
                fi
        done
        exit
fi

# Start the communication of all Adapter
# To start all the Adapter in the special directory
#
if [ "$allfalg" != "all" ] ;
 then
        echo "All the lines option is not set "
else
        echo "Starting all the lines of Adapter."
        for temp in $(find "$dir" -name "*.xml")
        do
                check_process $temp
                return_val=$?
                if [ "$return_val" -eq 1 ]
                then
                        echo run Adpater configfile : $temp
                        $JAVA_HOME/bin/java -Xms128m -Xmx256m -DCONFIG_FILE_PATH=$temp -classpath $CLASS_PATH com.posdata.eai.adapter.AdapterHandler >/dev/null &
                        filename=`basename $temp`
                        echo `date +%y/%m/%d[%H:%M:%S]` $filename $! > $UCUBE_HOME/bin/log/pid/$filename.pid
                fi
        done
        exit

fi
