@echo off
cls

call set_env.bat

echo Copyright (c) 2007 POSDATA Co., Ltd
echo All rights reserved.

echo Posdata u-CUBE User compilation batch file

if {"%UCUBE_HOME%"}=={} goto usage
if {"%JAVA_HOME%"}=={} goto usage

REM Setting CLASS_PATH.

set CLASS_PATH="%UCUBE_HOME%"\lib\seadapter-client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\log4j-1.2.11.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\jbossall-client.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xerces.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\lib\xml-apis.jar
set CLASS_PATH=%CLASS_PATH%;"%UCUBE_HOME%"\service\tc\sample\java

echo ===============================================================================
echo   uCUBE Environment
echo UCUBE_HOME : "%UCUBE_HOME%"
echo JAVA_HOME  : "%JAVA_HOME%"
echo CLASS_PATH : %CLASS_PATH%
echo ===============================================================================


echo Starting run 
"%JAVA_HOME%"\bin\java -Djavax.net.ssl.trustStore="%UCUBE_HOME%"\key\client.truststore -Djavax.net.ssl.trustStorePassword=xxxx -Dhttp.proxyHost=192.168.0.1 -Dhttp.proxyPort=8080 -Dorg.jboss.security.ignoreHttpsHost=true -classpath %CLASS_PATH%;"%UCUBE_HOME%"\service\tc\config\cfg com.posdata.eai.adapter.file.GetFile "%UCUBE_HOME%"\service\httpfile\config\cfg\UCUBE_FILERECV.xml
echo End run
goto end

:usage
echo usage : Please set environment UCUBE_HOME or JAVA_HOME
goto end

:end

