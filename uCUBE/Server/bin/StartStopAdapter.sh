#! /bin/sh

echo ""
echo "Copyright (c) 2010 POSCO ICT Co., Ltd"
echo "All rights reserved."
echo ""
echo "POSCO ICT u-CUBE adapter start/stop script begin"
echo ""

# variables
class_name="com.posdata.eai.adapter.ServiceBroker"
ifd_str="TEST-01-0001"
arg_0="$UCUBE_HOME/service/file/config/cfg/file_$ifd_str.cfg"
arg_1="$UCUBE_HOME/service/file/config/cfg/$ifd_str.xml"

# functions
print_usage () {
	echo "usage : $0 [start|stop]\n"
}

print_env_err () {
	echo "usage : Please set environment UCUBE_HOME\n"
}

check_pid () {
    pidfile=`find $UCUBE_HOME/bin/log/pid -name $ifd_str.pid`
    if [ -f "$pidfile" ]
    then
	echo "unable to start adapter: pid file already exists"
	echo "if process is not running, remove $pidfile and try again\n"
	exit
    fi
}

adapter_start() {
    # check pid file first
    check_pid
    # Setting CLASS_PATH.
    CLASS_PATH=$UCUBE_HOME/lib/seadapter30.jar
    CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jbossall-client.jar
    CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/log4j-1.2.11.jar

    export CLASS_PATH
    # Display our environment
    #
    echo "========================================================================="
    echo "  uCUBE Environment"
    echo "  UCUBE_HOME : $UCUBE_HOME"
    echo "  JAVA_HOME  : $JAVA_HOME"
    echo "  CLASS_PATH : $CLASS_PATH"
    echo "========================================================================="
    echo ""
    # Run application.
    $JAVA_HOME/bin/java -classpath $CLASS_PATH $class_name $arg_0 $arg_1 &
    echo `date +%y/%m/%d[%H:%M:%S]` $ifd_str $! > $UCUBE_HOME/bin/log/pid/$ifd_str.pid
}

adapter_stop () {
    pidfile=`find $UCUBE_HOME/bin/log/pid -name $ifd_str.pid`

    if [ -f "$pidfile" ]
    then
        pid=`cut -d" " -f3 $pidfile`
    	echo "killing process($pid) from $pidfile"
        kill $pid
        echo deleting Adapter pid file: $pidfile
        rm $pidfile
	echo ""
    else
	pidfile="$UCUBE_HOME/bin/log/pid/$ifd_str.pid"
	echo "adapter is not running"
	echo "file not found: $pidfile\n"
    fi
}

# main routine starts here
if [ -z "$UCUBE_HOME" ]
then
	print_env_err
	exit
fi

if [ -z "$1" ]
then
	print_usage
	exit
fi

case "$1" in
    start)
	adapter_start
	;;
    stop)
	adapter_stop
	;;
    *)
	print_usage
esac
