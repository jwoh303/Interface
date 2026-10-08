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
export JBOSS_HOME=$UCUBE_HOME/engine/jboss


# Run application.
#
#

$JBOSS_HOME/bin/run.sh -c messaging

