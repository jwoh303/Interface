@echo off
cls


echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting CLASS_PATH.


set CLASS_PATH="%UCUBE_HOME%"\lib\classes12.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\saxon9.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\common.zip
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\edtftpj.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\fmprtl.zip
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\http_client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jboss-system.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossall-client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossmq.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jdom.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\log4j-1.2.11.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\saxpath.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\seadapter30.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xalan.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xerces.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xml-apis.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\QueueUtil.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\sqljdbc.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\classes12.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\quartz-all-1.7.3.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\commons-logging.jar

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : %JAVA_HOME%
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


echo Starting run 
"%JAVA_HOME%"\bin\java -Xms128m -Xmx256m -DCONFIG_FILE_PATH="C:\uCUBE\service\dbsender\config\cfg\RDB2XML_SCHEDULER.xml" -classpath .;%CLASS_PATH%; com.posdata.eai.adapter.ServiceBrokerHandler
echo End run
goto end

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

