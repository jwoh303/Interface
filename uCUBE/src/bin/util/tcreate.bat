@echo off

echo Copyright (c) 2010 POSCO ICT Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting CLASS_PATH.
set CLASS_PATH="%UCUBE_HOME%"\lib\QueueUtil.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossall-client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossmq.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jboss-system.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\log4j-1.2.11.jar

REM Check if the number of command line arguments.

IF "%1" == "" goto usage

REM define argument
set Configfile="%UCUBE_HOME%"\engine\jboss\server\%1\conf\jboss-service.xml
set queuelistfile="%UCUBE_HOME%"\engine\jboss\server\%1\ucube\jbossmq-destinations-service.xml

REM  create Queue using the command below.

%JAVA_HOME%\bin\java -DOPTION=CREATETOPIC -classpath %CLASS_PATH% QueueCreater %Configfile% %queuelistfile%

goto end

:usage
echo "Example to create Queue "
echo "usage : %0 MQ_NAME"
goto end

:end
