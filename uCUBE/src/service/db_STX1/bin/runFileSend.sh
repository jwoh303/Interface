#! /bin/sh

clear

. ./set_env.sh

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
CLASS_PATH=$UCUBE_HOME/lib/seadapter-client.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/jbossall-client.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/log4j-1.2.11.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xerces.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/lib/xml-apis.jar
CLASS_PATH=$CLASS_PATH:$UCUBE_HOME/service/tc/sample/java

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
$JAVA_HOME/bin/java -classpath $CLASS_PATH -Djavax.net.ssl.trustStore=$UCUBE_HOME/key/client.truststore -Djavax.net.ssl.trustStorePassword=xxxx com.posdata.eai.adapter.file.FileSend $UCUBE_HOME/service/file/config/cfg/file.cfg $UCUBE_HOME/service/file/config/cfg/UCUBE_FILESEND.xml &

echo `date +%y/%m/%d[%H:%M:%S]` `basename $0` $! > $UCUBE_HOME/bin/log/pid/`basename $0`.pid
