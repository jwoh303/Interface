#! /bin/sh

clear

echo "Copyright (c) 2007 POSDATA Co., Ltd"
echo "All rights reserved."
echo ""
echo "Posdata u-CUBE Manager Startup Sequence Begin"

if [ -z "$UCUBE_HOME" ]
then
	echo "usage : Please set environment UCUBE_HOME"
	exit
fi

# Setting CLASS_PATH.
#
#
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
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/seadapter30.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xalan.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xerces.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xml-apis.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/QueueUtil.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/service/tc/sample/java
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/sqljdbc.jar

export CLASS_PATH

# Display our environment
#
#
echo "========================================================================="
echo ""
echo "  uCUBE Environment"
echo ""
echo "  UCUBE_HOME : $UCUBE_HOME"
echo ""
echo "  JAVA_HOME  : $JAVA_HOME"
echo ""
echo "  CLASS_PATH : $CLASS_PATH"
echo ""
echo "========================================================================="
echo ""


# Run application.
#
#
$JAVA_HOME/bin/java -classpath $CLASS_PATH:$UCUBE_HOME/service/tc/config/cfg SendTC $UCUBE_HOME/service/tc/config/cfg/SEND.xml
