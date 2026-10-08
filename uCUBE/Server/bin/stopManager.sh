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
/usr/ucb/ps -auxwww | grep "org.jboss.Main -c manager" | grep -v grep | awk '{print "kill " $2}' | sh -
#ps aux | grep "org.jboss.Main -c manager" | grep -v grep | awk '{print "kill " $2}' | sh -
