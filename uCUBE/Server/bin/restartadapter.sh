#! /bin/sh 

killAdapter.sh $1 $2

sleep 5

runBroker.sh $1 $2
