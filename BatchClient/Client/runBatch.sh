# Usage of this script
usage()
{
  echo
  echo "USAGE :: "
  echo
  echo Input Class Name
  echo $0 ClassName
  echo
}

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
export BATCH_HOME=/EAI/B2B/java/kepmp/batch/BatchClient/Client

# script start

$JAVA_HOME/bin/java -Dlog4j.configuration=file:$BATCH_HOME/log4j_cloud.properties -jar -Xms64m -Xmx128m $BATCH_HOME/BatchClient.jar $1 $2 $3 $4

fi