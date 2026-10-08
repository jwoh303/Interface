#! /bin/sh

# Usage of this script
#
usage()
{
    echo
    echo "USAGE ::"
    echo
    echo "Example to create Queue "
    echo "`basename $0` MQ_NAME"
    echo
}

# Check if the number of command line arguments.
#
if [ $# -lt 1 ]
then
    usage
    exit
fi

# define argument
Configfile=$UCUBE_HOME/engine/jboss/server/$1/conf/jboss-service.xml
queuelistfile=$UCUBE_HOME/engine/jboss/server/$1/ucube/jbossmq-destinations-service.xml

# Check the existence of Config Xml file
#
if [ -n "$ConfigFile" ]
then
        if [ ! -f "$Configfile" ]
        then
          echo "*****ERROR *********"
          exit $E_NOFILE
        fi
fi

if [ -n "$queuelistfile" ]
then
        if [ ! -f "$queuelistfile" ]
        then
          echo "*****ERROR *********"
          exit $E_NOFILE
        fi
fi

# Set CLASSPATH.
#
# If the classpath already exists, prepend with classpath
# otherwise, create a classpath
if [ -z "$CLASSPATH" ]
then
    CLASSPATH="$UCUBE_HOME/lib/jbossall-client.jar:$UCUBE_HOME/lib/jbossmq.jar:$UCUBE_HOME/lib/jboss-system.jar:$UCUBE_HOME/lib/jbossmq.jar:$UCUBE_HOME/lib/QueueUtil.jar"
else
    CLASSPATH="$CLASSPATH:$UCUBE_HOME/lib/jbossall-client.jar:$UCUBE_HOME/lib/jbossmq.jar:$UCUBE_HOME/lib/jboss-system.jar:$UCUBE_HOME/lib/jbossmq.jar:$UCUBE_HOME/lib/QueueUtil.jar"

fi
export CLASSPATH

# 6.  create Queue using the command below.
#
#
$JAVA_HOME/bin/java -DENCODING_VALUE="UTF-8" -DOPTION=TRUNCATEQUEUE -classpath $CLASSPATH QueueCreater $Configfile $queuelistfile
