#! /bin/sh

clear

echo "Copyright (c) 2007 POSDATA Co., Ltd"
echo "All rights reserved."
echo "================================================"

echo "Posdata u-CUBE Manager Stop Sequence Begin"

# Setting JBOSS_HOME.
#
#
#
JBOSS_HOME=$UCUBE_HOME/engine/jboss
export JBOSS_HOME


# Run application.
#
#

#$jBOSS_HOME/bin/shutdown.sh --shutdown --server=localhost:1099
/user/eai/uCUBE/engine/jboss/bin/shutdown.sh --shutdown --server=localhost:1099
