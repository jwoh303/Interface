#!/bin/sh
#
# JBoss Control Script
#
# chkconfig: 3 80 20
# description: JBoss EJB Container
# 
# To use this script
# run it as root - it will switch to the specified user
# It loses all console output - use the log.
#
# Here is a little (and extremely primitive) 
# startup/shutdown script for RedHat systems. It assumes 
# that JBoss lives in /usr/local/jboss, it's run by user 
# 'jboss' and JDK binaries are in /usr/local/jdk/bin. All 
# this can be changed in the script itself. 
# Bojan 
#
# Either amend this script for your requirements
# or just ensure that the following variables are set correctly 
# before calling the script

# [ #420297 ] JBoss startup/shutdown for RedHat

### First Check The arguments ###
if [ $# -ne 2 ]; then
    echo "usage: $0 Messaging_Name (status|start|stop|restart|help)"
    exit;
fi

# First find the path for setenv_unix.sh file
. $HOME/test/setenv_unix.sh
echo $JBOSS_HOME
#define where jboss is - this is the directory containing directories log, bin, conf etc
JBOSS_HOME=${JBOSS_HOME:-"/usr/local/jboss"}

#make java is on your path
JAVAPTH=${JAVAPTH:-"/usr/local/jdk/bin"}

#define the classpath for the shutdown class
JBOSSCP=${JBOSSCP:-"$JBOSS_HOME/bin/shutdown.jar:$JBOSS_HOME/client/jnet.jar"}

case "$1" in
messaging)
	#define the script to use to start messaging
	JBOSSSH=${JBOSSSH:-"$JBOSS_HOME/bin/run.sh -c messaging"}
	JBOSSSD=${JBOSSSD:-"$JBOSS_HOME/bin/shutdown.sh --shutdown --server=localhost:1099"}
	if [ $2 = "start" ]; then
		echo "Copy jbossmq-destinations-service.xml File"
		cp $JBOSS_HOME/server/messaging/deploy/jms/jbossmq-destinations-service.xml $JBOSS_HOME/server/messaging/deploy/jms/jbossmq-destinations-service.xml_`date +'%y%m%d-%R'`.bak
		cp $HOME/test/ucube/service/util/cfg/messaging/jbossmq-destinations-service.xml $JBOSS_HOME/server/messaging/deploy/jms
	fi
    	;;
manager)
	#define the script to use to start messaging
	JBOSSSH=${JBOSSSH:-"$JBOSS_HOME/bin/run.sh -c manager"}
	JBOSSSD=${JBOSSSD:-"$JBOSS_HOME/bin/shutdown.sh --shutdown --server=localhost:1089"}
    	;;
*)
	echo "usage: $0 Messaging_Name (start|stop|restart|help)"
esac

#define the script to use to start jboss
#JBOSSSH=${JBOSSSH:-"$JBOSS_HOME/bin/run.sh -c all"}
#JBOSSSD=${JBOSSSD:-"$JBOSS_HOME/bin/shutdown.sh --shutdown"}

if [ -n "$JBOSS_CONSOLE" -a ! -d "$JBOSS_CONSOLE" ]; then
  # ensure the file exists
  touch $JBOSS_CONSOLE
fi

if [ -n "$JBOSS_CONSOLE" -a ! -f "$JBOSS_CONSOLE" ]; then
  echo "WARNING: location for saving console log invalid: $JBOSS_CONSOLE"
  echo "WARNING: ignoring it and using /dev/null"
  JBOSS_CONSOLE="/dev/null"
fi

#define what will be done with the console log
JBOSS_CONSOLE=${JBOSS_CONSOLE:-"/DIPPED01/EAI2/uCUBE/MES/log/jboss/$1_`date +'%y%m%d-%R'`.log"}

#define the user under which jboss will run, or use RUNASIS to run as the current user
JBOSSUS=${JBOSSUS:-"eai2test"}

CMD_START="$JBOSSSH"
#CMD_STOP="cd $JBOSS_HOME/bin; $JBOSSSD"
CMD_STOP="$JBOSSSD"
#CMD_START="cd $JBOSS_HOME/bin; $JBOSSSH" 
#CMD_STOP="java -classpath $JBOSSCP org.jboss.Shutdown --shutdown"

if [ "$JBOSSUS" = "RUNASIS" ]; then
  SUBIT=""
else
  SUBIT=""
  #SUBIT="su - $JBOSSUS -c "
fi

if [ -z "`echo $PATH | grep $JAVAPTH`" ]; then
  export PATH=$PATH:$JAVAPTH
fi

if [ ! -d "$JBOSS_HOME" ]; then
  echo JBOSS_HOME does not exist as a valid directory : $JBOSS_HOME
  exit 1
fi


#echo CMD_START = $CMD_START


case "$2" in
status)
    if [ `ps -exf | grep -v grep | grep $1 | wc -l` = 1 ]; then
	echo "$1 is stopped"
    else 
	echo "$1 is running"
    fi
    ;;
start)
    cd $JBOSS_HOME/bin
    if [ -z "$SUBIT" ]; then
        eval $CMD_START >${JBOSS_CONSOLE} 2>&1 &
    else
        $SUBIT "$CMD_START >${JBOSS_CONSOLE} 2>&1 &" 
    fi
    echo "Check the $JBOSS_CONSOLE"
    ;;
stop)
    if [ -z "$SUBIT" ]; then
        $CMD_STOP
    else
        $SUBIT "$CMD_STOP"
    fi 
    ;;
restart)
    $0 $1 stop
    $0 $1 start
    ;;
*)
	echo "usage: $0 (jbossmq1|jbossmq2|jbossmq3) (start|stop|restart|help)"
esac


