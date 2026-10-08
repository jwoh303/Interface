#! /bin/sh

clear

echo "Copyright (c) 2007 POSDATA Co., Ltd"
echo "All rights reserved."
echo "================================================"

echo "Posdata u-CUBE Manager Startup Sequence Begin"

# Setting JBOSS_HOME.
#
#
#
JBOSS_HOME=$UCUBE_HOME/manager/jboss
JAVA_OPTS="-DUCUBE_HOME=$UCUBE_HOME"
export JBOSS_HOME
export JAVA_OPTS


# Run application.
#
#

$JBOSS_HOME/bin/run.sh -c manager &
