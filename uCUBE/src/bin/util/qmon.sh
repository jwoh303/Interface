#! /bin/sh

clear

echo "Copyright (c) 2007 POSDATA Co., Ltd"
echo "All rights reserved."
echo "================================================"

echo "Posdata u-CUBE Manager Startup Sequence Begin"

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

export CLASSPATH
echo "CLASSPATH set to $CLASSPATH \n" 

# set the qmonitor file
#
#

Configfile=$UCUBE_HOME/bin/util/qmonitor.xml

# Run SEAdapter using the command below.
#
#
$JAVA_HOME/bin/java -Xms128m -Xmx256m -DCONFIG_FILE_PATH=$Configfile -classpath $CLASS_PATH com.posdata.eai.adapter.AdapterHandler

