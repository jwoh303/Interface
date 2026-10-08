# Check argument number
if [ $# -lt 1 ]
then
  usage
  exit
fi


COUNT=`ps -ef | grep $1 | grep -v grep | wc -l`

echo - COUNT : $COUNT

if [ $COUNT -eq 0 ]
then

export JAVA_HOME=/usr/local/jdk1.8
export BATCH_HOME=/EAI/B2B/java/kepmp/batch/KolonSap/Consumer

# script start

$JAVA_HOME/bin/java -Dlog4j.configuration=file:$BATCH_HOME/log4j_cloud.properties -jar -Xms64m -Xmx128m $BATCH_HOME/kep_ws_demon.jar $1 $2

fi